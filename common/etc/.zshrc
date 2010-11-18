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

PS1="$(print '%{\e[1;35m%}%S%c%s%{\e[0m%}')> "
LS_COLORS='di=01;33'

#####
# KEYBINDINGS
#####
        
WORDCHARS='*?_[]~=&;!#$%^(){}'

# Configure delete key
bindkey "\e[3~" delete-char

#####
# General utility and correction
#####

### Some general shortcuts
alias fn='find . -name'
alias ll='ls -l'

# Quick change directories
# typing a directory name or variable that expands to one is sufficient to change directories
setopt AUTOCD
alias -- -="cd -" # the -- signifies that the variable will start with a -, so `-` will invoke `cd -`
alias .="cd .."

# when you are typing and you have more than two dots in a row, converts the third dot to /.. on the fly
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
alias pw='pwd'
alias pdw='pwd'
alias grpe='grep'

alias -g NE="2> /dev/null"

GREP_OPTIONS='--color=auto' GREP_COLOR='1;29'

#####
# COMMAND SHORTCUTS
#####

# Rails
alias rdd="rake db:drop"
alias rdm="rake db:migrate"
alias rdtp="rake db:test:prepare"
alias rg="rails generate"
alias rgm="rails generate migration"
alias rc="rails console"
alias rkae="rake"

# gem
alias sgi="sudo gem install"
alias sgu="sudo gem update"
alias gi="gem install"

alias cuc="cucumber"

# RSpec
alias rs="rake spec"
alias rsm="rake spec:models"
alias rsc="rake spec:controllers"
alias rsv="rake spec:views"
alias rsh="rake spec:helpers"

# bundler
alias bi="bundle install"

# Heroku
alias hrdm="heroku rake db:migrate"
alias hero="heroku"
alias her="heroku"

# zsh shorcuts
alias reload="source ~/.zshrc"

# git shortcuts
alias gs="git status"
alias gco="git checkout"
alias gc="git commit -t ~/ticket"
alias gb="git branch"
alias gba="git branch -a"
alias gd="git diff"
alias gl="git log --pretty=oneline --graph"
alias glh="gl | head"
alias gmt="git mergetool"
alias gitpretend="git add -n ."
alias grc="git rebase --continue"
alias gwtf="git wtf"

# .zshrc and .vimrc quick edit
alias zshrcs="~/zshrcs"
alias vimrcs="~/vimrcs"

alias py="python"

PATH+=":"$CONF/common/bin

# load up rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

