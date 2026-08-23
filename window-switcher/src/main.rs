mod config;

use iced::widget::{button, Column, scrollable, text, Row};
use iced::{Element, Length, Task, Size};
use iced::window;
use std::collections::HashMap;
use std::process::Command;
use std::time::{SystemTime, UNIX_EPOCH};

use config::Config;

use iced::{Color, Theme};
use std::sync::{Arc, Mutex};

use wayland_client::protocol::{wl_registry, wl_seat};
use wayland_client::{backend::ObjectData, Connection, Dispatch, Proxy, QueueHandle};
use wayland_protocols_wlr::foreign_toplevel::v1::client::{
    zwlr_foreign_toplevel_handle_v1::{self, ZwlrForeignToplevelHandleV1},
    zwlr_foreign_toplevel_manager_v1::{self, ZwlrForeignToplevelManagerV1},
};

#[derive(Clone, Debug)]
pub struct RawWindowInfo {
    pub app_id: String,
    pub title: String,
    pub handle: ZwlrForeignToplevelHandleV1,
}

#[derive(Default)]
pub struct WaylandState {
    pub seat: Option<wl_seat::WlSeat>,
    pub manager: Option<ZwlrForeignToplevelManagerV1>,
    pub windows: Vec<RawWindowInfo>,
}

#[derive(Default, Debug, Clone)]
pub struct PendingWindow {
    pub app_id: String,
    pub title: String,
}

impl Dispatch<wl_registry::WlRegistry, ()> for WaylandState {
    fn event(
        state: &mut Self,
        registry: &wl_registry::WlRegistry,
        event: wl_registry::Event,
        _: &(),
        _: &Connection,
        qh: &QueueHandle<Self>,
    ) {
        if let wl_registry::Event::Global {
            name,
            interface,
            version,
        } = event
        {
            if interface == "wl_seat" {
                state.seat = Some(registry.bind::<wl_seat::WlSeat, _, _>(name, version.min(1), qh, ()));
            } else if interface == "zwlr_foreign_toplevel_manager_v1" {
                state.manager = Some(registry.bind::<ZwlrForeignToplevelManagerV1, _, _>(
                    name,
                    version.min(1),
                    qh,
                    (),
                ));
            }
        }
    }
}

impl Dispatch<wl_seat::WlSeat, ()> for WaylandState {
    fn event(
        _: &mut Self,
        _: &wl_seat::WlSeat,
        _: wl_seat::Event,
        _: &(),
        _: &Connection,
        _: &QueueHandle<Self>,
    ) {
    }
}

impl Dispatch<ZwlrForeignToplevelManagerV1, ()> for WaylandState {
    fn event(
        _: &mut Self,
        _: &ZwlrForeignToplevelManagerV1,
        _: zwlr_foreign_toplevel_manager_v1::Event,
        _: &(),
        _: &Connection,
        _: &QueueHandle<Self>,
    ) {
    }

    fn event_created_child(
        _opcode: u16,
        qh: &QueueHandle<Self>,
    ) -> Arc<dyn ObjectData> {
        qh.make_data::<ZwlrForeignToplevelHandleV1, Arc<Mutex<PendingWindow>>>(
            Arc::new(Mutex::new(PendingWindow::default())),
        )
    }
}

impl Dispatch<ZwlrForeignToplevelHandleV1, Arc<Mutex<PendingWindow>>> for WaylandState {
    fn event(
        state: &mut Self,
        handle: &ZwlrForeignToplevelHandleV1,
        event: zwlr_foreign_toplevel_handle_v1::Event,
        data: &Arc<Mutex<PendingWindow>>,
        _: &Connection,
        _: &QueueHandle<Self>,
    ) {
        match event {
            zwlr_foreign_toplevel_handle_v1::Event::AppId { app_id } => {
                if let Ok(mut pending) = data.lock() {
                    pending.app_id = app_id;
                }
            }
            zwlr_foreign_toplevel_handle_v1::Event::Title { title } => {
                if let Ok(mut pending) = data.lock() {
                    pending.title = title;
                }
            }
            zwlr_foreign_toplevel_handle_v1::Event::Closed => {
                state.windows.retain(|w| w.handle.id() != handle.id());
            }
            zwlr_foreign_toplevel_handle_v1::Event::Done => {
                if let Ok(pending) = data.lock() {
                    state.windows.push(RawWindowInfo {
                        app_id: pending.app_id.clone(),
                        title: pending.title.clone(),
                        handle: handle.clone(),
                    });
                }
            }
            _ => {}
        }
    }
}

