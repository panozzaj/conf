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
HISTSIZE=500000
SAVEHIST=500000
bindkey -e
# End of lines configured by zsh-newuser-install

PS1="$(print '%{\e[1;35m%}%S[%T] %c%s%{\e[0m%}')> "
LS_COLORS='di=01;33'

setopt HIST_IGNORE_SPACE # don't add to ZSH history file any lines that start with a space
setopt interactivecomments # ignore everything after pound signs in interactive prompt (comments)

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
fn () {
    if [ $# -eq 0 ]; then
        echo 'Usage: fn search_string [within_directory]'
    elif [ $# -eq 1 ]; then
        find . | grep -i $1
    elif [ $# -eq 2 ]; then
        find $2 | grep -i $1
    elif [ $# -gt 2 ]; then
        echo 'Usage: fn search_string [within_directory]'
    fi
}
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

export LESS='-R -F -W -X'
alias -g L='| less'
alias -g NV='--no-verify'
alias -g GV='grep -v'

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

# Ruby
alias be="bundle exec"
alias beg="bundle exec guard"
alias bi="bundle install"
alias rkae="rake"
alias ®="rake"

# Rake
alias rdm="rake db:migrate"
alias rdr="rake db:rollback"
alias rdd="rake db:drop"
alias rdc="rake db:create"
alias rdmtp="rdm && rdtp"
alias rdsl="rake db:schema:load"
alias rds="rake db:seed"
alias rdtp="rake db:test:prepare"
alias rjw="rake jobs:work"

# Rails
alias rials="rails"
alias rg="rails g"
alias rgm="rails g migration"
alias rc="rails c"
alias rs="rails s"
alias rsp="rails s -p"
alias reload_database='powify server stop && rdd && rdc && rdm && rds && rdtp && powify server start'

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
alias fs="foreman start"

# zsh shorcuts
alias reload="source ~/.zshrc"
alias reload!="source ~/.zshrc"
alias zshrc="$EDITOR ~/conf/common/etc/.zshrc"

# git shortcuts
alias g="git"
alias ganc="git amend-nc"
alias gap="git add -p"
alias gb="git branch"
alias gba="git branch -a"
alias gbb="git bisect bad"
alias gbg="git bisect good"
alias gc="git commit"
alias gca="git amend-nc"
alias gco="git checkout"
alias gcom="git commit"
alias gcomm="git commit -m"
alias gcomma="git commit -m 'Add"
alias gcommf="git commit -m 'Fix"
alias gcommr="git commit -m 'Remove"
alias gd="git diff"
alias gdc="git diff --cached"
alias gdw="git diff --word-diff"
alias gf="git fetch"
alias gfwtf="git fetch && git wtf -A"
alias gl="git log --oneline --graph --decorate"
alias glh="gl -10"
alias gmt="git mergetool"
alias gp="git push"
alias gpop="git pop"
alias gpr="git pull --rebase"
alias grc="git rebase --continue"
alias gs="git status"
alias gwtf="git wtf -A"
alias gwtff="git fetch && git wtf -A"

# vim shortcuts
alias vimrc="$EDITOR ~/conf/common/etc/.vimrc"

alias py="python"

alias san="curl https://raw.github.com/fastestforward/heroku_san/master/README.md | less"
alias pre="pretty"

alias ant='color-ant'
alias mvn='color-mvn'

# from http://gilesbowkett.blogspot.com/2010/11/productivity-boosting-shell-script.html
# search Gmail THIS WAY, not by going to the Inbox
search_gmail() {
  open "http://mail.google.com/mail/#search/$*"
}

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

#eval "$(hub alias -s)"

# some Ruby compiler optimizations
# see http://stackoverflow.com/questions/4461346/slow-rails-stack
export RUBY_HEAP_MIN_SLOTS=800000
export RUBY_HEAP_FREE_MIN=100000
export RUBY_HEAP_SLOTS_INCREMENT=300000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=79000000

