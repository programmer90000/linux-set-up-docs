use super::{menu_button, tag, Ctx};
use gtk4 as gtk;
use gtk::prelude::*;

pub fn build(ctx: &Ctx, content: &gtk::Box) -> gtk::Widget {
    let (mb, _pop) = menu_button(ctx, content);
    mb.set_label(ctx.cfg.icon.as_deref().unwrap_or("⋯"));
    tag(&mb, "show_more");
    mb.upcast()
}
