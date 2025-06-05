starship init fish | source
if status is-interactive
    # Commands to run in interactive sessions can go here
end
# Fish configuration file
# Save this as ~/.config/fish/config.fish

# ============================================================================
# ALIASES
# ============================================================================

# General aliases
alias zl='zellij'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
alias lz='lazygit'
alias c.='cursor .'
alias adb='/mnt/c/Users/Rafonte/AppData/Local/Android/Sdk/platform-tools/adb.exe'

# Cloudflare DNS over HTTPS
alias cfl="cloudflared"
alias cflt="cloudflared tunnel"
alias cfltrun="cloudflared tunnel run"
alias cflroute="cloudflared tunnel route dns"

# Docker aliases
alias d="docker"
alias dco="docker-compose"

# Editor-related aliases
alias codez="code ~/.config/fish/config.fish"
alias nvz="nvim ~/.config/fish/config.fish"
alias nvconf="nvim ~/.config/nvim/init.vim"
alias nvcoc="nvim ~/.config/nvim/coc-settings.json"

# Directory-related aliases
alias winwww="cd /mnt/c/www"
alias wsconf="nvim /mnt/c/Users/Rafonte/.ssh/config"

# List-related aliases
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias ls="ls -lah --color=auto"

# SSH aliases
alias ssh='ssh.exe'
alias ssh-add='ssh-add.exe'

# Android/Java aliases
alias apksigner='~/Android/Sdk/build-tools/34.0.0/apksigner'
alias podman='podman-remote-static-linux_amd64'

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

# PATH additions
set -gx PATH $HOME/.mscripts $PATH
set -gx PATH /mnt/c/Users/rnfra/AppData/Local/Programs/Microsoft\ VS\ Code/bin $PATH
set -gx PATH /mnt/c/Users/rnfra/AppData/Local/Programs/cursor/resources/app/bin $PATH
set -gx PATH $HOME/www/notifique/flutter/flutter/bin $PATH
set -gx PATH /snap/bin $PATH
set -gx PATH /usr/local/bin $PATH
set -gx PATH $HOME/.local/bin $PATH

# asdf paths
set -gx PATH $HOME/.asdf/shims $PATH
set -gx PATH $HOME/.asdf/bin $PATH

# Common Neovim installation paths
set -gx PATH /usr/bin $PATH
set -gx PATH /usr/local/bin $PATH

# Java and Android
set -gx JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64
set -gx PATH $JAVA_HOME/bin $PATH
set -gx ANDROID_HOME /mnt/c/Users/Rafonte/AppData/Local/Android/Sdk
set -gx PATH $ANDROID_HOME/cmdline-tools/latest/bin $PATH
set -gx PATH $ANDROID_HOME/platform-tools $PATH

# pnpm
set -gx PNPM_HOME $HOME/.local/share/pnpm
if not string match -q "*:$PNPM_HOME:*" ":$PATH:"
    set -gx PATH $PNPM_HOME $PATH
end

# bun
set -gx BUN_INSTALL $HOME/.bun
set -gx PATH $BUN_INSTALL/bin $PATH

# Turso
set -gx PATH $HOME/.turso $PATH

# fnm (Fast Node Manager)
set -gx PATH $HOME/.local/share/fnm $PATH

# ============================================================================
# HISTORY CONFIGURATION
# ============================================================================

# Fish handles history differently - these are the equivalent settings
set -g fish_history_save_dir $HOME/.local/share/fish
set -g fish_history_max 10000

# ============================================================================
# KEY BINDINGS
# ============================================================================

# Fish uses different key binding syntax
# These provide similar functionality to your zsh bindings
bind \ca beginning-of-line        # Ctrl + A
bind \ce end-of-line             # Ctrl + E
bind \e\[1\;5D backward-word     # Ctrl + Left Arrow
bind \e\[1\;5C forward-word      # Ctrl + Right Arrow

# ============================================================================
# FUNCTIONS (replacing your zsh functions)
# ============================================================================

# Generate commit message for unstaged changes
function ccm
    git diff | cody chat --stdin -m "Write a commit message for this diff using conventional commits, return a summary from all files inside a commit message, use the title and add description too"
end

# Generate commit message for staged changes
function ccm_staged
    git diff --cached | cody chat --stdin -m "Write a commit message for this diff using conventional commits, return a summary from all files inside a commit message, use the title and add description too"
end

# Generate commit message and explanation for unstaged changes
function ccm_explain
    git diff | cody chat --stdin -m "Analyze this diff and provide: 1) A conventional commit message 2) A detailed explanation of the changes. Format as 'message: explanation'"
end

# Generate message and auto-commit staged changes
function ccm_auto
    set message (git diff --cached | cody chat --stdin -m "Write a commit message for this diff using conventional commits, return a summary from all files inside a commit message, use the title and add description too this message will be used as commit automatically, so just show the commit message without any extra text.")
    echo "Committing with message: $message"
    git commit -m "$message"
end

# Generate message for a specific file
function ccm_file
    if test (count $argv) -eq 0
        echo "Usage: ccm_file <file_path>"
        return 1
    end
    git diff $argv[1] | cody chat --stdin -m "Write a commit message for this diff using conventional commits, show only the message without any explanation."
end

# Analyze impact of changes and generate detailed commit
function ccm_analyze
    echo "🔍 Analyzing changes..."
    git diff --cached | cody chat --stdin -m "Analyze this diff and provide:
    1) A conventional commit message
    2) Impact analysis (what parts of the system are affected)
    3) Breaking changes (if any)
    4) Testing recommendations
    Format as 'message|impact|breaking|testing' using | as separator"
