# The following lines were added by compinstall

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'

zmodload zsh/datetime
setopt share_history
setopt APPEND_HISTORY

autoload zmv
autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
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
alias fn='find . -iname'
alias ll='ls -l'

# Quick change directories
# typing a directory name or variable that expands to one is sufficient to change directories
setopt AUTOCD
alias -- -="cd -" # the -- signifies that the variable will start with a -, so `-` will invoke `cd -`

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
alias -g NV='--no-verify'

# Spelling corrections for common commands
alias dc='cd'
alias pw='pwd'
alias pdw='pwd'
alias grpe='grep'

alias -g NE="2> /dev/null"

export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;29'

#####
# COMMAND SHORTCUTS
#####

# Rails
alias rials="rails"
alias rdm="rake db:migrate"
alias rdr="rake db:rollback"
alias rdd="rake db:drop"
alias rdc="rake db:create"
alias rdsl="rake db:schema:load"
alias rds="rake db:seed"
alias rdtp="rake db:test:prepare"
alias rg="rails g"
alias rgm="rails g migration"
alias rc="rails c"
alias rs="rails s"
alias rkae="rake"

# gem
alias sgi="sudo gem install"
alias sgu="sudo gem update"
alias gi="gem install"

alias cuc="cucumber"

# RSpec
alias rsm="rake spec:models"
alias rsc="rake spec:controllers"
alias rsv="rake spec:views"
alias rsh="rake spec:helpers"

# Heroku
alias hrdm="heroku rake db:migrate"
alias hero="heroku"
alias her="heroku"

# zsh shorcuts
alias reload="source ~/.zshrc"
alias reload!="source ~/.zshrc"

# git shortcuts
alias gs="git status"
alias gco="git checkout"
alias gc="git commit"
alias gcom="git commit"
alias gcomm="git commit -m"
alias gf="git fetch"
alias gb="git branch"
alias gba="git branch -a"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"
alias glh="gl -10"
alias gmt="git mergetool"
alias grc="git rebase --continue"
alias gwtf="git wtf -A"
alias gwtff="git fetch && git wtf -A"
alias gfwtf="git fetch && git wtf -A"
alias gd="git diff"
alias gdc="git diff --cached"
alias gdw="git diff --word-diff"
alias gpr="git pull --rebase"

alias py="python"

alias san="curl https://github.com/fastestforward/heroku_san/raw/master/README.rdoc | less"
alias pre="pretty"

alias ant='color-ant'
alias mvn='color-mvn'

PATH+=":"$CONF/common/bin

# load up rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

# seems to conflict with rvm?
#cat () {
#  if [ -d $1 ]; then
#    ls $1
#  else
#    echo "echoing $*"
#    CAT = "/bin/cat"
#    $CAT "$*"
#  fi
#}

# print stderr in red. see http://en.gentoo-wiki.com/wiki/Zsh#Colorize_STDERR
#exec 2>>(while read line; do
  #print '\e[91m'${(q)line}'\e[0m' > /dev/tty; print -n $'\0'; done &)
