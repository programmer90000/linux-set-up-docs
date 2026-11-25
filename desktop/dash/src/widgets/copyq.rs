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
    
    let action_box = gtk::Box::new(gtk::Orientation::Horizontal, 8);
    action_box.set_halign(gtk::Align::Center);
    action_box.set_margin_top(4);
    
    let new_btn = gtk::Button::with_label("New Item");
    let edit_btn = gtk::Button::with_label("Edit");
    let delete_btn = gtk::Button::with_label("Delete");
    
    action_box.append(&new_btn);
    action_box.append(&edit_btn);
    action_box.append(&delete_btn);
    vbox.append(&action_box);
    
    {
        let window_handle = window.clone();
        let populate_fn = populate_list.clone();
        new_btn.connect_clicked(move |_| {
            let populate_fn = populate_fn.clone();
            open_input_dialog(&window_handle, "New Clipboard Item", "", move |text| {
                if !text.is_empty() {
                    let _ = Command::new("copyq").arg("add").arg(&text).output();
                    populate_fn();
                }
            });
        });
    }
    
    {
        let window_handle = window.clone();
        let list_box_edit = list_box.clone();
        let populate_fn = populate_list.clone();
        edit_btn.connect_clicked(move |_| {
            if let Some(row) = list_box_edit.selected_row() {
                let index = row.index();
                if index >= 0 {
                    if let Some(child) = row.child() {
                        if let Ok(label) = child.downcast::<gtk::Label>() {
                            let current_text = label.text().to_string();
                            let populate_fn = populate_fn.clone();
                            open_input_dialog(&window_handle, "Edit Clipboard Item", &current_text, move |new_text| {
                                if !new_text.is_empty() {
                                    let _ = Command::new("copyq")
                                        .arg("write")
                                        .arg(index.to_string())
                                        .arg("text/plain")
                                        .arg(&new_text)
                                        .output();
                                    populate_fn();
                                }
                            });
                        }
                    }
                }
            }
        });
    }
    
    {
        let list_box_del = list_box.clone();
        let populate_del = populate_list.clone();
        delete_btn.connect_clicked(move |_| {
            if let Some(row) = list_box_del.selected_row() {
                let index = row.index();
                if index >= 0 {
                    let _ = Command::new("copyq")
                        .arg("remove")
                        .arg(index.to_string())
                        .output();
                    populate_del();
                }
            }
        });
    }
    
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

fn open_input_dialog<F>(parent: &gtk::ApplicationWindow, title: &str, initial_text: &str, on_save: F)
where
    F: Fn(String) + 'static,
{
    let dialog = gtk::Window::new();
    dialog.set_title(Some(title));
    dialog.set_default_size(320, 140);
    dialog.set_modal(true);
    dialog.set_transient_for(Some(parent));
    dialog.set_decorated(false);
    
    let d_box = gtk::Box::new(gtk::Orientation::Vertical, 8);
    d_box.set_margin_start(12);
    d_box.set_margin_end(12);
    d_box.set_margin_top(12);
    d_box.set_margin_bottom(12);
    
    let d_label = gtk::Label::new(Some(title));
    d_label.set_xalign(0.0);
    d_box.append(&d_label);
    
    let output_entry = gtk::Entry::new();
    output_entry.set_text(initial_text);
    d_box.append(&output_entry);
    
    let btn_box = gtk::Box::new(gtk::Orientation::Horizontal, 8);
    btn_box.set_halign(gtk::Align::End);
    
    let cancel_btn = gtk::Button::with_label("Cancel");
    let d_clone = dialog.clone();
    cancel_btn.connect_clicked(move |_| {
        d_clone.close();
    });
    
    let save_btn = gtk::Button::with_label("Save");
    let d_clone2 = dialog.clone();
    let entry_clone = output_entry.clone();
    save_btn.connect_clicked(move |_| {
        let text = entry_clone.text().to_string();
        on_save(text);
        d_clone2.close();
    });
    
    btn_box.append(&cancel_btn);
    btn_box.append(&save_btn);
    d_box.append(&btn_box);
    
    dialog.set_child(Some(&d_box));
    dialog.present();
}
