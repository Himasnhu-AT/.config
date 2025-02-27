#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install packages on Linux
install_linux_packages() {
    # Ensure git is installed
    if ! command_exists git; then
        sudo apt update
        sudo apt install -y git
    else
        echo "git is already installed"
    fi

    # Ensure curl is installed
    if ! command_exists curl; then
        sudo apt install -y curl
    else
        echo "curl is already installed"
    fi

    if ! command_exists ctags; then
        sudo apt install -y exuberant-ctags
    else
        echo "exuberant-ctags is already installed"
    fi

    if ! command_exists "node -v"; then
        sudo apt install -y nodejs
    else
        echo "nodejs is already installed"
    fi

    if ! command_exists npm; then
        sudo apt install -y npm
    else
        echo "npm is already installed"
    fi
}

# Function to install packages on macOS
install_macos_packages() {
    # Ensure git is installed
    if ! command_exists git; then
        brew install git
    else
        echo "git is already installed"
    fi

    # Ensure curl is installed
    if ! command_exists curl; then
        brew install curl
    else
        echo "curl is already installed"
    fi

    # Ensure ctags is installed
    if ! command_exists ctags; then
        brew install ctags
    else
        echo "ctags is already installed"
    fi

    if ! command_exists node; then
        brew install node
    else
        echo "nodejs is already installed"
    fi

    if ! command_exists npm; then
        brew install npm
    else
        echo "npm is already installed"
    fi
}

# Detect the OS and install the appropriate packages
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_linux_packages
elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_macos_packages
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

# Install vim-plug
if [ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]; then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
else
    echo "vim-plug is already installed"
fi

echo "Setup completed successfully!"