pub fn theme(bg_hex: &str, bg_opacity: f32) -> Theme {
    let mut color = Color::parse(bg_hex).unwrap_or_else(|| {
        Color::from_rgb(1.00, 1.00, 1.00)
    });
    
    color.a = bg_opacity.clamp(0.0, 1.0);
    
    let palette = iced::theme::Palette {
        background: color,
        ..Theme::default().palette()
    };
    
    let theme = iced::theme::Custom::new("theme".to_string(), palette);
    Theme::Custom(Arc::new(theme))
}

pub fn main() -> iced::Result {
    let config = Config::load();
    let width = config.window.width;
    let height = config.window.height;
    let decorations = config.window.decorations;
    let bg_color = config.theme.background_color.clone();
    let bg_opacity = config.theme.background_opacity;
    let text_color = config.text.color.clone();
    let text_size = config.text.size;
    
    let bg_color_for_theme = bg_color.clone();
    let bg_color_for_state = bg_color.clone();
    let text_color_for_state = text_color.clone();
    
    iced::application("LabWC Window Switcher", WindowSwitcher::update, WindowSwitcher::view).subscription(WindowSwitcher::subscription).window(iced::window::Settings { size: iced::Size::new(width, height), decorations: decorations, position: iced::window::Position::Centered, transparent: true, ..Default::default()}).theme(move |_state| theme(&bg_color_for_theme, bg_opacity)).run_with(move || {(WindowSwitcher::new(bg_color_for_state, bg_opacity, text_color_for_state, text_size), Task::none())})
}

#[derive(Debug, Clone, PartialEq, Eq)]
enum SortOrder {
    Alphabetical,
    NewestFirst,
    OldestFirst,
}

impl Default for SortOrder {
    fn default() -> Self {
        Self::Alphabetical
    }
}

#[derive(Debug, Clone)]
struct WindowInfo {
    app_id: String,
    title: String,
    handle: ZwlrForeignToplevelHandleV1,
}

#[derive(Debug, Clone)]
struct AppGroup {
    app_id: String,
    windows: Vec<WindowInfo>,
}

#[derive(Debug, Clone)]
enum Message {
    Refresh,
    SelectAppGroup(usize),
    SelectWindowInGroup(usize, usize),
    BackToMainView,
    ChangeSortOrder(SortOrder),
    Event(iced::Event),
}

struct WindowSwitcher {
    app_groups: Vec<AppGroup>,
    sort_order: SortOrder,
    error_message: Option<String>,
    loading: bool,
    active_group_idx: Option<usize>,
    background_color: String,
    background_opacity: f32,
    text_color: String,
    text_size: u16,
    seat: Option<wl_seat::WlSeat>,
    connection: Option<Connection>,
}

impl WindowSwitcher {
    fn new(background_color: String, background_opacity: f32, text_color: String, text_size: u16) -> Self {
        let mut switcher = Self {
            app_groups: Vec::new(),
            sort_order: SortOrder::default(),
            error_message: None,
            loading: true,
            active_group_idx: None,
            background_color,
            background_opacity,
            text_color,
            text_size,
            seat: None,
            connection: None,
        };
        switcher.load_windows();
        switcher
    }

    fn subscription(&self) -> iced::Subscription<Message> {
        iced::event::listen().map(Message::Event)
    }
    
