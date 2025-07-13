# batcat

## Description:
batcat is a clone of cat with syntax highlighting, Git integration, and paging

## Usage:
```
batcat [OPTIONS] <FILE(S)>
```

## Examples:
```
batcat file.txt                      # View file with syntax highlighting and line numbers
batcat -n file.txt                   # Add line numbers (redundant; default behavior)
batcat -p file.txt                   # Plain output (like regular cat, no decoration)
batcat -A file.txt                   # Show non-printable characters
batcat file1.txt file2.txt           # View multiple files
```

## Paging with search and scroll (uses less internally)
```
batcat large_script.py
Common Options:
Option	Description
-n	Show line numbers
-p	Disable decorations (plain mode)
-A	Show all characters (incl. invisible)
--theme	Set syntax highlighting theme
--paging	Control paging (always, never)
```

# tree

## Description:
tree recursively lists directory contents in a tree-like format.

## Usage:
```
tree [OPTIONS] [DIRECTORY]
```

## Examples:
```
tree                             # List current directory in tree format
tree /var/log                    # Tree view of /var/log
tree -L 2                        # Limit depth to 2 levels
tree -a                         # Include hidden files
tree -d                         # List directories only
tree -h                         # Show human-readable file sizes
```

## Common Options:
| Option     |Description                           |
|------------|--------------------------------------|
|-L (number) |	Max display depth of directory tree |
|-a	         | Show all files (include hidden)      |
|-d	         | List directories only                |
|-h	         | Print human-readable sizes           |
|-f	         | Print full path prefix for files     |
|--noreport  | Omit summary (file count, etc.)      |

# duf

## Description:
duf (Disk Usage/Free) is a modern replacement for df, showing disk usage in a colorful, human-readable way.

## Usage:
```
duf [OPTIONS]
```

## Examples:
```
duf                             # Show all mounted filesystems
duf /home                       # Show usage for a specific path
duf -only local                 # Show only local filesystems
duf -hide tmpfs,devtmpfs        # Exclude specific filesystems
duf -json                       # Output in JSON format
```

## Common Options:
| Option        | Description                          |
|---------------|--------------------------------------|
| --all	        | Show all mount points                |
| --only <type> | Filter by type (local, network, etc) |
| --hide <fs>   | Hide specific filesystem types       |
| --json	    | Output in JSON                       |
| --sort	    | Sort by size, used, avail, etc.      |

# hstr

Press `Ctrl + R` to view a full-screen menu of previous commands

Press `Escape` to quit this view

Cycle through these commands using the `Up/ Down arrow keys`

Press `Tab` to select a command.

Press `Delete` to delete a command

# check-internet-connection.sh

Run: `check-internet-connection.sh`

Enter a ping target (e.g. `8.8.8.8` or `google.com`)

The command will output if that address is reachable

# check-if-process-running.sh

Run: `check-if-process-running.sh`

Enter a process name (e.g. `bash`)

The command will output if that process is running

# network-ping.sh

Run: `network-ping.sh`

Enter a network prefix (e.g. `192.168.1`)

The command will output which hosts are reachable

# check-disk-space.sh

Run: `check-disk-space.sh`

The command will output the space used and the space avaliable on each partiton of each disk