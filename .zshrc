if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"   # Apple Silicon
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"      # Intel Mac
fi

export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"

export PNPM_HOME="/Users/himanshu/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export NVM_DIR="$HOME/.nvm"
if [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
  nvm() {
    unfunction nvm
    source "/opt/homebrew/opt/nvm/nvm.sh"
    [[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && \
      source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
    nvm "$@"
  }
elif [[ -s "$NVM_DIR/nvm.sh" ]]; then
  nvm() {
    unfunction nvm
    source "$NVM_DIR/nvm.sh"
    nvm "$@"
  }
fi

export PYENV_ROOT="$HOME/.pyenv"
if [[ -d "$PYENV_ROOT/bin" ]]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init - --no-rehash)"
fi

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS   # no duplicate entries
setopt HIST_IGNORE_SPACE      # lines starting with space are not saved
setopt HIST_VERIFY            # show expanded history before executing
setopt SHARE_HISTORY          # share history between open sessions
setopt INC_APPEND_HISTORY     # write to history immediately

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select              # arrow-key navigation
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive
zstyle ':completion:*' list-colors ''           # colorize completions
zstyle ':completion:*:descriptions' format '%B%d%b'
setopt AUTO_CD                # type a dir name to cd into it
setopt CORRECT                # suggest correction on typo

autoload -Uz vcs_info

precmd() {
  vcs_info
  _git_prompt=""
  if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
    local repo branch
    repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    _git_prompt=$'\n'"%F{magenta}📁 ${repo}%f  %F{white}·%f  %F{yellow}${branch}%f"
  fi
}

setopt PROMPT_SUBST
PROMPT='%F{cyan}%~%f${_git_prompt}
%F{green}❯%f '

export CLICOLOR=1
export LSCOLORS="GxFxCxDxBxegedabagaced"
alias ls='ls -G'
alias ll='ls -lhG'
alias la='ls -lahG'
alias l='ls -lG'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

mkcd() { mkdir -p "$1" && cd "$1"; }

alias gi='git init'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate --all'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gst='git stash'
alias gstp='git stash pop'

alias h='history'
alias c='clear'
alias q='exit'
alias path='echo -e ${PATH//:/\\n}'
alias ports='lsof -i -P -n | grep LISTEN'
alias ip='ipconfig getifaddr en0'
alias pubip='curl -s ifconfig.me'
alias week='date +%V'
alias now='date +"%T"'
alias today='date +"%Y-%m-%d"'

alias zshconfig='nvim ~/.zshrc'
alias zshreload='source ~/.zshrc && echo "✅ .zshrc reloaded"'

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias dsclean='find . -name ".DS_Store" -delete'
alias lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

extract() {
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.tar.xz)  tar xJf "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.gz)      gunzip "$1"  ;;
    *.zip)     unzip "$1"   ;;
    *.7z)      7z x "$1"    ;;
    *.rar)     unrar e "$1" ;;
    *) echo "Unknown archive format: $1" ;;
  esac
}

ff()      { find . -name "*$1*" 2>/dev/null; }
bak()     { cp "$1" "${1}.bak.$(date +%Y%m%d_%H%M%S)"; echo "Backed up: $1"; }
duf()     { du -sh -- * | sort -rh | head -20; }
has()     { command -v "$1" &>/dev/null && echo "✅ $1 found" || echo "❌ $1 not found"; }
preview() { if command -v bat &>/dev/null; then bat "$1"; else cat -n "$1"; fi }

bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

export EDITOR="nvim"
export VISUAL="$EDITOR"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

echo "👋 Welcome back, $(whoami)! $(date '+%A, %d %b %Y — %H:%M')"
echo "   Tip: type 'zshconfig' to edit · 'zshreload' to reload"
