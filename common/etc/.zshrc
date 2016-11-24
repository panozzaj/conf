# load ability to do completions
autoload -Uz compinit && compinit
zmodload zsh/complist

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zmodload zsh/datetime
setopt share_history
setopt APPEND_HISTORY

# enable certain git suffixes, at the cost of some glob functionality
# see http://stackoverflow.com/questions/6091827
setopt NO_EXTENDED_GLOB

if [[ ! "$fpath" =~ "$conf/common/etc/.zsh" ]]; then
  fpath=($conf/common/etc/.zsh $fpath)
fi

zstyle ':completion:*:*:git:*' script $conf/common/bin/git-completion.bash

# from `brew info zsh` install instructions
[[ -e $(alias run-help) ]] && unalias run-help
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

# usually overridden in host-specific .zshrc
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

# single quotes to evaluate each time the prompt is refreshed
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

# NOTE: `r` by default is a command to redo the last command.  If I change the
# rspec functionality here, uncomment the other alias. Otherwise I may delete
# files unintentionally, etc.
#alias r='echo "Neutered r command"'
alias r='best_rspec'

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
#export LESSOPEN="| ~/conf/common/bin/lessopen %s"
# AP: not needed in newer less programs

alias -g L='| less'
alias -g GV='grep -v'

# Spelling corrections for common commands
alias dc='cd'
alias pw='pwd'
alias pdw='pwd'
alias grpe='grep'

# magic power for mkdir (and less typing)
alias mp="mkdir -p"

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

alias rubycop="rubocop"
alias rubocopy="rubocop"

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
  # `-b 0.0.0.0` helps with subdomains in pow
  if [[ -d script && -f script/server ]]; then
    ./script/server -b 0.0.0.0 $@
  else
    rails s -b 0.0.0.0 $@
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

function parallel_failures() {
  cat tmp/spec_summary.log | \
    # remove colors from output
    # see http://www.commandlinefu.com/commands/view/3584
    gsed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | \
    grep -e '^rspec'
}

