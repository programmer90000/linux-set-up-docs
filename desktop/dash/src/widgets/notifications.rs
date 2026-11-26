use super::Ctx;
use gtk4 as gtk;
use gtk::prelude::*;
use gtk::glib;

pub fn build(ctx: &Ctx) -> gtk::Widget {
    let button = gtk::Button::from_icon_name(&ctx.cfg.icon.clone().unwrap_or_else(|| "notifications-symbolic".into()));
    button.add_css_class("notification-button");
    button.add_css_class("widget-button");
    
    let report = ctx.report.clone();
    let button_clone = button.clone();
    
    // Initial check on startup
    let initial_output = crate::source::run_once("fnottctl list");
    if !initial_output.trim().is_empty() {
        report(&initial_output, "");
        button.add_css_class("has-notifications");
    }
    
    glib::spawn_future_local(async move {
        let rx = crate::source::lines("dbus-monitor \"interface='org.freedesktop.Notifications'\"");
        while let Ok(_line) = rx.recv().await {
            let output = crate::source::run_once("fnottctl list");
            let has_notifs = !output.trim().is_empty();
            let report_val = if has_notifs { output.clone() } else { "".to_string() };
            
            report(&report_val, "");
            if has_notifs {
                button_clone.add_css_class("has-notifications");
            } else {
                button_clone.remove_css_class("has-notifications");
            }
        }
    });
    
    button.connect_clicked(move |_| {
        open_notifications_window();
    });
    
    button.upcast::<gtk::Widget>()
}

fn open_notifications_window() {
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
    
    let clear_all_btn = gtk::Button::with_label("Clear All");
    clear_all_btn.connect_clicked(move |_| {
        crate::source::spawn("fnottctl dismiss all");
    });
    
    header_box.append(&title_label);
    header_box.append(&clear_all_btn);
    vbox.append(&header_box);
    
    let scroll = gtk::ScrolledWindow::new();
    scroll.set_vexpand(true);
    scroll.set_policy(gtk::PolicyType::Never, gtk::PolicyType::Automatic);
    
    let list_box = gtk::ListBox::new();
    list_box.add_css_class("notification-list");
    scroll.set_child(Some(&list_box));
    vbox.append(&scroll);
    
    win.set_child(Some(&vbox));
    
    let lb_clone = list_box.clone();
    refresh_notifications(&lb_clone);
    
    win.present();
}

fn refresh_notifications(list_box: &gtk::ListBox) {
    while let Some(child) = list_box.first_child() {
        list_box.remove(&child);
    }
    
    let output = crate::source::run_once("fnottctl list");
    let lines: Vec<&str> = output.lines().filter(|l| !l.trim().is_empty()).collect();
    
    if lines.is_empty() {
        let lbl = gtk::Label::new(Some("No notifications"));
        lbl.set_margin_top(50);
        list_box.append(&lbl);
        return;
    }
    
    for line in lines {
        let parts: Vec<&str> = line.splitn(2, ':').collect();
        let id = parts.first().unwrap_or(&"").trim();
        let content = parts.get(1).unwrap_or(&line).trim();
        
        let row_box = gtk::Box::new(gtk::Orientation::Horizontal, 8);
        row_box.set_margin_top(8);
        row_box.set_margin_bottom(8);
        
        let text_box = gtk::Box::new(gtk::Orientation::Vertical, 3);
        text_box.set_hexpand(true);
        
        let content_lbl = gtk::Label::new(Some(content));
        content_lbl.set_halign(gtk::Align::Start);
        content_lbl.set_wrap(true);
        content_lbl.add_css_class("notification-summary");
        text_box.append(&content_lbl);
        
        row_box.append(&text_box);
        
        let dismiss_btn = gtk::Button::with_label("✕");
        dismiss_btn.add_css_class("dismiss-button");
        let lb_clone = list_box.clone();
        let id_string = id.to_string();
        
        dismiss_btn.connect_clicked(move |_| {
            crate::source::spawn(&format!("fnottctl dismiss {id_string}"));
            let lb_clone = lb_clone.clone();
            glib::timeout_add_local_once(std::time::Duration::from_millis(150), move || {
                refresh_notifications(&lb_clone);
            });
        });
        
        row_box.append(&dismiss_btn);
        
        let row = gtk::ListBoxRow::new();
        row.set_child(Some(&row_box));
        list_box.append(&row);
    }
}
