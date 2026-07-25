use iced::widget::{button, column, text, scrollable};
use iced::{Element, Length, Task, Theme};
use std::collections::HashMap;
use std::process::Command;

pub fn main() -> iced::Result {
    iced::application("LabWC Window Switcher", WindowSwitcher::update, WindowSwitcher::view)
        .run_with(|| (WindowSwitcher::new(), Task::none()))
}

#[derive(Debug, Clone)]
struct WindowInfo {
    app_id: String,
    title: String,
}

#[derive(Debug, Clone)]
struct AppGroup {
    app_id: String,
    windows: Vec<WindowInfo>,
}

#[derive(Debug, Clone)]
enum Message {
    Refresh,
    Error(String),
}

struct WindowSwitcher {
    app_groups: Vec<AppGroup>,
    error_message: Option<String>,
    loading: bool,
}

impl WindowSwitcher {
    fn new() -> Self {
        let mut switcher = Self {
            app_groups: Vec::new(),
            error_message: None,
            loading: true,
        };
        switcher.load_windows();
        switcher
    }
    
    fn load_windows(&mut self) {
        self.loading = true;
        self.error_message = None;
        
        let output = Command::new("wlrctl")
            .arg("window")
            .arg("list")
            .output();
        
        match output {
            Ok(output) if output.status.success() => {
                let stdout = String::from_utf8_lossy(&output.stdout);
                let windows = self.parse_window_list(&stdout);
                self.app_groups = self.group_windows(windows);
                self.loading = false;
            }
            Ok(output) => {
                self.error_message = Some(format!("wlrctl error: {}", String::from_utf8_lossy(&output.stderr)));
                self.loading = false;
            }
            Err(e) => {
                self.error_message = Some(format!("Failed to run wlrctl: {}", e));
                self.loading = false;
            }
        }
    }
    
    fn parse_window_list(&self, output: &str) -> Vec<WindowInfo> {
        let mut windows = Vec::new();
        
        for line in output.lines() {
            if line.is_empty() {
                continue;
            }
            
            let parts: Vec<&str> = line.splitn(2, ':').collect();
            if parts.len() == 2 {
                let app_id = parts[0].trim().to_string();
                let title = parts[1].trim().to_string();
                
                if !title.is_empty() && title != "title" {
                    windows.push(WindowInfo { app_id, title });
                }
            }
        }
        
        windows
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
    
    fn update(&mut self, message: Message) -> Task<Message> {
        match message {
            Message::Refresh => {
                self.load_windows();
                Task::none()
            }
            Message::Error(msg) => {
                self.error_message = Some(msg);
                Task::none()
            }
        }
    }

    fn view(&self) -> Element<Message> {
        let mut content = column![
            text("=== LabWC Window Switcher ===").size(24),
            button("Refresh").on_press(Message::Refresh),
        ]
        .spacing(10)
        .padding(20);
        
        if let Some(error) = &self.error_message {
            content = content.push(text(format!("Error: {}", error)));
        }
        
        if self.loading {
            content = content.push(text("Loading windows...").size(18));
        } else if self.app_groups.is_empty() {
            content = content.push(text("No windows found").size(18));
        } else {
            let mut list = column![].spacing(10);
            for group in &self.app_groups {
                let header = if group.windows.len() == 1 {
                    format!("{}", group.app_id)
                } else {
                    format!("{} ({} windows)", group.app_id, group.windows.len())
                };
                list = list.push(text(header).size(16));
                
                for window in &group.windows {
                    list = list.push(text(format!("{}", window.title)).size(14));
                }
            }
            content = content.push(scrollable(list));
        }
        
        content.into()
    }
}
