mod cli;
mod encoding;
mod model;
mod replace;
mod rg;
mod ui;
mod util;

use std::fs::File;
use std::{env, process};

use anyhow::Result;
use flexi_logger::{opt_format, FileSpec, Logger};
use rg::exec::run_ripgrep;
use ui::tui::Tui;

use crate::rg::read::read_messages;

fn init_logging() -> Result<::std::path::PathBuf> {
    let log_dir = env::temp_dir().join(format!(".{}", env!("CARGO_PKG_NAME")));
    let log_spec = if cfg!(debug_assertions) {
        FileSpec::default()
            .directory(env::current_dir().unwrap())
            .basename("rgr")
            .use_timestamp(false)
    } else {
        FileSpec::default().directory(&log_dir)
    };
    Logger::try_with_env()
        .expect("Please pass a valid RUST_LOG string, see: https://docs.rs/flexi_logger/latest/flexi_logger/struct.LogSpecification.html")
        .log_to_file(log_spec)
        .format(opt_format)
        .start()?;

    log::trace!("--- LOGGER INITIALISED ---");

    Ok(log_dir)
}

fn main() {
    let log_dir = match init_logging() {
        Ok(dir) => dir,
        Err(e) => {
            eprintln!("Failed to initialise logger: {}", e);
            process::exit(1);
        }
    };

    macro_rules! exit_with_error {
        ($( $eprintln_arg:expr ),*) => {
            log::error!($( $eprintln_arg ),*);
            eprintln!($( $eprintln_arg ),*);
            if log::log_enabled!(log::Level::Error) {
                eprintln!("Logs available at: {}", log_dir.display());
            }
            process::exit(1);
        };
    }

    let (args, rg_json) = {
        match env::var_os(cli::ENV_JSON_FILE) {
            // check if JSON is being passed as an environment file
            Some(path) => {
                log::debug!(
                    "{} set to {}; Reading messages from file",
                    cli::ENV_JSON_FILE,
                    path.to_string_lossy()
                );
                match File::open(&path) {
                    Ok(json_file) => {
                        let args = match cli::RgArgs::parse_pattern() {
                            Ok(args) => args,
                            Err(e) => {
                                exit_with_error!("Failed to parse arguments: {}", e);
                            }
                        };

                        (args, read_messages(json_file))
                    }
                    Err(e) => {
                        exit_with_error!("Failed to open {}: {}", path.to_string_lossy(), e);
                    }
                }
            }
            // normal execution, parse rg arguments and call it ourselves
            None => {
                let args = match cli::RgArgs::parse_rg_args() {
                    Ok(args) => args,
                    Err(e) => {
                        exit_with_error!("Failed to parse arguments: {}", e);
                    }
                };

                let rg_args = args.rg_args();
                (args, run_ripgrep(rg_args))
            }
        }
    };

    match rg_json {
        Ok(rg_messages) => {
            let result = Tui::new()
                .and_then(|tui| tui.start(args.rg_cmdline(), rg_messages, &args.patterns));

            // Restore terminal.
            if let Err(err) = Tui::restore_terminal() {
                log::warn!("Failed to restore terminal state: {}", err);
                eprintln!(
                    "Failed to restore terminal state, consider running the `reset` command. Error: {}",
                    err
                );
            }

            // Handle application result.
            match result {
                Ok(Some(mut replacement_criteria)) => {
                    // use an encoding if one was passed to `rg`
                    if let Some(encoding) = args.encoding {
                        replacement_criteria.set_encoding(encoding);
                    }

                    // if we're running in fixed strings mode, then we shouldn't treat the patterns as regexes
                    if args.fixed_strings {
                        replacement_criteria.capture_pattern = None;
                    }

                    match replace::perform_replacements(replacement_criteria) {
                        Ok(_) => {}
                        Err(err) => {
                            exit_with_error!("An error occurred during replacement: {}", err);
                        }
                    }
                }
                Ok(None) => eprintln!("Cancelled"),
                Err(err) => {
                    exit_with_error!("An app error occurred: {}", err);
                }
            }
        }
        Err(e) => {
            exit_with_error!("{}", e);
        }
    }
}
