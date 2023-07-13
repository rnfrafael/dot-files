if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="/home/rnfrafael/.mscripts:$PATH"
export PATH="/mnt/c/Users/rnfra/AppData/Local/Programs/Microsoft VS Code/bin:$PATH"

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.zsh/zsh-you-should-use/zsh-you-should-use.plugin.zsh

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

alias iplugin="cd ~/.zsh/"
alias zshc="code ~/.zshrc"
alias winwww="cd /mnt/c/www"
alias windownload="cd /mnt/c/users/rnfra/Downloads"
alias workl="cd /home/rnfrafael/www/workana"

alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/mnt/c)
# fnm
export PATH="/home/rnfrafael/.local/share/fnm:$PATH"
eval "`fnm env`"
eval "$(op completion zsh)"; compdef _op op

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zshsource ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
