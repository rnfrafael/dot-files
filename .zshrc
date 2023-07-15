if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zshsource ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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
alias dps="docker ps"
alias dpsa="docker ps -a"
alias drm="docker rm"
alias dvol="docker volume ls"
alias dlogs="docker logs"
alias dexec="docker exec"
alias dexeca="docker exec -it"

# Editor-related aliases
alias codez="code ~/.zshrc"
alias nvz="nvz ~/.zshrc"

# Directory-related aliases
alias winwww="cd /mnt/c/www"
alias workl="cd /home/rnfrafael/www/workana"

# List-related aliases
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias ls="ls --color=auto"

ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/mnt/c)
# fnm
export PATH="/home/rnfrafael/.local/share/fnm:$PATH"
eval "`fnm env`"
eval "$(op completion zsh)"; compdef _op op


