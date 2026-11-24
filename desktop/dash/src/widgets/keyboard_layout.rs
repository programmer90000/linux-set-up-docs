use super::{command::{build as cmd, Defaults}, Ctx};
use gtk4 as gtk;

pub fn build(ctx: &Ctx) -> gtk::Widget {
    cmd(ctx, Defaults { kind: "keyboard_layout", icon: "⌨", ..Default::default() })
}
