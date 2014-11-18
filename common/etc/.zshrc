# TODO: understand what this is and if we need it or not.
# For some reason this is clobbering my git filename completion
# with latest homebrew install of git and zsh (2014-09-10)
#zmodload zsh/complist
#autoload -Uz compinit && compinit

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zmodload zsh/datetime
setopt share_history
setopt APPEND_HISTORY

# from `brew info zsh` install instructions
unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/help

# get popup help for git commands
autoload run-help-git

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

# otherwise I may delete files unintentionally, etc.
alias r='echo "Neutered r command"'

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

# when you are typing and you have more than two dots in a row, converts the
# third dot to /.. on the fly
# AP: I don't really use this any more and it messes things up just often
# enough to make me not like it
#function rationalize-dot {
#    if [[ $LBUFFER = *.. ]]; then
#        LBUFFER+=/..
#    else
#        LBUFFER+=.
#    fi
#}
#zle -N rationalize-dot
#bindkey . rationalize-dot

# -I = case insensitive search
# -R = display raw characters (git diff colored output, etc.)
# -F = don't use pager if only one screen worth of content (no unnecessary 'q')
# -X = no need to clear screen when less invoked
# -W = temporarily highlights the first new line after
#      any forward movement command larger than one line.
export LESS='-R -F -W -X -I'

# make less a directory do an `ls` instead of giving error
# also expands archive files
# see http://unix.stackexchange.com/questions/107563
# and http://www.freebsd.org/cgi/man.cgi?query=less&sektion=1#INPUT_PREPROCESSOR
export LESSOPEN="| ~/conf/common/bin/lessopen %s"

alias -g L='| less'
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
alias bil="bundle install --local"
alias bu="bundle update"
alias bul="bundle update --local"

alias prs="parallel_rspec spec"
alias pcf="parallel_cucumber features"

# TODO: explain rake commands with echoes when they are running
#function verbose_alias() {
#  a=$(shift $1)
#  alias $a="$@"
#}
#verbose_alias "fooey" "echo 'test'" ; fooey

# Rake
alias ®="rake "
alias rkae="rake"
alias rdc="rake db:create"
alias rdd="rake db:drop"
alias rdm="rake db:migrate"
alias rdmall="rdm && rdtp && rpp"
alias rdmtp="rdm && rdtp"
alias rdpt="rake db:test:prepare"
alias rdr="rake db:rollback"
alias rds="rake db:seed"
alias rdsl="rake db:schema:load"
alias rdtp="rake db:test:prepare"
alias rdv="rake db:version"
alias rjw="rake jobs:work"
alias rpp="rake parallel:prepare"

# Spring
alias br="bin/rspec"

# Zeus (https://github.com/burke/zeus)
alias z="zeus"
alias zc="time zeus cucumber"
alias zt="time zeus test"
alias zs="zeus start"

# Zeus + Rake
alias zr="zeus rake"
alias zpc="time zeus parallel_cucumber"
alias zpr="time zeus parallel_rspec"
alias zrdc="zr db:create"
alias zrdd="zr db:drop"
alias zrdm="zr db:migrate"
alias zrdmall="zrdm && zrdtp && zrpp"
alias zrdmtp="zrdm && zrdtp"
alias zrdpt="zr db:test:prepare"
alias zrdr="zr db:rollback"
alias zrdtp="zr db:test:prepare"
alias zrds="zr db:seed"
alias zrdsl="zr db:schema:load"
alias zrpp="zr parallel:prepare"

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
alias gu="gem uninstall"

alias cuc="cucumber"
alias -g PIPE="|"
function gcuc() {
  # needs to handle
  # R  features/1.feature -> features/2.feature
  git status --porcelain | grep -v -e '^ D' | grep -v -e '^D' | awk 'match($1, ""){print $2}' | grep features/ | xargs cucumber
}

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
function ggrep() {
  git grep $1 $(git rev-list --all)
}
alias g="git"
alias gaa="git add --all ."
alias gai="git add --interactive"
alias gaia="git add --intent-to-add"
alias gam="git amend"
alias gamend="git amend"
alias ganc="git amend-nc"
alias gap="git add --patch"
alias gb-="git checkout -"
alias gb="git branch"
alias gba="git branch --all"
alias gbb="git bisect bad"
alias gbg="git bisect good"
alias gc="git commit"
alias gco-="git checkout -"
alias gco="git checkout"
alias gcom="git commit"
alias gcomm="git commit --message"
alias gcp="git cherry-pick"
alias gcpc="git cherry-pick --continue"
alias gd="git diff"
alias gdc="git diff --cached"
alias gdcw="git diff --cached --ignore-all-space"
alias gdw="git diff --ignore-all-space"
alias geu="git edit-unmerged"
alias gf="git fetch"
alias gfwtf="git fetch && git wtf -A"
alias gl="git log --oneline --graph --decorate"
alias glh="gl -10"
alias glp="git log --patch"
alias glpw="git log --patch --ignore-all-space"
alias gmom="echo 'git merge origin/master --ff-only'; git merge origin/master --ff-only"
alias gmt="git mergetool"
alias gp="git push"
alias gpop="git pop"
alias gpup="git pup"
alias gpr="git pull --rebase"
alias grc="git rebase --continue"
alias gri="git rebase --interactive"
alias grlh="git reflog | head"
alias grs="git rebase --skip"
alias grsh="git reset --soft 'HEAD^'"
alias gs="git status"
alias gss="git show --stat"
alias gski="git stash --keep-index"
alias gstash="git stash"
alias gsup="git sup"
alias gwtf="git wtf -A"
alias gwtff="git fetch && git wtf -A"
alias hpr="hub pull-request"

# grunt
alias gr="grunt"
alias grj="grunt jshint"
alias grjm="grunt jshint test:mocha"
alias grje="grunt jshint test:e2e"
alias grm="grunt test:mocha"

# npm
alias ni="npm install"

# javascript
alias jsl="jslint -process"

# vagrant
alias va="vagrant"
alias vag="vagrant"

# vim shortcuts
alias vimrc="$EDITOR ~/conf/common/etc/.vimrc"

alias py="python"

alias tf="tail -f"
alias tfld="tail -f log/development.log"
alias tflt="tail -f log/test.log"

alias pre="pretty"

alias ant='color-ant'
alias mvn='color-mvn'

alias -g pxargs="xargs -n 1"

# silver searcher - use less with color support for j/k support
alias ag='ag -i --pager "less -R"'

# might be better platform independent, but YAGNI right now
alias xe="xargs mvim"

# print STDERR in red
alias -g errred='2> >(while read line; do echo -e "\e[01;31m$line\e[0m" >&2; done)'

PATH+=":"$CONF/common/bin

# load up rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

export NVM_DIR="/Users/anthonypanozzo/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# some Ruby compiler optimizations
# see http://stackoverflow.com/questions/4461346/slow-rails-stack
# TODO: pretty old.. not sure if this is actually useful nowadays
export RUBY_HEAP_FREE_MIN=100000
export RUBY_HEAP_SLOTS_INCREMENT=300000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=90000000

# Add the following to your ~/.bashrc or ~/.zshrc
#
# Alternatively, copy/symlink this file and source in your shell.  See `hitch --setup-path`.

hitch() {
  command hitch "$@"
  if [[ -s "$HOME/.hitch_export_authors" ]] ; then source "$HOME/.hitch_export_authors" ; fi
}
alias unhitch='hitch -u'
