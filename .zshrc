if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zshsource ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias z=zellij

. "$HOME/.asdf/asdf.sh"
# append completions to fpath
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.zsh/zsh-you-should-use/zsh-you-should-use.plugin.zsh

export PATH="/home/rnfrafael/.mscripts:$PATH"
export PATH="/mnt/c/Users/rnfra/AppData/Local/Programs/Microsoft VS Code/bin:$PATH"

# Specify the location where command history will be saved
HISTFILE="$HOME/.zsh_history"
# Increase the maximum number of commands stored in the history file
HISTSIZE=10000
SAVEHIST=10000
# Ignore duplicate commands and commands that start with a space
setopt histignoredups
setopt histignorespace
# Save each command as it is entered, rather than at the end of the session
setopt inc_append_history
setopt share_history
# Append new commands to the history file instead of overwriting it
setopt append_history
# Ignore specific commands by not saving them in the history
# Add any commands you want to ignore to the 'ignorespace' array
ignorespace=('ls' 'cd')
# Save each command as it is entered, rather than at the end of the session
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

source ~/.zsh_functions

##SSH ALIAS
alias ssh='ssh.exe'
alias ssh-add='ssh-add.exe'

# Key bindings for moving cursor within a line
bindkey '^a' beginning-of-line       # Ctrl + A - Move cursor to beginning of line
bindkey '^e' end-of-line             # Ctrl + E - Move cursor to end of line

# Key bindings for history search
bindkey '^[[1;5A' history-substring-search-up    # Ctrl + Up Arrow - History substring search up
bindkey '^[[A' history-substring-search-up    # Up Arrow - History substring search up
bindkey '^[[1;5B' history-substring-search-down  # Ctrl + Down Arrow - History substring search down
bindkey '^[[A' history-substring-search-down  # Down Arrow - History substring search down

# Key bindings for word movement
bindkey '^[[1;5D' backward-word      # Ctrl + Left Arrow - Move cursor to beginning of word
bindkey '^[[1;5C' forward-word       # Ctrl + Right Arrow - Move cursor to end of word

# Cloudflare DNS over HTTPS
alias cfl="cloudflared"
alias cflt="cloudflared tunnel"
alias cfltrun="cloudflared tunnel run"
alias cflroute="cloudflared tunnel route dns"

# Docker aliases
alias d="docker"
alias dco="docker-compose"

# Editor-related aliases
alias codez="code ~/.zshrc"
alias nvz="nvim ~/.zshrc"
alias nvconf="nvim ~/.config/nvim/init.vim"
alias nvcoc="nvim ~/.config/nvim/coc-settings.json"

# Directory-related aliases
alias winwww="cd /mnt/c/www"
alias wsconf="vim /mnt/c/Users/Rafonte/.ssh/config"

# List-related aliases
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias ls="ls --color=auto"

# nvim aliases with asdf package
alias update-nvim='asdf uninstall neovim stable && asdf install neovim stable'
alias update-nvim-nightly='asdf uninstall neovim nightly && asdf install neovim nightly'
alias update-nvim-master='asdf uninstall neovim ref:master && asdf install neovim ref:master'

ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/mnt/c)

export PATH="$HOME/.local/share/fnm:$PATH"
eval "`fnm env`"
eval "$(op completion zsh)"; compdef _op op

export PATH="$PATH:/snap/bin"

# pnpm
export PNPM_HOME="/home/rnfrafael/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/root/.bun/_bun" ] && source "/root/.bun/_bun"
[ -s "/home/rnfrafael/.bun/_bun" ] && source "/home/rnfrafael/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
