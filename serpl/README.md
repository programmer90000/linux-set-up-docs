# Serpl

`serpl` is a terminal user interface (TUI) application that allows users to search and replace keywords in an entire folder, similar to the functionality available in VS Code.

## Table of Contents

1. [Features](#features)
2. [Installation](#installation-and-update)
   - [Prerequisites](#prerequisites)
   - [Steps](#steps)
3. [Usage](#usage)
   - [Basic Commands](#basic-commands)
   - [Key Bindings](#key-bindings)
   - [Configuration](#configuration)
4. [Panes](#panes)
   - [Search Input](#search-input)
   - [Replace Input](#replace-input)
   - [Search Results Pane](#search-results-pane)
   - [Preview Pane](#preview-pane)
5. [License](#license)

## Features

- Search for keywords across an entire project folder, with options for case sensitivity, AST Grep and more.
- Replace keywords with options for preserving case, AST Grep and more.
- Interactive preview of search results.
- Keyboard navigation for efficient workflow.
- Configurable key bindings and search modes.

## Installation and Update

### Prerequisites

- [ripgrep](https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation) installed on your system.
- (Optional) [ast-grep](https://ast-grep.github.io) installed on your system, if you want to use the AST Grep functionality.

### Steps

1. Install the application using Cargo:
```bash
cargo install serpl
```
- If you want to install the application with the AST Grep functionality, you can use the following command:
```bash
cargo install serpl --features ast_grep
```
2. Run the application:
```bash
serpl
```

## Usage

### Basic Commands

- Start the application in the current directory:
```bash
serpl
```
- Start the application and provide the project root path:
```bash
serpl --project-root /path/to/project
```

### Key Bindings

Default key bindings can be customized through the `config.json` file.

#### Default Key Bindings

| Key Combination              | Action                                    |
| ---------------------------- | ----------------------------------------- |
| `Ctrl + c`                   | Quit                                      |
| `Ctrl + d`                   | Quit                                      |
| `Ctrl + b`                   | Help                                      |
| `Tab`                        | Switch between tabs                       |
| `Backtab`                    | Switch to previous tabs                   |
| `Ctrl + o`                   | Process replace for all files             |
| `r`                          | Process replace for selected file or line |
| `Ctrl + n`                   | Toggle search and replace modes           |
| `Enter`                      | Execute search (for large folders)        |
| `g` / `Left` / `h`           | Go to top of the list                     |
| `G` / `Right` / `l`          | Go to bottom of the list                  |
| `j` / `Down`                 | Move to the next item                     |
| `k` / `Up`                   | Move to the previous item                 |
| `/`                          | Search results list                       |
| `d`                          | Delete selected file or line              |
| `Esc`                        | Exit the current pane or dialog           |
| `Enter` (in dialogs) / `y`   | Confirm action                            |
| `Esc` (in dialogs) / `n`     | Cancel action                             |
| `h`, `l`, `Tab` (in dialogs) | Navigate dialog options                   |

### Configuration

`serpl` uses a configuration file to manage key bindings and other settings. By default, the path to the configuration file can be found by running `serpl --version`.

#### Example Configurations


```json
{
  "keybindings": {
    "<Ctrl-d>": "Quit",
    "<Ctrl-c>": "Quit",
    "<Tab>": "LoopOverTabs",
    "<Backtab>": "BackLoopOverTabs",
    "<Ctrl-o>": "ProcessReplace",
    "<Ctrl-b>": "ShowHelp"
  }
}
```

## Panes

### Search Input

- Input field for entering search keywords.
- Toggle search modes (Simple, Match Case, Match Whole Word, Match Case Whole Word, Regex, AST Grep).
  - Simple: Search all occurrences of the keyword.
  - Match Case: Search occurrences with the same case as the keyword.
  - Match Whole Word: Search occurrences that match the keyword exactly.
  - Match Case Whole Word: Search occurrences that match the keyword exactly with the same case.
  - Regex: Search occurrences using a regular expression.
  - AST Grep: Search occurrences using AST Grep.

> [!TIP] 
> If current directory is considerebly large, you have to click `Enter` to start the search.

### Replace Input

- Input field for entering replacement text.
- Toggle replace modes (Simple, Preserve Case, AST Grep).
    - Simple: Replace all occurrences of the keyword.
    - Preserve Case: Replace occurrences while preserving the case of the keyword.
    - AST Grep: Replace occurrences using AST Grep.

### Search Results Pane

- List of files with search results.
- Navigation to select and view files.
- Option to delete files from the search results.
- Search results count and current file count.
- Ability to search the list using the `/` key.

### Preview Pane

- Display of the selected file with highlighted search results, and context.
- Navigation to view different matches within the file.
- Option to delete individual lines containing matches.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.