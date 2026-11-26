use super::Ctx;
use gtk4 as gtk;
use gtk::prelude::*;
use gtk::glib;
use std::rc::Rc;

type Report = Rc<dyn Fn(&str, &str)>;
type OnChange = Rc<dyn Fn()>;

fn count(kind: &str) -> u32 {
    crate::source::run_once(&format!("dunstctl count {kind}"))
        .trim()
        .parse()
        .unwrap_or(0)
}

fn update_indicator(button: &gtk::Button, report: &Report) {
    let total = count("history");
    if total > 0 {
        report(&total.to_string(), "");
        button.add_css_class("has-notifications");
    } else {
        report("", "");
        button.remove_css_class("has-notifications");
    }
}

pub fn build(ctx: &Ctx) -> gtk::Widget {
    let button = gtk::Button::from_icon_name(&ctx.cfg.icon.clone().unwrap_or_else(|| "notifications-symbolic".into()));
    button.add_css_class("notification-button");
    button.add_css_class("widget-button");
    
    let report: Report = ctx.report.clone();
    
    // Initial check on startup
    update_indicator(&button, &report);
    
    // Re-check whenever a notification arrives or is closed.
    // dbus-monitor prints several lines per message; only react to the header lines we care about.
    {
        let button = button.clone();
        let report = report.clone();
        glib::spawn_future_local(async move {
            let rx = crate::source::lines("dbus-monitor \"interface='org.freedesktop.Notifications'\"");
            while let Ok(line) = rx.recv().await {
                let relevant = (line.starts_with("method call") || line.starts_with("signal"))
                    && (line.contains("member=Notify") || line.contains("member=NotificationClosed"));
                if relevant {
                    // dunst emits the signal slightly before the notification reaches history.
                    glib::timeout_future(std::time::Duration::from_millis(200)).await;
                    update_indicator(&button, &report);
                }
            }
        });
    }
    
    {
        let button_c = button.clone();
        button.connect_clicked(move |_| {
            let b = button_c.clone();
            let r = report.clone();
            let on_change: OnChange = Rc::new(move || update_indicator(&b, &r));
            open_notifications_window(on_change);
        });
    }
    
    button.upcast::<gtk::Widget>()
}

fn open_notifications_window(on_change: OnChange) {
    let win = gtk::Window::builder()
        .title("Notifications")
        .default_width(340)
        .default_height(420)
        .modal(true)
        .build();
    
    win.add_css_class("notifications-window");
    
    let vbox = gtk::Box::new(gtk::Orientation::Vertical, 10);
    vbox.set_margin_start(12);
    vbox.set_margin_end(12);
    vbox.set_margin_top(12);
    vbox.set_margin_bottom(12);
    
    let header_box = gtk::Box::new(gtk::Orientation::Horizontal, 8);
    let title_label = gtk::Label::new(Some("Notifications"));
    title_label.set_halign(gtk::Align::Start);
    title_label.set_hexpand(true);
    title_label.add_css_class("title-label");
    
    let scroll = gtk::ScrolledWindow::new();
    scroll.set_vexpand(true);
    scroll.set_policy(gtk::PolicyType::Never, gtk::PolicyType::Automatic);
    
    let list_box = gtk::ListBox::new();
    list_box.add_css_class("notification-list");
    scroll.set_child(Some(&list_box));

    let clear_all_btn = gtk::Button::with_label("Clear All");
    {
        let lb = list_box.clone();
        let on_change = on_change.clone();
        clear_all_btn.connect_clicked(move |_| {
            // Close anything currently on screen, then wipe the history.
            crate::source::spawn("dunstctl close-all");
            crate::source::spawn("dunstctl history-clear");
            let lb = lb.clone();
            let on_change = on_change.clone();
            glib::timeout_add_local_once(std::time::Duration::from_millis(150), move || {
                refresh_notifications(&lb, &on_change);
                on_change();
            });
        });
    }
    
    header_box.append(&title_label);
    header_box.append(&clear_all_btn);
    vbox.append(&header_box);
    vbox.append(&scroll);
    
    win.set_child(Some(&vbox));
    
    refresh_notifications(&list_box, &on_change);
    
    win.present();
}

struct Entry {
    id: i64,
    app: String,
    summary: String,
    body: String,
}