    fn load_windows(&mut self) {
        self.loading = true;
        self.error_message = None;
        self.active_group_idx = None;
        
        let connection = match Connection::connect_to_env() {
            Ok(conn) => conn,
            Err(e) => {
                self.error_message = Some(format!("Failed to connect to Wayland: {}", e));
                self.loading = false;
                return;
            }
        };
        
        let mut event_queue = connection.new_event_queue();
        let qh = event_queue.handle();
        let display = connection.display();
        
        let mut state = WaylandState::default();
        
        display.get_registry(&qh, ());
        
        if let Err(e) = event_queue.roundtrip(&mut state) {
            self.error_message = Some(format!("Wayland roundtrip failed: {}", e));
            self.loading = false;
            return;
        }
        
        if let Err(e) = event_queue.roundtrip(&mut state) {
            self.error_message = Some(format!("Wayland window list roundtrip failed: {}", e));
            self.loading = false;
            return;
        }
        
        self.seat = state.seat;
        
        let windows: Vec<WindowInfo> = state
            .windows
            .into_iter()
            .map(|w| WindowInfo {app_id: w.app_id, title: w.title, handle: w.handle})
            .collect();
            
        self.app_groups = self.group_windows(windows);
        self.sort_app_groups();
        self.connection = Some(connection);
        self.loading = false;
    }
    
    fn group_windows(&self, windows: Vec<WindowInfo>) -> Vec<AppGroup> {
        let mut groups: HashMap<String, Vec<WindowInfo>> = HashMap::new();
        
        for window in windows {
            groups.entry(window.app_id.clone())
                .or_insert_with(Vec::new)
                .push(window);
        }
        
        groups.into_iter()
            .map(|(app_id, windows)| AppGroup { app_id, windows })
            .collect()
    }
    
    fn sort_app_groups(&mut self) {
        match self.sort_order {
            SortOrder::Alphabetical | SortOrder::NewestFirst | SortOrder::OldestFirst => {
                self.app_groups.sort_by(|a, b| a.app_id.cmp(&b.app_id));
            }
        }
    }
    
    fn focus_window(&self, window: &WindowInfo) {
        if let Some(seat) = &self.seat {
            window.handle.unset_minimized();
            window.handle.activate(seat);
            if let Some(conn) = &self.connection {
                let _ = conn.flush();
            }
        } else {
            eprintln!("Cannot focus window: Wayland seat unavailable.");
        }
    }
    
    fn close_window_task() -> Task<Message> {
        iced::window::get_latest().and_then(|id| iced::window::close(id))
    }
    
    fn update(&mut self, message: Message) -> Task<Message> {
        match message {
            Message::Event(iced::Event::Window(iced::window::Event::Unfocused)) => {
                Self::close_window_task()
            }
            Message::Event(_) => Task::none(),
            Message::Refresh => {
                self.load_windows();
                Task::none()
            }
            Message::SelectAppGroup(app_idx) => {
                if let Some(app_group) = self.app_groups.get(app_idx) {
                    if app_group.windows.len() == 1 {
                        self.focus_window(&app_group.windows[0]);
                        return Self::close_window_task();
                    } else {
                        self.active_group_idx = Some(app_idx);
                    }
                }
                Task::none()
            }
            Message::SelectWindowInGroup(app_idx, window_idx) => {
                if let Some(app_group) = self.app_groups.get(app_idx) {
                    if let Some(window) = app_group.windows.get(window_idx) {
                        self.focus_window(window);
                        return Self::close_window_task();
                    }
                }
                Task::none()
            }
            Message::BackToMainView => {
                self.active_group_idx = None;
                Task::none()
            }
            Message::ChangeSortOrder(order) => {
                self.sort_order = order;
                self.sort_app_groups();
                Task::none()
            }
        }
    }
    
