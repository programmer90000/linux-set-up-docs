use super::{command::{build as cmd, Defaults}, Ctx};
use gtk4::prelude::*;
use gtk4 as gtk;
use std::process::Command;
use std::rc::Rc;

pub fn build(ctx: &Ctx) -> gtk::Widget {
    let current_exe = std::env::current_exe()
        .map(|p| p.to_string_lossy().into_owned())
        .unwrap_or_else(|_| "dash".to_string());
    
    let click_cmd = format!("{} --show-copyq-popup", current_exe);
    let static_click_cmd: &'static str = Box::leak(click_cmd.into_boxed_str());

    cmd(ctx, Defaults {
        kind: "copyq", icon: "📋",
        watch: Some("wl-paste --watch echo changed"),
        command: Some("copyq count"),
        on_click: Some(static_click_cmd),
        ..Default::default()
    })
}

fn fetch_copyq_items() -> Vec<String> {
    let count_output = Command::new("copyq")
        .arg("count")
        .output();
    
    let count = match count_output {
        Ok(res) if res.status.success() => {
            String::from_utf8_lossy(&res.stdout)
                .trim()
                .parse::<usize>()
                .unwrap_or(0)
        }
        Ok(res) => {
            let err = String::from_utf8_lossy(&res.stderr);
            return vec![format!("CopyQ error: {}", err.trim())];
        }
        Err(e) => return vec![format!("Failed to run copyq: {}", e)],
    };
    
    let mut items = Vec::new();
    for i in 0..count {
        let item_output = Command::new("copyq")
            .arg("read")
            .arg(i.to_string())
            .output();
        
        if let Ok(res) = item_output {
            if res.status.success() {
                let text = String::from_utf8_lossy(&res.stdout);
                // Flatten multi-line items into a single line for clean UI display
                let single_line = text.lines().collect::<Vec<&str>>().join(" ");
                if !single_line.trim().is_empty() {
                    items.push(single_line);
                }
            }
        }
    }
    
    items
}

pub fn show_custom_copyq_window(app: &gtk::Application) {
    let window = gtk::ApplicationWindow::new(app);
    window.set_title(Some("Custom CopyQ Viewer"));
    window.set_default_size(420, 520);
    window.set_resizable(true);
    window.set_decorated(false);
    
    let vbox = gtk::Box::new(gtk::Orientation::Vertical, 8);
    vbox.set_margin_start(12);
    vbox.set_margin_end(12);
    vbox.set_margin_top(12);
    vbox.set_margin_bottom(12);
    
    let header_box = gtk::Box::new(gtk::Orientation::Horizontal, 8);
    let header = gtk::Label::new(Some("<b>Clipboard History</b>"));
    header.set_use_markup(true);
    header.set_xalign(0.0);
    header.set_hexpand(true);
    header_box.append(&header);
    
    let close_btn = gtk::Button::with_label("✕");
    let win_clone_close = window.clone();
    close_btn.connect_clicked(move |_| {
        win_clone_close.close();
    });
    header_box.append(&close_btn);
    vbox.append(&header_box);
    
    let list_box = gtk::ListBox::new();
    list_box.set_selection_mode(gtk::SelectionMode::Single);
    
    let scrolled = gtk::ScrolledWindow::new();
    scrolled.set_vexpand(true);
    scrolled.set_child(Some(&list_box));
    vbox.append(&scrolled);
    
    let list_box_clone = list_box.clone();
    let populate_list = Rc::new(move || {
        while let Some(child) = list_box_clone.first_child() {
            list_box_clone.remove(&child);
        }
        
        let items = fetch_copyq_items();
        if items.is_empty() {
            let empty_label = gtk::Label::new(Some("No clipboard items found."));
            empty_label.set_margin_top(20);
            empty_label.set_margin_bottom(20);
            list_box_clone.append(&empty_label);
        } else {
            for item in items {
                let row_label = gtk::Label::new(Some(&item));
                row_label.set_xalign(0.0);
                row_label.set_ellipsize(gtk::pango::EllipsizeMode::End);
                row_label.set_max_width_chars(50);
                row_label.set_margin_top(6);
                row_label.set_margin_bottom(6);
                row_label.set_margin_start(6);
                row_label.set_margin_end(6);
                list_box_clone.append(&row_label);
            }
        }
    });
    
    populate_list();
    
    let window_activate = window.clone();
    list_box.connect_row_activated(move |_, row| {
        let index = row.index();
        if index >= 0 {
            let _ = Command::new("copyq")
                .arg("select")
                .arg(index.to_string())
                .spawn();
            window_activate.close();
        }
    });
    
    window.set_child(Some(&vbox));
    window.present();
}
