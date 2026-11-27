use super::{command::{build as cmd, Defaults}, Ctx};
use gtk4 as gtk;

pub fn build(ctx: &Ctx) -> gtk::Widget {
    cmd(ctx, Defaults {
        kind: "keyboard_layout",
        format: "{text}",
        command: Some(r##"localectl status 2>/dev/null | awk '/X11 Layout/{print $3}' | grep . || echo ''"##),
        ..Default::default()
    })
}
