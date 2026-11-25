use super::{command::{build as cmd, Defaults}, Ctx};
use gtk4 as gtk;
use gtk::{glib, prelude::*};
use std::process::Command;

pub fn build(ctx: &Ctx) -> gtk::Widget {
    let widget = cmd(ctx, Defaults {
        kind: "copyq", icon: "📋",
        watch: Some("wl-paste --watch echo changed"),
        command: Some("copyq count"),
        ..Default::default()
    });
    
    let popover = build_popover(&widget);
    
    let gesture = gtk::GestureClick::new();
    gesture.set_propagation_phase(gtk::PropagationPhase::Capture);
    let p = popover.clone();
    gesture.connect_released(move |_, _, _, _| p.popup());
    widget.add_controller(gesture);
    
    widget.connect_destroy(move |_| popover.unparent());
    
    widget
}

fn copyq(args: &[&str]) {
    let _ = Command::new("copyq").args(args).status();
}

fn read_item(idx: usize) -> String {
    Command::new("copyq").arg("read").arg(idx.to_string()).output()
        .map(|o| String::from_utf8_lossy(&o.stdout).into_owned())
        .unwrap_or_default()
}

fn replace_item(idx: usize, text: &str) {
    copyq(&["insert", &idx.to_string(), text]);
    copyq(&["remove", &(idx + 1).to_string()]);
}

fn fetch_copyq_items() -> Result<Vec<(usize, String)>, String> {
    let out = Command::new("copyq").arg("count").output()
        .map_err(|e| format!("Failed to run copyq: {e}"))?;
    if !out.status.success() {
        return Err(format!("CopyQ error: {}", String::from_utf8_lossy(&out.stderr).trim()));
    }
    let count = String::from_utf8_lossy(&out.stdout).trim().parse::<usize>().unwrap_or(0);
    
    let mut items = Vec::new();
    for i in 0..count {
        let text = read_item(i);
        let single = text.lines().collect::<Vec<_>>().join(" ");
        if !single.trim().is_empty() {
            items.push((i, single));
        }
    }
    Ok(items)
}

fn build_popover(parent: &gtk::Widget) -> gtk::Popover {
    let popover = gtk::Popover::new();
    popover.set_parent(parent);
    popover.set_position(gtk::PositionType::Top);
    popover.set_autohide(true);
    popover.set_has_arrow(false);
    
    let vbox = gtk::Box::new(gtk::Orientation::Vertical, 6);
    vbox.set_margin_top(6);
    vbox.set_margin_bottom(6);
    vbox.set_margin_start(6);
    vbox.set_margin_end(6);
    
    let list_box = gtk::ListBox::new();
    list_box.set_selection_mode(gtk::SelectionMode::Single);
    
    let new_entry = gtk::Entry::new();
    new_entry.set_placeholder_text(Some("New item…"));
    new_entry.set_hexpand(true);
    let add_btn = gtk::Button::with_label("＋");
    add_btn.set_tooltip_text(Some("Add new item"));
    
    let top = gtk::Box::new(gtk::Orientation::Horizontal, 6);
    top.append(&new_entry);
    top.append(&add_btn);
    vbox.append(&top);
    
    let do_add = {
        let (entry, lb) = (new_entry.clone(), list_box.clone());
        move || {
            let text = entry.text().to_string();
            if text.trim().is_empty() { return; }
            copyq(&["add", &text]);
            entry.set_text("");
            populate(&lb);
        }
    };
    let add = do_add.clone();
    add_btn.connect_clicked(move |_| add());
    new_entry.connect_activate(move |_| do_add());
    
    let scrolled = gtk::ScrolledWindow::new();
    scrolled.set_child(Some(&list_box));
    scrolled.set_min_content_width(420);
    scrolled.set_min_content_height(300);
    scrolled.set_max_content_height(520);
    scrolled.set_propagate_natural_height(true);
    vbox.append(&scrolled);
    popover.set_child(Some(&vbox));
    
    let lb = list_box.clone();
    popover.connect_show(move |_| populate(&lb));
    
    let p = popover.clone();
    list_box.connect_row_activated(move |_, row| {
        if let Ok(idx) = row.widget_name().parse::<usize>() {
            copyq(&["select", &idx.to_string()]);
            p.popdown();
        }
    });
    
    popover
}

fn populate(lb: &gtk::ListBox) {
    while let Some(child) = lb.first_child() {
        lb.remove(&child);
    }
    match fetch_copyq_items() {
        Err(msg) => lb.append(&gtk::Label::new(Some(&msg))),
        Ok(items) if items.is_empty() => {
            lb.append(&gtk::Label::new(Some("No clipboard items found.")));
        }
        Ok(items) => {
            for (idx, text) in items {
                lb.append(&build_row(lb, idx, &text));
            }
        }
    }
}

fn build_row(lb: &gtk::ListBox, idx: usize, text: &str) -> gtk::ListBoxRow {
    let row = gtk::ListBoxRow::new();
    row.set_widget_name(&idx.to_string());
    
    let label = gtk::Label::new(Some(text));
    label.set_xalign(0.0);
    label.set_ellipsize(gtk::pango::EllipsizeMode::End);
    label.set_max_width_chars(45);
    
    let entry = gtk::Entry::new();
    entry.set_hexpand(true);
    
    let stack = gtk::Stack::new();
    stack.set_hexpand(true);
    stack.add_named(&label, Some("view"));
    stack.add_named(&entry, Some("edit"));
    stack.set_visible_child_name("view");
    
    let edit_btn = gtk::Button::with_label("✎");
    edit_btn.set_tooltip_text(Some("Edit"));
    edit_btn.add_css_class("flat");
    let del_btn = gtk::Button::with_label("🗑");
    del_btn.set_tooltip_text(Some("Delete"));
    del_btn.add_css_class("flat");
    
    let hbox = gtk::Box::new(gtk::Orientation::Horizontal, 4);
    hbox.set_margin_top(4);
    hbox.set_margin_bottom(4);
    hbox.set_margin_start(6);
    hbox.set_margin_end(6);
    hbox.append(&stack);
    hbox.append(&edit_btn);
    hbox.append(&del_btn);
    row.set_child(Some(&hbox));
    
    {
        let (stack, entry) = (stack.clone(), entry.clone());
        edit_btn.connect_clicked(move |_| {
            entry.set_text(read_item(idx).trim_end_matches('\n'));
            stack.set_visible_child_name("edit");
            entry.grab_focus();
        });
    }
    
    {
        let lb = lb.clone();
        entry.connect_activate(move |e| {
            let new_text = e.text().to_string();
            if !new_text.trim().is_empty() {
                replace_item(idx, &new_text);
            }
            populate(&lb);
        });
    }
    
    {
        let stack = stack.clone();
        let keys = gtk::EventControllerKey::new();
        keys.connect_key_pressed(move |_, key, _, _| {
            if key == gtk::gdk::Key::Escape {
                stack.set_visible_child_name("view");
                glib::Propagation::Stop
            } else {
                glib::Propagation::Proceed
            }
        });
        entry.add_controller(keys);
    }
    
    {
        let lb = lb.clone();
        del_btn.connect_clicked(move |_| {
            copyq(&["remove", &idx.to_string()]);
            populate(&lb);
        });
    }
    
    row
}
