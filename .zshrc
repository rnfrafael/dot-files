if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zshsource ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias z=zellij
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

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
export PATH="/mnt/c/Users/rnfra/AppData/Local/Programs/cursor/resources/app/bin:$PATH"
export PATH="/home/rnfrafael/www/notifique/flutter/flutter/bin:$PATH"
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
alias wsconf="nvim /mnt/c/Users/Rafonte/.ssh/config"

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

# Turso
export PATH="/home/rnfrafael/.turso:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

PATH=~/.console-ninja/.bin:$PATH
# Generate commit message for unstaged changes
ccm() {
    git diff | cody chat --stdin -m "Write a commit message for this diff using conventional commits, show only the message without any explanation."
}

# Generate commit message for staged changes
ccm_staged() {
    git diff --cached | cody chat --stdin -m "Write a commit message for this diff using conventional commits, show only the message without any explanation."
}

# Generate commit message and explanation for unstaged changes
ccm_explain() {
    git diff | cody chat --stdin -m "Analyze this diff and provide: 1) A conventional commit message 2) A detailed explanation of the changes. Format as 'message: explanation'"
}

# Generate message and auto-commit staged changes
ccm_auto() {
    local message=$(git diff --cached | cody chat --stdin -m "Write a commit message for this diff using conventional commits, show only the message without any explanation.")
    echo "Committing with message: $message"
    git commit -m "$message"
}

# Generate message for a specific file
ccm_file() {
    if [ -z "$1" ]; then
        echo "Usage: ccm_file <file_path>"
        return 1
    fi
    git diff "$1" | cody chat --stdin -m "Write a commit message for this diff using conventional commits, show only the message without any explanation."
}

# Analyze impact of changes and generate detailed commit
ccm_analyze() {
    echo "🔍 Analyzing changes..."
    git diff --cached | cody chat --stdin -m "Analyze this diff and provide:
    1) A conventional commit message
    2) Impact analysis (what parts of the system are affected)
    3) Breaking changes (if any)
    4) Testing recommendations
    Format as 'message|impact|breaking|testing' using | as separator"
}

# Interactive commit helper
ccm_interactive() {
    echo "📝 Generating commit suggestions..."
    local message=$(git diff --cached | cody chat --stdin -m "Write 3 alternative conventional commit messages for this diff, number them 1-3")
    
    echo "Choose a commit message or type your own:"
    echo "$message"
    echo "4) Enter custom message"
    
    read -p "Select option (1-4): " choice
    
    if [ "$choice" = "4" ]; then
        read -p "Enter your commit message: " custom_message
        git commit -m "$custom_message"
    elif [ "$choice" -ge 1 ] && [ "$choice" -le 3 ]; then
        local selected_message=$(echo "$message" | grep "^$choice" | sed "s/^$choice) //")
        git commit -m "$selected_message"
    else
        echo "Invalid choice"
        return 1
    fi
}

# Brief help function
ccm_help() {
    echo "Git Commit Message Helper Commands:"
    echo "ccm              - Generate commit message for unstaged changes"
    echo "ccm_staged      - Generate commit message for staged changes"
    echo "ccm_explain     - Generate commit message with detailed explanation"
    echo "ccm_auto        - Auto-commit staged changes with generated message"
    echo "ccm_file <path> - Generate commit message for specific file"
    echo "ccm_analyze     - Detailed analysis of staged changes"
    echo "ccm_interactive - Interactive commit message selection"
}
