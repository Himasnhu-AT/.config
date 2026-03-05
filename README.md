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

## Quick Start (Zero-Clone)

Run the following command to start the installation automatically on macOS (Homebrew), Ubuntu/Debian (apt), or Alpine (apk):

```bash
curl -fsSL https://raw.githubusercontent.com/Himasnhu-AT/.config/refs/heads/main/main.sh | bash
```

*Note: If no `config.txt` exists in your current directory, it will download and use `config.example.txt` as the default configuration.*

## Usage (Manual)

   ```bash
   git clone https://github.com/himasnhu-at/.config.git
   cd .config
   ```

2. Create a `config.txt` file based on the example:

   ```bash
   cp config.example.txt config.txt
   ```

3. Edit `config.txt` to enable ('y') or disable ('n') the tools you want to install.

4. Run the main setup script:

   ```bash
   bash main.sh
   ```

## Supported Systems

- **macOS**: Uses `Homebrew`.
- **Ubuntu/Debian**: Uses `apt`.
- **Alpine Linux**: Uses `apk`.

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
