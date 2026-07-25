use iced::widget::{button, column, row, text, scrollable};
use iced::{Element, Length, Task, Theme};
use std::collections::HashMap;
use std::process::Command;
use std::time::{SystemTime, UNIX_EPOCH};

pub fn main() -> iced::Result {
    iced::application("LabWC Window Switcher", WindowSwitcher::update, WindowSwitcher::view)
        .run_with(|| (WindowSwitcher::new(), Task::none()))
}

#[derive(Debug, Clone)]
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
    timestamp: u64,
    pid: Option<u32>,
}

#[derive(Debug, Clone)]
struct AppGroup {
    app_id: String,
    windows: Vec<WindowInfo>,
}

#[derive(Debug, Clone)]
enum Message {
    Refresh,
    ChangeSortOrder(SortOrder),
    Error(String),
}

struct WindowSwitcher {
    app_groups: Vec<AppGroup>,
    sort_order: SortOrder,
    error_message: Option<String>,
    loading: bool,
}

impl WindowSwitcher {
    fn new() -> Self {
        let mut switcher = Self {
            app_groups: Vec::new(),
            sort_order: SortOrder::default(),
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
                self.sort_app_groups();
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
                    let pid = self.get_window_pid(&app_id, &title);
                    let timestamp = self.get_window_timestamp(&app_id, &title);
                    windows.push(WindowInfo { app_id, title, timestamp, pid });
                }
            }
        }
        
        windows
    }
    
    fn get_window_pid(&self, app_id: &str, title: &str) -> Option<u32> {
        let output = Command::new("wlrctl")
            .arg("window")
            .arg("get-pid")
            .arg(format!("app-id:{}", app_id))
            .arg(format!("title:{}", title))
            .output()
            .ok()?;
        
        if output.status.success() {
            let pid_str = String::from_utf8_lossy(&output.stdout);
            let pid_str = pid_str.trim();
            pid_str.parse::<u32>().ok()
        } else {
            None
        }
    }
    
    fn get_window_timestamp(&self, app_id: &str, title: &str) -> u64 {
        if let Some(pid) = self.get_window_pid(app_id, title) {
            if let Some(ts) = self.get_timestamp_from_proc(pid) {
                return ts;
            }
            
            if let Some(ts) = self.get_timestamp_from_proc_stat(pid) {
                return ts;
            }
        }
        
        SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap_or_default()
            .as_secs()
    }
    
    fn get_timestamp_from_proc(&self, pid: u32) -> Option<u64> {
        let stat_path = format!("/proc/{}/stat", pid);
        let content = std::fs::read_to_string(&stat_path).ok()?;
        let fields: Vec<&str> = content.split_whitespace().collect();
        
        if fields.len() >= 22 {
            if let Ok(start_time_ticks) = fields[21].parse::<u64>() {
                let uptime_content = std::fs::read_to_string("/proc/uptime").ok()?;
                let uptime_seconds = uptime_content
                    .split_whitespace()
                    .next()?
                    .parse::<f64>()
                    .ok()?;
                
                let boot_time = SystemTime::now()
                    .duration_since(UNIX_EPOCH)
                    .unwrap_or_default()
                    .as_secs() - uptime_seconds as u64;
                
                let start_time_seconds = start_time_ticks / 100;
                return Some(boot_time + start_time_seconds);
            }
        }
        None
    }
    
    fn get_timestamp_from_proc_stat(&self, pid: u32) -> Option<u64> {
        let proc_path = format!("/proc/{}", pid);
        std::fs::metadata(&proc_path)
            .ok()
            .and_then(|meta| meta.modified().ok())
            .and_then(|time| time.duration_since(UNIX_EPOCH).ok())
            .map(|d| d.as_secs())
    }
    
    fn group_windows(&self, windows: Vec<WindowInfo>) -> Vec<AppGroup> {
        let mut groups: HashMap<String, Vec<WindowInfo>> = HashMap::new();
        
        for window in windows {
            groups.entry(window.app_id.clone())
                .or_insert_with(Vec::new)
                .push(window);
        }
        
        groups.into_iter()
            .map(|(app_id, mut windows)| {
                windows.sort_by(|a, b| b.timestamp.cmp(&a.timestamp));
                AppGroup { app_id, windows }
            })
            .collect()
    }
    
    fn sort_app_groups(&mut self) {
        match self.sort_order {
            SortOrder::Alphabetical => {
                self.app_groups.sort_by(|a, b| a.app_id.cmp(&b.app_id));
            }
            SortOrder::NewestFirst => {
                self.app_groups.sort_by(|a, b| {
                    let a_max = a.windows.iter().map(|w| w.timestamp).max().unwrap_or(0);
                    let b_max = b.windows.iter().map(|w| w.timestamp).max().unwrap_or(0);
                    b_max.cmp(&a_max)
                });
            }
            SortOrder::OldestFirst => {
                self.app_groups.sort_by(|a, b| {
                    let a_min = a.windows.iter().map(|w| w.timestamp).min().unwrap_or(0);
                    let b_min = b.windows.iter().map(|w| w.timestamp).min().unwrap_or(0);
                    a_min.cmp(&b_min)
                });
            }
        }
    }
    
    fn format_timestamp(&self, timestamp: u64) -> String {
        let now = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap_or_default()
            .as_secs();
        
        let diff = now.saturating_sub(timestamp);
        
        if diff < 60 {
            format!("{}s ago", diff)
        } else if diff < 3600 {
            format!("{}m ago", diff / 60)
        } else if diff < 86400 {
            format!("{}h ago", diff / 3600)
        } else {
            format!("{}d ago", diff / 86400)
        }
    }
    
    fn update(&mut self, message: Message) -> Task<Message> {
        match message {
            Message::Refresh => {
                self.load_windows();
                Task::none()
            }
            Message::ChangeSortOrder(order) => {
                self.sort_order = order;
                self.sort_app_groups();
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
        ]
        .spacing(10)
        .padding(20);
        
        let sort_row = row![
            button("Refresh").on_press(Message::Refresh),
            button("Alphabetical").on_press(Message::ChangeSortOrder(SortOrder::Alphabetical)),
            button("Newest First").on_press(Message::ChangeSortOrder(SortOrder::NewestFirst)),
            button("Oldest First").on_press(Message::ChangeSortOrder(SortOrder::OldestFirst)),
        ]
        .spacing(10)
        .padding(5);
        
        content = content.push(sort_row);
        
        let sort_text = match self.sort_order {
            SortOrder::Alphabetical => "Alphabetical",
            SortOrder::NewestFirst => "Newest First",
            SortOrder::OldestFirst => "Oldest First",
        };
        content = content.push(text(format!("Current sort: {}", sort_text)).size(16));
        
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
                    let pid_text = match window.pid {
                        Some(pid) => format!(" PID:{}", pid),
                        None => " PID:unknown".to_string(),
                    };
                    let time_text = self.format_timestamp(window.timestamp);
                    list = list.push(
                        text(format!("  └─ {}{} [{}]", window.title, pid_text, time_text))
                            .size(14)
                    );
                }
            }
            content = content.push(scrollable(list));
        }
        
        content.into()
    }
}
