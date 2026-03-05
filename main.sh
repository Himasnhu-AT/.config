#!/bin/bash

# Exit on error, undefined variables
set -e
set -u

# Configuration
REPO_URL="https://raw.githubusercontent.com/Himasnhu-AT/.config/refs/heads/main"
DOWNLOADED_FILES=()

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to download a file if it doesn't exist
ensure_file() {
    local file=$1
    if [ ! -f "$file" ]; then
        echo "Fetching $file from remote..."
        mkdir -p "$(dirname "$file")"
        if command_exists curl; then
            curl -fsSL "$REPO_URL/$file" -o "$file"
        elif command_exists wget; then
            wget -q "$REPO_URL/$file" -O "$file"
        else
            echo "Error: curl or wget is required to download $file"
            exit 1
        fi
        DOWNLOADED_FILES+=("$file")
    fi
}

# Cleanup function
cleanup() {
    if [ ${#DOWNLOADED_FILES[@]} -eq 0 ]; then
        return
    fi

    echo "Cleaning up downloaded files..."
    for file in "${DOWNLOADED_FILES[@]}"; do
        if [ -f "$file" ]; then
            rm "$file"
            # Try to remove the directory if it's empty
            dir=$(dirname "$file")
            if [ "$dir" != "." ]; then
                rmdir "$dir" 2>/dev/null || true
            fi
        fi
    done
}

main() {
    OS="$(uname -s)"
    case "${OS}" in
        Linux*)     OS_NAME=Linux;;
        Darwin*)    OS_NAME=Mac;;
        *)          OS_NAME="UNKNOWN:${OS}"
    esac

    if [ "$OS_NAME" == "Mac" ]; then
        PKG_MGR="brew"
    elif [ "$OS_NAME" == "Linux" ]; then
        if command_exists apt-get; then
            PKG_MGR="apt"
        elif command_exists apk; then
            PKG_MGR="apk"
        else
            echo "Unsupported Linux distribution (neither apt nor apk found)."
            exit 1
        fi
    else
        echo "Unsupported OS: $OS_NAME"
        exit 1
    fi

    echo "Detected OS: $OS_NAME, Package Manager: $PKG_MGR"

    # Load config
    CONFIG_FILE="config.txt"
    if [ ! -f "$CONFIG_FILE" ]; then
        if [ ! -f "config.example.txt" ]; then
            ensure_file "config.example.txt"
        fi

        echo "config.txt not found."
        printf "Would you like to (u)se the default configuration or (s)top to create your own? [u/s]: "
        # Read from /dev/tty to allow interaction even when piped
        read -r choice < /dev/tty

        if [ "$choice" == "u" ]; then
            echo "Proceeding with default configuration (config.example.txt)."
            CONFIG_FILE="config.example.txt"
        else
            cp config.example.txt config.txt
            echo "Created config.txt from example. Please edit it and rerun the script."
            # Don't cleanup if we want them to edit the file
            exit 0
        fi
    fi

    # Function to get config value
    get_config() {
        local key=$1
        local default=$2
        local value=$(grep "^${key}=" "$CONFIG_FILE" | cut -d'=' -f2 || echo "")
        echo "${value:-$default}"
    }

    # Installation helper - redirect stdin from /dev/null to prevent "eating" the script pipe
    pkg_install() {
        local pkg=$1
        echo "Installing $pkg..."
        case "$PKG_MGR" in
            brew)
                brew install "$pkg" < /dev/null
                ;;
            apt)
                sudo apt-get update < /dev/null
                sudo apt-get install -y "$pkg" < /dev/null
                ;;
            apk)
                sudo apk add "$pkg" < /dev/null
                ;;
        esac
    }

    # Git & Git LFS
    if [ "$(get_config git n)" == "y" ]; then
        if ! command_exists git; then
            pkg_install git
        else
            echo "Git is already installed."
        fi

        if ! command_exists git-lfs; then
            pkg_install git-lfs
            git lfs install < /dev/null
        else
            echo "Git LFS is already installed."
        fi
    fi

    # Docker
    if [ "$(get_config docker n)" == "y" ]; then
        if ! command_exists docker; then
            if [ "$OS_NAME" == "Mac" ]; then
                brew install --cask docker < /dev/null
            elif [ "$PKG_MGR" == "apt" ]; then
                ensure_file "docker.sh"
                bash docker.sh < /dev/null
            else
                pkg_install docker
            fi
        else
            echo "Docker is already installed."
        fi
    fi

    # GitHub CLI
    if [ "$(get_config gh n)" == "y" ]; then
        if ! command_exists gh; then
            if [ "$PKG_MGR" == "apt" ]; then
                ensure_file "gh.sh"
                bash gh.sh < /dev/null
            else
                pkg_install gh
            fi
        else
            echo "GitHub CLI is already installed."
        fi

        # Check GitHub authentication - use /dev/tty for interactive login
        if ! gh auth status &>/dev/null; then
            echo "Not authenticated to GitHub. Initiating authentication..."
            gh auth login < /dev/tty
        else
            echo "Already authenticated to GitHub."
        fi
    fi

    # Rust
    if [ "$(get_config rust n)" == "y" ]; then
        if ! command_exists cargo; then
            ensure_file "rust.sh"
            bash rust.sh < /dev/null
        else
            echo "Rust is already installed (cargo found)."
        fi
    fi

    # Neovim
    if [ "$(get_config nvim n)" == "y" ]; then
        if ! command_exists nvim; then
            pkg_install neovim
        fi
        ensure_file "nvim/setup.sh"
        bash nvim/setup.sh < /dev/null

        # Configure Neovim
        mkdir -p "$HOME/.config/nvim"
        ensure_file "nvim/init.vim"
        cp nvim/init.vim "$HOME/.config/nvim/init.vim"
        echo "Neovim configuration copied to $HOME/.config/nvim/init.vim"

        # Install plugins automatically
        echo "Installing Neovim plugins (this may take a moment)..."
        # We use --headless and +PlugInstall to install plugins without opening the UI
        # We ignore errors during this step because the colorscheme won't be found until AFTER install
        nvim --headless +PlugInstall +qall > /dev/null 2>&1 || true
        echo "Neovim plugins installed."
    fi
    # Tmux
    if [ "$(get_config tmux n)" == "y" ]; then
        if ! command_exists tmux; then
            pkg_install tmux
        else
            echo "Tmux is already installed."
        fi
    fi

    # ComfyUI
    if [ "$(get_config comfy n)" == "y" ]; then
        ensure_file "comfy/comfy.sh"
        bash comfy/comfy.sh < /dev/null
    fi

    echo "All requested installations and configurations completed!"
    cleanup
}

main "$@"
