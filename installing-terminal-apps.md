# Installing Terminal Apps

## Connect to GitHub

Create a Personal Access Token:
Go to `GitHub` > `Settings` > `Developer settings` > `Personal access tokens` > `Tokens (classic)`

Click `Generate new token` > `Generate new token (classic)`

Select appropriate scopes (repo, workflow, etc.)

Generate token and copy it (you won't see it again!)

Configure Git with the token:
```
# Set your username
git config --global user.name "Your Name"

# Set your email (must match GitHub email)
git config --global user.email "your.email@example.com"

# Configure credential helper to store your token
git config --global credential.helper store
```

Test it by cloning and pushing to a private repository using HTTPS:
```
git clone https://github.com/username/repo.git
# When prompted for password, use your personal access token
```

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

## Install Ripgrep and Fuzzy Finder

Run:
```
sudo apt update
sudo apt install fzf ripgrep
```

To use `Ripgrep` and `Fuzzy Finder`, run:
```
rg --line-number --no-heading '' | fzf --delimiter : --preview 'batcat --style=numbers --color=always --highlight-line {2} {1}' --preview-window=right:60%:wrap
```

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

## Install Curl

Run:
```
sudo apt install curl
```

## Install Cargo

### Prerequisites

- Curl must be installed

### Installation

Run:
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## Install ftdv

### Prerequisites

- Cargo must be installed

### Installation

Run:
```
cargo install ftdv
```

To use ftdv, run the following command inside a Git repository:
```
ftdv
```

## Install Midnight Commander

Run:
```
sudo apt install mc
```

To use Midnight Commander, run:
```
mc
```

## Install Superfile

### Prerequisites

- Go must be installed

### Installation

Go to the [Superfile GitHub page](https://github.com/yorukot/superfile)

Click on `Releases`

Download the latest correct Linux release

Run:
```
tar -xzf superfile-linux-amd64.tar.gz
sudo mkdir /opt/superfile/
sudo mv dist/superfile-linux-v1.4.0-amd64/spf /opt/superfile/
sudo chmod +x /opt/superfile/spf
```

Ensure this line is added to the `.bashrc` file:
```
export PATH=$PATH:/opt/superfile/
```

To use Superfile, run:
```
spf
```