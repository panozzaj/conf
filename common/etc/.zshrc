# The following lines were added by compinstall

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'

zmodload zsh/datetime
setopt share_history
setopt APPEND_HISTORY

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

EDITOR="gvim"

export PS1="$(print '%{\e[1;35m%}%S%c%s%{\e[0m%}')> "
alias ls='ls -abhX --color=auto'
export LS_COLORS='di=01;33'

#####
# KEYBINDINGS
#####
        
export WORDCHARS='*?_[]~=&;!#$%^(){}'

# Set up home and end keys
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
case $TERM in (xterm*)
	bindkey '\e[H' beginning-of-line
	bindkey '\e[F' end-of-line ;;
esac

# Configure delete key
bindkey "\e[3~" delete-char

#####
# General utility and correction
#####

### Some general shortcuts
alias fn='find . -name'
alias ll='ls -l'

alias -- -="cd -" # the -- signifies that the variable will start with a -, so `-` will invoke `cd -`

alias .="cd .."
# Quick change directories
function rationalize-dot {
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N rationalize-dot
bindkey . rationalize-dot

alias -g L='| less'

# Spelling corrections for common commands
alias dc='cd'
alias sl='ls -aAbhX --color=auto'
alias pw='pwd'
alias pdw='pwd'
alias grpe='grep'

export GREP_OPTIONS='--color=auto' GREP_COLOR='1;29'

#####
# COMMAND SHORTCUTS
#####

# Rails
alias rdd="rake db:drop"
alias rdm="rake db:migrate"
alias rdtp="rake db:test:prepare"
alias rmig="./script/generate migration"
alias rkae="rake"

alias cuc="cucumber"

# RSpec
alias rs="rake spec"
alias rsm="rake spec:models"
alias rsc="rake spec:controllers"
alias rsv="rake spec:views"
alias rsh="rake spec:helpers"

# Heroku
alias hrdm="heroku rake db:migrate"
alias hero="heroku"

# zsh shorcuts
alias reload="source ~/.zshrc"

# git shortcuts
alias gs="git status"
alias gco="git checkout"
alias gb="git branch"
alias gd="git diff"
alias gl="git log --pretty=oneline --graph"
alias glh="gl | head"
alias gmt="git mergetool"
alias gitpretend="git add -n ."
alias grc="git rebase --continue"

alias py="python"
