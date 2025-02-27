# .config

My configuration for Neovim.

## Install

### Run `setup.sh`

> ![IMPORTANT]
> Ensure that brew is installed for macOS.

`setup.sh` will install important packages like:
- git
- curl
- plug.vim

### Open `init.vim` using Neovim and run the command:
```
:PlugInstall
```
to install all plugins and then restart Neovim.

## Shortcuts

- `CTRL + F`: Focus on NERDTree
- `CTRL + N`: Open NERDTree
- `CTRL + T`: Toggle NERDTree
- `F8`: Toggle Tagbar

## Commands

- `:NERDTree`: Get a tree structure of your repository to browse through.
- `:TagbarToggle`: Toggle the Tagbar for code navigation.
- `:PlugClean`: Clean unused plugins.
- `:PlugInstall`: Install plugins.
- `:UpdateRemotePlugin`: Update remote plugins.
- `:SQLSetType pgsql.vim`: Set SQL type for PostgreSQL syntax highlighting.
- `gcc` or `gc`: Comment or uncomment lines using vim-commentary.
- `:AirlineTheme <theme>`: Change the vim-airline theme.
- `:MultipleCursorsFind <pattern>`: Find and select multiple cursors based on a pattern.
- `CTRL + N`: Add a new cursor at the next occurrence of the word under the cursor (vim-multiple-cursors).

## Plugins Used

- `vim-surround`: Surrounding text objects easily (`ysw)`).
- `nerdtree`: File system explorer for the Vim editor.
- `vim-commentary`: Commenting utility (`gcc` & `gc`).
- `vim-airline`: Status bar enhancement.
- `pgsql.vim`: PostgreSQL syntax highlighting and more (`:SQLSetType pgsql.vim`).
- `vim-css-color`: CSS color preview.
- `awesome-vim-colorschemes`: Collection of retro color schemes.
- `vim-devicons`: Developer icons.
- `vim-terminal`: Terminal integration within Vim.
- `tagbar`: Code navigation using tags.
- `vim-multiple-cursors`: Multiple cursors (`CTRL + N`).

## Configuration

- Line numbers and relative line numbers are enabled.
- Indentation settings:
  - `tabstop=4`
  - `shiftwidth=4`
  - `softtabstop=4`
  - `autoindent`
  - `smarttab`
- Mouse support is enabled.
- UTF-8 encoding is set.
- The colorscheme is set to `jellybeans`.
- NERDTree directory arrows are customized:
  - Expandable: `+`
  - Collapsible: `~`
- Preview for completion is disabled.

> Note: Some plugins and settings are commented out or marked as notes within the `init.vim` file.
