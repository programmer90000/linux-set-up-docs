use super::{command::{build as cmd, Defaults}, Ctx};
use gtk4 as gtk;
use gtk::prelude::*;
use std::process::Command;
use std::rc::Rc;

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

fn build_popover(parent: &gtk::Widget) -> gtk::Popover {
    let popover = gtk::Popover::new();
    popover.set_parent(parent);
    popover.set_position(gtk::PositionType::Top);
    popover.set_autohide(true);
    popover.set_has_arrow(false);
    let list_box = gtk::ListBox::new();
    list_box.set_selection_mode(gtk::SelectionMode::Single);
    let scrolled = gtk::ScrolledWindow::new();
    scrolled.set_child(Some(&list_box));
    scrolled.set_min_content_width(420);
    scrolled.set_min_content_height(300);
    scrolled.set_max_content_height(520);
    scrolled.set_propagate_natural_height(true);
    popover.set_child(Some(&scrolled));
    
    let lb = list_box.clone();
    let populate = Rc::new(move || {
        while let Some(child) = lb.first_child() {
            lb.remove(&child);
        }
        let items = fetch_copyq_items();
        if items.is_empty() {
            lb.append(&gtk::Label::new(Some("No clipboard items found.")));
            return;
        }
        for (idx, text) in items {
            let label = gtk::Label::new(Some(&text));
            label.set_xalign(0.0);
            label.set_ellipsize(gtk::pango::EllipsizeMode::End);
            label.set_max_width_chars(50);
            label.set_margin_top(6);
            label.set_margin_bottom(6);
            label.set_margin_start(6);
            label.set_margin_end(6);
            let row = gtk::ListBoxRow::new();
            row.set_child(Some(&label));
            row.set_widget_name(&idx.to_string());
            lb.append(&row);
        }
    });
    popover.connect_show(move |_| populate());
    
    let p = popover.clone();
    list_box.connect_row_activated(move |_, row| {
        if let Ok(idx) = row.widget_name().parse::<usize>() {
            let _ = Command::new("copyq").arg("select").arg(idx.to_string()).spawn();
        }
        p.popdown();
    });
    
    popover
}

fn fetch_copyq_items() -> Vec<(usize, String)> {
    let count = match Command::new("copyq").arg("count").output() {
        Ok(res) if res.status.success() => String::from_utf8_lossy(&res.stdout)
            .trim().parse::<usize>().unwrap_or(0),
        Ok(res) => {
            let err = String::from_utf8_lossy(&res.stderr);
            return vec![(usize::MAX, format!("CopyQ error: {}", err.trim()))];
        }
        Err(e) => return vec![(usize::MAX, format!("Failed to run copyq: {}", e))],
    };
    
    let mut items = Vec::new();
    for i in 0..count {
        if let Ok(res) = Command::new("copyq").arg("read").arg(i.to_string()).output() {
            if res.status.success() {
                let text = String::from_utf8_lossy(&res.stdout);
                let single = text.lines().collect::<Vec<_>>().join(" ");
                if !single.trim().is_empty() {
                    items.push((i, single));
                }
            }
        }
    }
    items
}