    fn view(&self) -> Element<Message> {
        let mut content = Column::new().spacing(10).padding(20);
        let text_color = Color::parse(&self.text_color).unwrap_or(Color::from_rgb(0.0, 0.0, 0.0));
        
        let mut sort_row = Row::new().spacing(10).padding(5);
        
        if self.active_group_idx.is_some() {
            sort_row = sort_row.push(
                button(text("← Back").color(text_color)).on_press(Message::BackToMainView),
            );
        }
        
        sort_row = sort_row
            .push(button(text("Refresh").color(text_color)).on_press(Message::Refresh))
            .push(button(text("Alphabetical").color(text_color)).on_press(Message::ChangeSortOrder(SortOrder::Alphabetical)))
            .push(button(text("Newest First").color(text_color)).on_press(Message::ChangeSortOrder(SortOrder::NewestFirst)))
            .push(button(text("Oldest First").color(text_color)).on_press(Message::ChangeSortOrder(SortOrder::OldestFirst)));
        
        content = content.push(sort_row);
        
        let sort_text = match self.sort_order {
            SortOrder::Alphabetical => "Alphabetical",
            SortOrder::NewestFirst => "Newest First",
            SortOrder::OldestFirst => "Oldest First",
        };
        content = content.push(
            text(format!("Sort: {} | Groups: {} | Windows: {} | Opacity: {:.1}", 
                sort_text, 
                self.app_groups.len(),
                self.app_groups.iter().map(|g| g.windows.len()).sum::<usize>(),
                self.background_opacity
            )).color(text_color).size(self.text_size)
        );
        
        if let Some(error) = &self.error_message {
            content = content.push(text(format!("Error: {}", error)).color(text_color).size(self.text_size));
        }
        
        if self.loading {
            content = content.push(text("Loading windows...").color(text_color).size(self.text_size));
        } else if self.app_groups.is_empty() {
            content = content.push(text("No windows found").color(text_color).size(self.text_size));
        } else {
            let mut grid = Column::new().spacing(10);
            let cols: usize = 4;
            
            match self.active_group_idx {
                None => {
                    let mut rows = Vec::new();
                    let mut current_row = Vec::new();
                    
                    for (app_idx, app_group) in self.app_groups.iter().enumerate() {
                        let display_text = if app_group.windows.len() == 1 {
                            format!("{}: {}", app_group.app_id, app_group.windows[0].title)
                        } else {
                            format!("{} ({} windows)", app_group.app_id, app_group.windows.len())
                        };
                        
                        let button_widget = button(text(display_text).color(text_color).size(self.text_size))
                            .width(Length::Fill)
                            .on_press(Message::SelectAppGroup(app_idx));
                        
                        current_row.push(button_widget);
                        
                        if current_row.len() >= cols {
                            rows.push(current_row);
                            current_row = Vec::new();
                        }
                    }
                    
                    if !current_row.is_empty() {
                        rows.push(current_row);
                    }
                    
                    for row_buttons in rows {
                        let mut row_widget = Row::new().spacing(10);
                        for btn in row_buttons {
                            row_widget = row_widget.push(btn);
                        }
                        grid = grid.push(row_widget);
                    }
                }
                Some(app_idx) => {
                    if let Some(app_group) = self.app_groups.get(app_idx) {
                        let mut current_row = Vec::new();
                        let mut rows = Vec::new();
                        
                        for (win_idx, window) in app_group.windows.iter().enumerate() {
                            let btn = button(text(&window.title).color(text_color).size(self.text_size)).width(Length::Fill).on_press(Message::SelectWindowInGroup(app_idx, win_idx));
                            
                            current_row.push(btn);
                            
                            if current_row.len() >= cols {
                                rows.push(current_row);
                                current_row = Vec::new();
                            }
                        }
                        if !current_row.is_empty() {
                            rows.push(current_row);
                        }
                        
                        for row_buttons in rows {
                            let mut row_widget = Row::new().spacing(10);
                            for btn in row_buttons {
                                row_widget = row_widget.push(btn);
                            }
                            grid = grid.push(row_widget);
                        }
                    }
                }
            }
            
            content = content.push(scrollable(grid));
        }
        
        content.into()
    }
}

