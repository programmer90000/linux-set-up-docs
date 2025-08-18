# Installing Terminal Apps

## Install bat

The `bat` command allows you to view files in the terminal, similar to the `cat` command but with syntax highlighting

Run:
```
sudo apt install bat
```

To use bat, run:
```
batcat file-name
```

## Install tree

The `tree` command is similar to the `ls` commands but displays all sub-directories and files in a tree diagram

Run:
```
sudo apt update
sudo apt install tree
```

To use `tree`, run:
```
tree
```

## Install duf

The `duf` command allows you to view the amount of space used and the amount of free space on your drives

Run:
```
sudo apt update
sudo apt install duf
```

To use `duf`, run:
```
duf
```

## Install ncdu

The `ncdu` command allows you to view the amount of space used by each directory and file

Run:
```
sudo apt update
sudo apt install ncdu
```

To use `ncdu`, run:
```
ncdu
```

This will open an interactive window, from which you can navigate between directories to view the size of each directory file

## Install Gemini CLI

Run:
```
sudo apt update
sudo apt install nodejs npm
```

> Run this even if you have already installed nodejs and npm using the documentation in [installing-apps.md](./installing-apps.md)

Run:
```
node --version
npm --version
```

Ensure node is at version 20.0.0 or higher

Run this command without `sudo`:
```
npm install -g @google/gemini-cli
```

Run:
```
gemini
```

Select:
```
Login with Google
```

Login with your Google account