end

# Interactive commit helper
function ccm_interactive
    echo "📝 Generating commit suggestions..."

    # Check if there are staged changes
    if not git diff --cached --quiet
        set message (git diff --cached | cody chat --stdin -m "Write 3 alternative conventional commit messages for this diff, number them 1-3")
    else
        # If no staged changes, check unstaged changes
        if not git diff --quiet
            set message (git diff | cody chat --stdin -m "Write 3 alternative conventional commit messages for this diff, number them 1-3")
        else
            echo "No changes detected (staged or unstaged)"
            return 1
        end
    end

    echo "Choose a commit message or type your own:"
    echo "$message"
    echo "4) Enter custom message"

    read -P "Choice: " choice

    switch $choice
        case 1 2 3
            set selected_message (echo "$message" | grep "^$choice" | sed "s/^$choice) //")
            if test -n "$selected_message"
                git commit -m "$selected_message"
            else
                echo "Failed to extract message"
                return 1
            end
        case 4
            read -P "Enter your commit message: " custom_message
            if test -n "$custom_message"
                git commit -m "$custom_message"
            else
                echo "No message provided"
                return 1
            end
        case '*'
            echo "Invalid choice"
            return 1
    end
end

# Brief help function
function ccm_help
    echo "Git Commit Message Helper Commands:"
    echo "ccm              - Generate commit message for unstaged changes"
    echo "ccm_staged      - Generate commit message for staged changes"
    echo "ccm_explain     - Generate commit message with detailed explanation"
    echo "ccm_auto        - Auto-commit staged changes with generated message"
    echo "ccm_file <path> - Generate commit message for specific file"
    echo "ccm_analyze     - Detailed analysis of staged changes"
    echo "ccm_interactive - Interactive commit message selection"
end

# GitHub issue creation function
function gh_create_issue
    echo "Creating a new GitHub issue..."

    read -P "What's the main goal of this issue? " main_goal
    
    echo "Provide a description (press Ctrl+D when finished):"
    set description (cat)
    
    echo "Any important data to include? (press Ctrl+D when finished):"
    set important_data (cat)

    set collected_data "Main goal: $main_goal

Description:
$description

Important data:
$important_data"

    echo "Generating issue content with AI..."
    
    set temp_file (mktemp)
    
    cody chat -m "Write a GitHub issue with a title and body using this information as base: $collected_data. Format your response with first line as the title, then a blank line, then the markdown body. Make sure the title is specific and descriptive." > $temp_file

    set issue_title (head -n 1 $temp_file)
    set issue_body (tail -n +3 $temp_file)

    if test -z "$issue_title"
        set issue_title "$main_goal"
    end

    echo "Creating issue with title: $issue_title"
    gh issue create --title "$issue_title" --body "$issue_body"

    rm $temp_file
    echo "Issue created successfully!"
end

# GitHub issue creation for Node.js projects
function gh_ci_node
    echo "Creating a new GitHub issue..."

    set project_context "This is a Node.js/TypeScript project. Consider TypeScript syntax and Node.js environment when providing solutions."

    read -P "What's the main goal of this issue? " main_goal
    
    echo "Provide a description (press Ctrl+D when finished):"
    set description (cat)
    
    echo "Any important data to include? (press Ctrl+D when finished):"
    set important_data (cat)
    
    read -P "Any specific technologies/libraries used for this issue? (e.g., Express, React, etc.): " specific_tech

    set collected_data "$project_context

Main goal: $main_goal

Description:
$description

Technologies: Node.js, TypeScript, $specific_tech

Important data:
$important_data"

    echo "Generating issue content with AI..."
    
    set temp_file (mktemp)
    
    cody chat -m "Write a GitHub issue for a Node.js/TypeScript project with a title and body using this information as base: $collected_data. The issue should be written with TypeScript/Node.js context in mind. Format your response with first line as the title, then a blank line, then the markdown body. Make sure the title is specific and descriptive. Include any TypeScript/Node.js specific considerations in the body." > $temp_file

    set issue_title (head -n 1 $temp_file)
    set issue_body (tail -n +3 $temp_file)

    if test -z "$issue_title"
        set issue_title "$main_goal"
    end

    echo "Creating issue with title: $issue_title"
    gh issue create --title "$issue_title" --body "$issue_body"

    rm $temp_file
    echo "Issue created successfully!"
end

# ============================================================================
# INITIALIZATION
# ============================================================================

# Initialize tools if they exist
if command -q fnm
    fnm env | source
end

if command -q zoxide
    zoxide init fish | source
end

if command -q op
    op completion fish | source
end

# Bun completions - generate with: bun completions fish > ~/.config/fish/completions/bun.fish
# The default ~/.bun/_bun file is bash/zsh only and incompatible with fish

# fzf integration
if test -f ~/.config/fish/functions/fzf_key_bindings.fish
    source ~/.config/fish/functions/fzf_key_bindings.fish
end

# ============================================================================
# PROMPT CONFIGURATION
# ============================================================================

# Fish has built-in git integration and a nice default prompt
# You can customize it further or install a theme like tide, pure, or bobthefish

# To install a theme like tide (recommended):
# fisher install IlanCosman/tide@v5

# ============================================================================
# COMPLETIONS
# ============================================================================

# Fish auto-generates completions, but you can add custom ones here if needed
