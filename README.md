# .config

A tool for automating development environment setup on virtual machines.

## Overview

.config automates the process of configuring a new development environment, installing required dependencies, and setting up tools. This saves time and ensures consistent environments across different machines.

## Features

- Automated installation of essential development tools
- Docker and container utilities setup
- Git and GitHub integration (including Git LFS)
- Neovim configuration with plugins
- Tmux installation
- Rust toolchain setup
- ComfyUI setup with cloud tunnel access

## Components

### Core Utilities

The setup installs and configures:

- Docker and Docker Compose
- Git and Git LFS
- GitHub CLI with authentication
- Neovim with plugins
- Tmux
- Rust toolchain

### Neovim Configuration

The setup includes a full-featured Neovim configuration with:

- File system navigation (NERDTree)
- Syntax highlighting
- Code commenting utilities
- Status bar enhancement
- Multiple cursors support
- Git integration
- Code navigation

### ComfyUI Setup

Automates the setup of ComfyUI with:

- Virtual environment configuration
- Required dependencies
- Custom nodes
- Cloud access via Cloudflare Tunnel

## Usage

1. Clone this repository:

   ```bash
   git clone https://github.com/himasnhu-at/.config.git
   cd .config
   ```

2. Run the main setup script:

   ```bash
   bash .config/main.sh
   ```

3. For ComfyUI setup, run:
   ```bash
   bash .config/comfy/comfy.sh
   ```

## Individual Components

### Dependencies Installation

```bash
bash .config/deps.sh
```

### Neovim Setup

```bash
bash .config/nvim/setup.sh
```

## Customization

You can modify the configuration files to suit your needs:

- Edit `.config/nvim/init.vim` to customize Neovim
- Modify `.config/deps.sh` to add or remove dependencies
- Edit `.config/main.sh` to change the overall setup workflow

## Requirements

- Ubuntu or compatible Linux distribution
- Sudo access
- Internet connection

## License

[MIT License](LICENSE)