fn field<'a>(item: &'a serde_json::Value, key: &str) -> Option<&'a serde_json::Value> {
    let v = item.get(key)?;
    Some(v.get("data").unwrap_or(v))
}

fn find_items(v: &serde_json::Value) -> Option<&Vec<serde_json::Value>> {
    let arr = v.get("data").unwrap_or(v).as_array()?;
    if arr.first().map_or(false, |x| x.is_array()) {
        arr[0].as_array()
    } else {
        Some(arr)
    }
}

fn fetch_history() -> Vec<Entry> {
    // `source::run_once` keeps only the first line, but the history JSON is multi-line.
    let raw = std::process::Command::new("dunstctl")
        .arg("history")
        .stdin(std::process::Stdio::null())
        .stderr(std::process::Stdio::null())
        .output()
        .map(|o| String::from_utf8_lossy(&o.stdout).into_owned())
        .unwrap_or_default();
    let json = match serde_json::from_str::<serde_json::Value>(&raw) {
        Ok(j) => j,
        Err(e) => {
            let head: String = raw.chars().take(200).collect();
            eprintln!("dash: cannot parse `dunstctl history` ({e}); output starts: {head:?}");
            return Vec::new();
        }
    };
    let Some(items) = find_items(&json) else {
        eprintln!("dash: unexpected `dunstctl history` layout");
        return Vec::new();
    };

    let s = |item: &serde_json::Value, key: &str| -> String {
        field(item, key).and_then(|v| v.as_str()).unwrap_or("").trim().to_string()
    };

    items
        .iter()
        .map(|item| {
            let mut body = s(item, "body");
            if body.is_empty() {
                body = s(item, "message");
            }
            Entry {
                id: field(item, "id").and_then(|v| v.as_i64()).unwrap_or(-1),
                app: s(item, "appname"),
                summary: s(item, "summary"),
                body,
            }
        })
        .collect()
}

fn refresh_notifications(list_box: &gtk::ListBox, on_change: &OnChange) {
    while let Some(child) = list_box.first_child() {
        list_box.remove(&child);
    }
    
    let entries = fetch_history();
    
    if entries.is_empty() {
        let lbl = gtk::Label::new(Some("No notifications"));
        lbl.set_margin_top(50);
        list_box.append(&lbl);
        return;
    }
    
    for e in entries {
        let row_box = gtk::Box::new(gtk::Orientation::Horizontal, 8);
        row_box.set_margin_top(8);
        row_box.set_margin_bottom(8);
        
        let text_box = gtk::Box::new(gtk::Orientation::Vertical, 3);
        text_box.set_hexpand(true);
        
        if !e.app.is_empty() {
            let app_lbl = gtk::Label::new(Some(&e.app));
            app_lbl.set_halign(gtk::Align::Start);
            app_lbl.add_css_class("notification-app");
            text_box.append(&app_lbl);
        }
        
        let summary_lbl = gtk::Label::new(Some(&e.summary));
        summary_lbl.set_halign(gtk::Align::Start);
        summary_lbl.set_xalign(0.0);
        summary_lbl.set_wrap(true);
        summary_lbl.add_css_class("notification-summary");
        text_box.append(&summary_lbl);
        
        if !e.body.is_empty() {
            let body_lbl = gtk::Label::new(Some(&e.body));
            body_lbl.set_halign(gtk::Align::Start);
            body_lbl.set_xalign(0.0);
            body_lbl.set_wrap(true);
            body_lbl.add_css_class("notification-body");
            text_box.append(&body_lbl);
        }
        
        row_box.append(&text_box);
        
        let dismiss_btn = gtk::Button::with_label("✕");
        dismiss_btn.add_css_class("dismiss-button");
        dismiss_btn.set_valign(gtk::Align::Start);
        let lb = list_box.clone();
        let on_change = on_change.clone();
        let id = e.id;
        
        dismiss_btn.connect_clicked(move |_| {
            crate::source::spawn(&format!("dunstctl history-rm {id}"));
            let lb = lb.clone();
            let on_change = on_change.clone();
            glib::timeout_add_local_once(std::time::Duration::from_millis(150), move || {
                refresh_notifications(&lb, &on_change);
                on_change();
            });
        });
        
        row_box.append(&dismiss_btn);
        
        let row = gtk::ListBoxRow::new();
        row.set_child(Some(&row_box));
        list_box.append(&row);
    }
}
