# Enable Powerlevel10k instant prompt (put this at the very top of .zshrc)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Silence the warning message
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Load theme (fix the duplicate entries you currently have)
source ~/powerlevel10k/powerlevel10k.zsh-theme

# Load p10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias zl='zellij'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

alias lz='lazygit'

alias c.='cursor .'

. "$HOME/.asdf/asdf.sh"
# append completions to fpath



# Download and source zsh-defer
[[ -f ~/.zsh-defer/zsh-defer.plugin.zsh ]] || {
  mkdir -p ~/.zsh-defer
  curl -L https://raw.githubusercontent.com/romkatv/zsh-defer/master/zsh-defer.plugin.zsh >~/.zsh-defer/zsh-defer.plugin.zsh
}
source ~/.zsh-defer/zsh-defer.plugin.zsh

# Defer loading of slow plugins
zsh-defer source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
zsh-defer source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
zsh-defer source ~/.zsh/zsh-you-should-use/zsh-you-should-use.plugin.zsh
zsh-defer source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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


# Generate commit message for unstaged changes
ccm() {
    git diff | cody chat --stdin -m "Write a commit message for this diff using conventional commits, return a symary from all files inside a commit message, use the title and add description too"
}

# Generate commit message for staged changes
ccm_staged() {
    git diff --cached | cody chat --stdin -m "Write a commit message for this diff using conventional commits, return a sumary from all files inside a commit message, use the title and add description too"
}

# Generate commit message and explanation for unstaged changes
ccm_explain() {
    git diff | cody chat --stdin -m "Analyze this diff and provide: 1) A conventional commit message 2) A detailed explanation of the changes. Format as 'message: explanation'"
}

# Generate message and auto-commit staged changes
ccm_auto() {
    local message=$(git diff --cached | cody chat --stdin -m "Write a commit message for this diff using conventional commits, return a sumary from all files inside a commit message, use the title and add description too this message will be used as commit automatically, so just show the commit message without any extra text.")
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

# Interactive commit helper with fixed read command and diff handling
ccm_interactive() {
    echo "📝 Generating commit suggestions..."
    
    # Check if there are staged changes
    if ! git diff --cached --quiet; then
        local message=$(git diff --cached | cody chat --stdin -m "Write 3 alternative conventional commit messages for this diff, number them 1-3")
    else
        # If no staged changes, check unstaged changes
        if ! git diff --quiet; then
            local message=$(git diff | cody chat --stdin -m "Write 3 alternative conventional commit messages for this diff, number them 1-3")
        else
            echo "No changes detected (staged or unstaged)"
            return 1
        fi
    fi
    
    echo "Choose a commit message or type your own:"
    echo "$message"
    echo "4) Enter custom message"
    
    # Fixed read command
    read choice
    
    case "$choice" in
        1|2|3)
            local selected_message=$(echo "$message" | grep "^$choice" | sed "s/^$choice) //")
            if [ -n "$selected_message" ]; then
                git commit -m "$selected_message"
            else
                echo "Failed to extract message"
                return 1
            fi
            ;;
        4)
            echo "Enter your commit message:"
            read custom_message
            if [ -n "$custom_message" ]; then
                git commit -m "$custom_message"
            else
                echo "No message provided"
                return 1
            fi
            ;;
        *)
            echo "Invalid choice"
            return 1
            ;;
    esac
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
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/.local/bin"
alias podman='podman-remote-static-linux_amd64'
alias apksigner='~/Android/Sdk/build-tools/34.0.0/apksigner'

eval "$(zoxide init zsh)"

gh_create_issue() {
    echo "Creating a new GitHub issue..."
    
    # Ask for the main goal of the issue
    echo -n "What's the main goal of this issue? "
    read main_goal
    
    # Ask for description
    echo -n "Provide a description (press Enter, then Ctrl+D when finished): "
    description=$(cat)
    
    # Ask for any important data
    echo -n "Any important data to include? (press Enter, then Ctrl+D when finished): "
    important_data=$(cat)
    
    # Combine all collected data
    collected_data="Main goal: $main_goal

Description:
$description

Important data:
$important_data"
    
 # Generate the issue content using Cody
    echo "Generating issue content with AI..."
    
    # Use a temporary file to store the AI-generated content
    temp_file=$(mktemp)
    
    # Request the AI to generate both title and body
    cody chat -m "Write a GitHub issue with a title and body using this information as base: $collected_data. Format your response with first line as the title, then a blank line, then the markdown body. Make sure the title is specific and descriptive." > "$temp_file"
    
    # Extract the first line as title and the rest as body
    issue_title=$(head -n 1 "$temp_file")
    issue_body=$(tail -n +3 "$temp_file")
    
    # Ensure we have a title
    if [ -z "$issue_title" ]; then
        issue_title="$main_goal"
    fi
    
    # Create the issue using GitHub CLI
    echo "Creating issue with title: $issue_title"
    gh issue create --title "$issue_title" --body "$issue_body"
    
    # Clean up
    rm "$temp_file"
    
    echo "Issue created successfully!"

}

gh_ci_node() {
    echo "Creating a new GitHub issue..."
    
    # Project context information
    project_context="This is a Node.js/TypeScript project. Consider TypeScript syntax and Node.js environment when providing solutions."
    
    # Ask for the main goal of the issue
    echo -n "What's the main goal of this issue? "
    read main_goal
    
    # Ask for description
    echo -n "Provide a description (press Enter, then Ctrl+D when finished): "
    description=$(cat)
    
    # Ask for any important data
    echo -n "Any important data to include? (press Enter, then Ctrl+D when finished): "
    important_data=$(cat)
    
    # Ask for specific technologies related to this issue
    echo -n "Any specific technologies/libraries used for this issue? (e.g., Express, React, etc.): "
    read specific_tech
    
    # Combine all collected data with proper context
    collected_data="$project_context

Main goal: $main_goal

Description:
$description

Technologies: Node.js, TypeScript, $specific_tech

Important data:
$important_data"
    
    # Generate the issue content using Cody
    echo "Generating issue content with AI..."
    
    # Use a temporary file to store the AI-generated content
    temp_file=$(mktemp)
    
    # Request the AI to generate both title and body with proper context
    cody chat -m "Write a GitHub issue for a Node.js/TypeScript project with a title and body using this information as base: $collected_data. The issue should be written with TypeScript/Node.js context in mind. Format your response with first line as the title, then a blank line, then the markdown body. Make sure the title is specific and descriptive. Include any TypeScript/Node.js specific considerations in the body." > "$temp_file"
    
    # Extract the first line as title and the rest as body
    issue_title=$(head -n 1 "$temp_file")
    issue_body=$(tail -n +3 "$temp_file")
    
    # Ensure we have a title
    if [ -z "$issue_title" ]; then
        issue_title="$main_goal"
    fi
    
    # Create the issue using GitHub CLI
    echo "Creating issue with title: $issue_title"
    gh issue create --title "$issue_title" --body "$issue_body"
    
    # Clean up
    rm "$temp_file"
    
    echo "Issue created successfully!"
}

autoload -Uz compinit
#if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
#if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
#if [[ -f ${ZDOTDIR:=$HOME}/.zcompdump && $(date +%s) - $(stat -c %Y ${ZDOTDIR}/.zcompdump) -gt 86400 ]]; then
if [[ -f ${ZDOTDIR:=$HOME}/.zcompdump(Nm-24) ]]; then
  compinit
else
  compinit -C
fi

