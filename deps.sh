#!/bin/bash

# Exit on error
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check and install Docker if needed
if ! command_exists docker; then
    echo "Docker not found. Installing Docker..."

    bash docker.sh
    echo "Docker installed successfully."
    echo "You may need to log out and back in for the docker group changes to take effect."
else
    echo "Docker is already installed."
fi

# Check and install Git if needed
if ! command_exists git; then
    echo "Git not found. Installing Git..."
    sudo apt-get update
    sudo apt-get install -y git
    echo "Git installed successfully."
else
    echo "Git is already installed."
fi

# Check and install Git LFS if needed
if ! command_exists git-lfs; then
    echo "Git LFS not found. Installing Git LFS..."
    sudo apt-get update
    sudo apt-get install -y git-lfs
    git lfs install
    echo "Git LFS installed successfully."
else
    echo "Git LFS is already installed."
fi

# Check and install GitHub CLI if needed
if ! command_exists gh; then
    echo "GitHub CLI not found. Installing GitHub CLI..."

    bash gh.sh
    echo "GitHub CLI installed successfully."
else
    echo "GitHub CLI is already installed."
fi

# Check and install Neovim if needed
if ! command_exists nvim; then
    echo "Neovim not found. Installing Neovim..."
    sudo apt-get update
    sudo apt-get install -y neovim
    echo "Neovim installed successfully."
else
    echo "Neovim is already installed."
fi

# Check and install Tmux if needed
if ! command_exists tmux; then
    echo "Tmux not found. Installing Tmux..."
    sudo apt-get update
    sudo apt-get install -y tmux
    echo "Tmux installed successfully."
else
    echo "Tmux is already installed."
fi

# Check GitHub authentication
if ! gh auth status &>/dev/null; then
    echo "Not authenticated to GitHub. Initiating authentication..."
    gh auth login
    echo "GitHub authentication completed."
else
    echo "Already authenticated to GitHub."
fi

echo "All installations and authentications completed!"
echo "Note: If Docker was just installed, you may need to log out and back in for the docker group changes to take effect."
