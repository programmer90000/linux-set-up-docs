use serde::{Deserialize, Serialize};
use std::fs;
use std::path::PathBuf;

#[derive(Debug, Deserialize, Serialize)]
pub struct Config {
    pub window: WindowConfig,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct WindowConfig {
    pub width: f32,
    pub height: f32,
    pub resizable: bool,
    pub decorations: bool,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            window: WindowConfig {
                width: 2000.0,
                height: 200.0,
                resizable: true,
                decorations: true,
            },
        }
    }
}

impl Config {
    pub fn load() -> Self {
        let config_path = PathBuf::from("config.toml");
        
        if config_path.exists() {
            println!("Loading config from: {:?}", config_path);
            match fs::read_to_string(&config_path) {
                Ok(content) => {
                    match toml::from_str::<Config>(&content) {
                        Ok(config) => {
                            println!("Config loaded successfully");
                            println!("Window size: {}x{}", config.window.width, config.window.height);
                            println!("Resizable: {}", config.window.resizable);
                            println!("Decorations: {}", config.window.decorations);
                            return config;
                        }
                        Err(e) => {
                            eprintln!("Error parsing config: {}", e);
                            eprintln!("Using default config instead");
                        }
                    }
                }
                Err(e) => {
                    eprintln!("Error reading config: {}", e);
                }
            }
        } else {
            println!("ℹNo config.toml found, using defaults");
        }

        Config::default()
    }
}
