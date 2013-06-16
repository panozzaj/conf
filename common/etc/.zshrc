# The following lines were added by compinstall
zmodload zsh/complist
autoload -Uz compinit && compinit

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'

zmodload zsh/datetime
setopt share_history
setopt APPEND_HISTORY

autoload -Uz run-help
autoload -Uz run-help-git

export HELPDIR=~/zsh_help

# End of lines added by compinstall

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
bindkey -e
# End of lines configured by zsh-newuser-install

PROMPT="%F{red}%S[%T] %c%f%s ◊ "
LS_COLORS='di=01;33'

setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr 'M'
zstyle ':vcs_info:*' unstagedstr 'M'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}[%F{2}%b%F{5}] %F{2}%c%F{3}%u%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' enable git
+vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
    git status --porcelain | grep '??' &> /dev/null ; then
    hook_com[unstaged]+='%F{1}??%f'
  fi
}
precmd () { vcs_info }
RPROMPT='${vcs_info_msg_0_}'

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
    elif [ $# -ge 2 ]; then
        find ${@[@]:2} | grep -i $@[1]
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

function run_times() {
    number=$1
    shift
    for i in `seq $number`; do
      echo "Run #${number}"
      $@
    done
}

#####
# COMMAND SHORTCUTS
#####

# Ruby
alias be="bundle exec"
alias beg="bundle exec guard"
alias bi="bundle install"
alias bil="bundle install --local"
alias bu="bundle update"
alias bul="bundle update --local"

# Rake
alias ®="rake "
alias rkae="rake"
alias rdm="rake db:migrate"
alias rdr="rake db:rollback"
alias rdd="rake db:drop"
alias rdc="rake db:create"
alias rdmtp="rdm && rdtp"
alias rdsl="rake db:schema:load"
alias rds="rake db:seed"
alias rdtp="rake db:test:prepare"
alias rdpt="rake db:test:prepare"
alias rdv="rake db:version"
alias rjw="rake jobs:work"

# Zeus (https://github.com/burke/zeus)
alias tzt="time zeus test"
alias z="zeus"
alias zc="zeus console"
alias zs="zeus server"
alias zt="zeus test"
alias zpc="zeus parallel_cucumber"
alias zpr="zeus parallel_rspec"
alias zstart="zeus start"
alias bezstart="bundle exec zeus start"

# Rails
alias rials="rails"
alias rg="rails g"
alias rgm="rails g migration"
function rs() { # so this works for Rails 2 through 4
  if [[ -d script && -f script/server ]]; then
    ./script/server $@
  else
    rails s $@
  fi
}
function rc() { # so this works for Rails 2 through 4
  if [[ -d script && -f script/console ]]; then
    ./script/console $@
  else
    rails c $@
  fi
}
alias rsp="rs -p"
function reload_database() {
  echo "Reloading development and test databases from scratch!"
  echo ''
  powify server stop 2> /dev/null
  echo "\nExecuting rake db:drop db:create db:migrate..."
  rake --trace db:drop db:create db:migrate
  echo '\nExecuting rake db:seed...'
  rake --trace db:seed
  echo '\nExecuting rake db:test:prepare...'
  rake --trace db:test:prepare
  echo ''
  powify server start
  echo "Finished reloading development and test databases from scratch!"
}
function reset_database() {
  reload_database
}

# gem
alias sgi="sudo gem install"
alias sgu="sudo gem update"
alias gi="gem install"

alias cuc="cucumber"
alias -g PIPE="|"
function gcuc() {
  # needs to handle
  # R  features/1.feature -> features/2.feature
  git status --porcelain | grep -v -e '^ D' | grep -v -e '^D' | awk 'match($1, ""){print $2}' | grep features/ | xargs cucumber
}

# RSpec
alias rsm="rake spec:models"
alias rsc="rake spec:controllers"
alias rsv="rake spec:views"
alias rsh="rake spec:helpers"

# Pow
alias psr="powify server restart"

# Heroku
alias hrdm="heroku run rake db:migrate"
alias hero="heroku"
alias her="heroku"
alias fs="foreman start"

# zsh shorcuts
alias reload="source ~/.zshrc"
alias reload!="source ~/.zshrc"
alias zshrc="$EDITOR ~/conf/common/etc/.zshrc"

# git shortcuts
alias g="git"
alias gaa="git add -A"
alias ganc="git amend-nc"
alias gap="git add -p"
alias gb="git branch"
alias gba="git branch -a"
alias gbb="git bisect bad"
alias gbg="git bisect good"
alias gb-="git checkout -"
alias gc="git commit"
alias gca="git amend-nc"
alias gco="git checkout"
alias gco-="git checkout -"
alias gcom="git commit"
alias gcomm="git commit -m"
alias gcomma="git commit -m 'Add"
alias gcommf="git commit -m 'Fix"
alias gcommr="git commit -m 'Remove"
alias gcpc="git cherry-pick --continue"
alias gd="git diff"
alias gdc="git diff --cached"
alias gdw="git diff --word-diff"
alias gf="git fetch"
alias gfwtf="git fetch && git wtf -A"
alias gl="git log --oneline --graph --decorate"
alias glh="gl -10"
alias glp="git log -p"
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

alias tf="tail -f"
alias tfld="tail -f log/development.log"
alias tflt="tail -f log/test.log"

alias pre="pretty"

alias ant='color-ant'
alias mvn='color-mvn'

PATH+=":"$CONF/common/bin

# load up rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

# some Ruby compiler optimizations
# see http://stackoverflow.com/questions/4461346/slow-rails-stack
export RUBY_HEAP_MIN_SLOTS=800000
export RUBY_HEAP_FREE_MIN=100000
export RUBY_HEAP_SLOTS_INCREMENT=300000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=79000000