function respec_parallel_failures() {
  parallel_failures | cut -d ' ' -f 2 | sort | xargs best_rspec
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

# helpful: https://git-scm.com/docs/git-status#_output
# needs to handle
# R  spec/1_spec.rb -> features/2_spec.rb
function modified_files() {
  git status --porcelain | \
    grep -v -e '^[ ]*D' | \
    awk 'match($1, ""){print $2}' | \
    sort | \
    uniq
}

function ged() {
  modified_files | xargs $EDITOR
}

function grubocop() {
  modified_files | grep -e '\.rb$' | xargs rubocop
}
alias grubo=grubocop

# get the files that are in the paste buffer from a normal git output
function gpaste() {
  pbpaste | sed -e 's/[[:space:]]*//g' | cut -d ':' -f 2
}

# roughly: run any cucumber files that we have changed since the last commit
function gcuc() {
  modified_files | \
    grep features/ | \
    grep -v features/support/ | \
    xargs cucumber
}

# roughly: run any specs that we have changed since the last commit
function gspec() {
  modified_files | \
    grep spec/ | \
    grep -v spec/spec_helper.rb | \
    grep -v spec/factories | \
    grep -v spec/fixtures/ | \
    grep -v spec/support/ | \
    xargs best_rspec
}

# returns the list of filenames from rspec output format
function rspec_paste() {
  pbpaste | cut -d ' ' -f 2 | sort
}

# copy the rspec failures, and this will rerun them as one command
function respec() {
  rspec_paste | xargs best_rspec
}

# copy the rspec failures, and this will edit the files that had failures
function espec() {
  rspec_paste | \
    cut -d ':' -f 1 | \
    uniq | \
    xargs $EDITOR
}

# Pow
alias psr="powify server stop; powify server start"

# Heroku
alias hrdm="heroku run rake db:migrate"
alias hero="heroku"
alias her="heroku"
alias fs="foreman start"

# zsh shorcuts
alias reload="source ~/.zshrc"
alias reload!="source ~/.zshrc"

# zshrc editing shortcuts
alias zshrc="$EDITOR ~/conf/common/etc/.zshrc"
alias zsrhc="$EDITOR ~/conf/common/etc/.zshrc"
alias zshrcp="$EDITOR ~/conf/platform/$PLATFORM/etc/.zshrc"
alias zshrch="$EDITOR ~/conf/hosts/$HOST/etc/.zshrc"
alias zshrcl="$EDITOR ~/conf/hosts/$HOST/etc/.zshrc" # local
alias zshrci="$EDITOR ~/conf/init/etc/.zshrc"

alias g="git"
alias ga="git add --all"
alias gaa="git add --all"
alias gai="git add --interactive"
alias gaia="git add --intent-to-add"
alias gam="git amend"
alias gamn="git amend -n"
alias gamend="git amend"
alias ganc="git amend-nc"
alias gancn="git amend-nc -n"
alias gap="git add --patch"
alias gb-="git checkout -"
alias gb="git branch"
alias gba="git branch --all"
alias gbb="git bisect bad"
alias gbg="git bisect good"
alias gbr="git branch --remote"
alias gc="git commit --verbose"
alias gcle="git cleanup"
alias gco="git checkout"
alias gco-="git checkout -"
alias gcob="git checkout -b"
alias gcop="git checkout --patch"
alias gcom="git checkout master"
alias gcomm="git commit --message"
alias gcn="git commit -n"
alias gcw="git commit -m 'Whitespace'"
alias gcm="git commit --message"
alias gcp="git cherry-pick"
alias gcpc="git cherry-pick --continue"
alias gcpi="git cherry-pick \`git reflog | fzf | cut -d ' ' -f 1\`"
alias gd="git diff"
alias gdc="git diff --cached"
alias gdcw="git diff --cached --ignore-all-space"
alias gdom="git diff origin/master"
alias gds="git diff --stat" # all files that changed since revision
alias gdsom="git diff --stat origin/master"
alias gdw="git diff --ignore-all-space"
alias geu="git edit-unmerged"
alias gf="git fetch"
alias gfmom="echo 'git fetch' && git fetch && echo 'git merge origin/master --ff-only'; git merge origin/master --ff-only"
alias gfrom="echo 'git fetch' && git fetch && echo 'git rebase origin/master' && git rebase origin/master"
alias gfwtf="git fetch && git wtf -A"
alias gl="git log --oneline --graph --decorate"
alias glh="gl -10"
alias glp="git log --patch"
alias glpw="git log --patch --ignore-all-space"
alias gmom="echo 'git merge origin/master --ff-only'; git merge origin/master --ff-only"
alias gmt="git mergetool"
alias gp="git push"
alias gpop="git pop"
alias gpr="git pull --rebase"
alias gpup="git pup"
alias grc="git rebase --continue"
alias gri="git rebase --interactive"
alias griom="git rebase --interactive origin/master"
alias grlh="git reflog | head"
alias grom="git rebase origin/master"
alias grr="git reset --hard \`git reflog | fzf | cut -d ' ' -f 1\`"
alias grs="git rebase --skip"
alias grsh="git reset --soft 'HEAD^' && git reset"
alias gs="git status"
alias gshow="git show"
alias gski="git stash --keep-index"
alias gss="git show --stat"
alias gssp="git stash show --patch"
alias gstash="git stash"
alias gsup="git sup"
alias gwip="git add -A . ; git commit -nm 'WIP'"
alias gwtf="git wtf -A"
alias gwtff="git fetch && git wtf -A"

alias fixup="git commit -nm 'FIXUP ME'"
alias squash="git commit -nm 'SQUASH ME'"

function hpr {
    # by default, makes pull request from feature branch to master
    # example: hpr -> PR feature-branch onto master
    if [[ $@ == "" ]]; then
      echo "hub pull-request"
      export GIT_EDITOR='mvim --nofork'
      url=$(hub pull-request)
      # TODO: hub pull-request actually takes -o argument to open in browser
      if [[ "$url" != "" ]]; then
        open "$url"
        echo "Pull request created at $url"
      fi
    else
      # TODO: update to match above function more closely to open PR, etc.
      # otherwise, makes pull request from feature branch to branch
      # example: hpr foo -> PR feature-branch onto foo
      # repo is hardcoded, would be nice to generalize
      repo=joinhaven
      echo "hub pull-request -b $repo:$1 -h $repo:`git symbolic-ref --short HEAD`"
      `GIT_EDITOR='mvim --nofork' hub pull-request -b $repo:$1 -h $repo:\`git symbolic-ref --short HEAD\``
    fi
}

# grunt
alias gr="grunt"
alias grj="grunt jshint"
alias grja="grunt jshint"
alias grjn="grunt newer:jshint"
alias grjw="grunt watch:jshintNewer"
alias grmo="grunt mobileapp"
alias grmoa="grunt mobileapp --backend=localhost:3000"
alias grmot="grunt mobileapp --backend=http://localhost:9559"
alias grup="grunt updatedefs"

# grunt testing
alias grt="grunt test"
alias grta="grunt test:appium"
alias grtaf="grunt test:appium:full"
alias grtk="grunt test:karma"
alias grtm="grunt test:mocha"
alias grtmg="grunt test:mocha --grep"
alias grtml="grunt test:mocha:local"
alias grtmn="grunt test:mocha --grep @network"
alias grtp="grunt test:protractor"

# cordova
alias cemui="pushd cordova ; cordova emulate ios ; popd"
alias cemua="pushd cordova ; cordova emulate android ; popd"
alias cruna="pushd cordova ; cordova run android ; popd"
alias cruni="pushd cordova ; cordova run ios ; popd"
alias ccemui="grunt mobileapp --backend=localhost:3000 && cemui"
alias ccemua="grunt mobileapp --backend=10.0.2.2:3000 && cemua"
alias ccruni="grunt mobileapp --backend=http://anthony-panozzo.local:3000 && cruni"
alias ccruna="grunt mobileapp --backend=localhost:3000 && cruna"

# npm
alias ni="npm install"
alias nis="npm install --save"
alias nisd="npm install --save-dev"
alias nr="npm run"
alias nrs="npm start" # npm run start
alias nrt="npm run test"
alias ns="npm start"

# javascript
#alias jsl="jslint -process"

# vagrant
alias va="vagrant"
alias vap="vagrant provision"

# vim shortcuts
alias vimrc="$EDITOR ~/conf/common/etc/.vimrc"
vim="$conf/common/.vim"

alias py="python"

alias tf="tail -f"
alias tfld="tail -f log/development.log"
alias tflt="tail -f log/test.log"

alias pre="pretty"

#alias ant='color-ant'
alias mvn='color-mvn'

alias week='date "+%V"'

alias wcl='wc -l'

alias -g pxargs="xargs -n 1"

# silver searcher - use less with color support for j/k support
alias ag="ag -i --pager 'less -R' --color-match='1;31'"
alias agc='ag -C5'
alias agl='ag -l'
alias lag='ag -l'

# might be better platform independent, but YAGNI right now
alias xe="xargs mvim"

# print STDERR in red
alias -g errred='2> >(while read line; do echo -e "\e[01;31m$line\e[0m" >&2; done)'

if [[ ! "$PATH" =~ "$CONF/common/bin" ]]; then
  PATH+=":"$CONF/common/bin
fi

if [[ ! "$PATH" =~ "/usr/local/sbin" ]]; then
  PATH+=":/usr/local/sbin"
fi

# Calculate writing word diff between revisions. Cribbed / modified from:
# http://stackoverflow.com/questions/2874318/quantifying-the-amount-of-change-in-a-git-diff
function git_words_added {
  revision=${1:-origin/master}
  git diff --word-diff=porcelain $revision | \
    grep -e "^+[^+]" | \
    wc -w | \
    xargs
}

function git_words_removed {
  revision=${1:-origin/master}
  git diff --word-diff=porcelain $revision | \
    grep -e "^-[^-]" | \
    wc -w | \
    xargs
}

function git_words_diff {
  revision=${1:-origin/master}
  echo $(($(git_words_added $1) - $(git_words_removed $1)))
}

# some Ruby compiler optimizations
# see http://stackoverflow.com/questions/4461346/slow-rails-stack
# TODO: pretty old.. not sure if this is actually useful nowadays
#export RUBY_HEAP_FREE_MIN=100000
#export RUBY_HEAP_SLOTS_INCREMENT=300000
#export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
#export RUBY_GC_MALLOC_LIMIT=90000000

# Add the following to your ~/.bashrc or ~/.zshrc
#
# Alternatively, copy/symlink this file and source in your shell.  See `hitch --setup-path`.

hitch() {
  command hitch "$@"
  if [[ -s "$HOME/.hitch_export_authors" ]] ; then source "$HOME/.hitch_export_authors" ; fi
}
alias unhitch='hitch -u'

if [[ ! "$PATH" =~ "/usr/local/opt/go/libexec/bin" ]]; then
  export PATH=$PATH:/usr/local/opt/go/libexec/bin
fi

if [[ ! "$GOPATH" =~ "$HOME/go" ]]; then
  export GOPATH=$PATH:$HOME/go
fi

if [[ ! "$PATH" =~ "$GOPATH/bin" ]]; then
  export PATH=$PATH:$GOPATH/bin
fi

if [[ ! "$PATH" =~ "\\./client/node_modules/\\.bin" ]]; then
  export PATH=$PATH:./client/node_modules/.bin
fi

if [[ ! "$PATH" =~ "\\./node_modules/\\.bin" ]]; then
  export PATH=$PATH:./node_modules/.bin
fi

alias news="newsbeuter -C ~/Dropbox/newsbeuter/config -u ~/Dropbox/newsbeuter/urls"
function add_feed {
    echo "$1" >> ~/Dropbox/newsbeuter/urls
}
function add_rss {
    echo "$1" >> ~/Dropbox/newsbeuter/urls
}

function install_jsctags {
  npm install jsctags
  # https://github.com/mozilla/doctorjs/issues/52
  gsed -i '51i tags: [],' ./node_modules/jsctags/jsctags/ctags/index.js
}

# http://stackoverflow.com/questions/2187829/constantly-updated-clock-in-zsh-prompt
#TMOUT=5 # every five seconds, reset the prompt so the clock is refreshed
#
#TRAPALRM() {
#    zle reset-prompt
#}
