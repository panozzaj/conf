# load ability to do completions
autoload -Uz compinit && compinit
zmodload -i zsh/complist

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zmodload zsh/datetime
setopt share_history
setopt APPEND_HISTORY

# enable certain git suffixes, at the cost of some glob functionality
# see http://stackoverflow.com/questions/6091827
setopt NO_EXTENDED_GLOB

# Allow for brackets without quoting
# https://robots.thoughtbot.com/how-to-use-arguments-in-a-rake-task
# Not sure what the downsides are though.
unsetopt NOMATCH

if [[ ! "$fpath" =~ "$conf/common/etc/.zsh" ]]; then
  fpath=($conf/common/etc/.zsh $fpath)
fi

# See https://github.com/eddiezane/lunchy/issues/57
autoload bashcompinit
bashcompinit

# gives warning on zsh startup but appears to mostly work
# 2021-03-09 kind of still gives errors / warnings when trying tab-completion
#source /usr/local/etc/bash_completion.d/git-completion.bash 2> /dev/null

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
PROMPT="%F{cyan}%S[%T] %c%s%f ◊ "

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

# NOTE: `r` by default is a command to redo the last command.  If I change the
# rspec functionality here, uncomment the other alias. Otherwise I may delete
# files unintentionally, etc.
#alias r='echo "Nerfed r command"'
alias r='best_rspec'

alias t='./bin/test'

alias ll='ls -lah'

# Quick change directories
# typing a directory name or variable that expands to one is sufficient to change directories
setopt AUTOCD
alias -- -="cd -" # the -- signifies that the variable will start with a -, so `-` will invoke `cd -`
alias cd-="cd -"

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
function mpc() {
  mkdir -p "$1" && cd "$1"
}

# Idea: chmod changes the mod, but what is the mod?
# To query in human-readable terms, use this command.
# I believe this only works for OS X due to difference in stat command.
# http://askubuntu.com/questions/152001
alias mod="stat -f '%A %N'"

alias -g NE="2> /dev/null"

export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;29'

#####
# COMMAND SHORTCUTS
#####

# Ruby
alias be="bundle exec"
alias beg="bundle exec guard"
alias begc="bundle exec guard -c"
alias bi="bundle install -j8"
alias bu="bundle update"

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
alias ®="best_rake "
alias br="best_rake "
alias rkae="best_rake"
alias rdc="best_rake db:create"
alias rdd="best_rake db:drop"
alias rdm="best_rake db:migrate || best_rake db:migrate"
alias rdmall="rdm && rdtp && rpp"
alias rdmtp="rdm && rdtp"
alias rdpt="best_rake db:test:prepare"
alias rdr="best_rake db:rollback"
alias rds="best_rake db:setup"
alias rdseed="best_rake db:seed"
alias rdsl="best_rake db:schema:load"
alias rdtp="best_rake db:test:prepare"
alias rdv="best_rake db:version"
alias rjw="best_rake jobs:work"
alias rpp="best_rake parallel:prepare"

# Rails
alias rials="rails"
alias rdb="rails db"
alias rg="rails generate"
alias rgmo="rails generate model"
alias rgc="rails generate controller"
alias rr="rails runner"
alias tf="tail -f"
alias tfld="tail -f log/development.log"
alias tflt="tail -f log/test.log"

# so this works for Rails 2 through 5+
function rs() {
  # `-b 0.0.0.0` helps with subdomains in pow
  if [[ -d bin && -f bin/rails ]]; then
    echo ./bin/rails server -b 0.0.0.0 $@
    ./bin/rails server -b 0.0.0.0 $@
  elif [[ -d script && -f script/server ]]; then
    echo ./script/server -b 0.0.0.0 $@
    ./script/server -b 0.0.0.0 $@
  else
    echo ./script/server -b 0.0.0.0 $@
    rails s -b 0.0.0.0 $@
  fi
}

# so this works for Rails 2 through 5+
function rc() {
  if [[ -d bin && -f bin/rails ]]; then
    echo ./bin/rails console $@
    ./bin/rails console $@
  elif [[ -d script && -f script/console ]]; then
    echo ./script/console $@
    ./script/console $@
  else
    echo rails c $@
    rails c $@
  fi
}

alias rsp="rs -p"

function reload_database() {
  echo "Reloading development and test databases from scratch!"
  echo ''
  powify server stop 2> /dev/null
  echo "\nExecuting rake db:drop db:create db:migrate..."
  best_rake --trace db:drop db:create db:migrate
  echo '\nExecuting rake db:seed...'
  best_rake --trace db:seed
  echo '\nExecuting rake db:test:prepare...'
  best_rake --trace db:test:prepare
  echo ''
  powify server start
  echo "Finished reloading development and test databases from scratch!"
}

function parallel_failures() {
  cat tmp/parallel_tests/spec_summary.log | \
    # remove colors from output
    # see http://www.commandlinefu.com/commands/view/3584
    gsed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | \
    grep -e '^rspec'
}

function respec_parallel_failures() {
  parallel_failures | cut -d ' ' -f 2 | sort | xargs best_rspec
}
alias rpf='respec_parallel_failures'

function reset_database() {
  reload_database
}

function rgm() {
  rails generate migration $@
  echo ""
  catdm
}

# edit the last Rails database migration
function emig() {
  # https://stackoverflow.com/questions/246215 for ls command
  ls -d1 db/migrate/* | tail -1 | xargs $EDITOR
}

# cat the last Rails database migration
function cmig() {
  # https://stackoverflow.com/questions/246215 for ls command
  ls -d1 db/migrate/* | tail -1 | xargs cat
}

function catdm() {
  find db/migrate | sort -r | head -1 | xargs cat
}

alias cr="checkruby HEAD"

# gem
alias sgi="sudo gem install"
alias sgu="sudo gem update"
alias gi="gem install"
alias gu="gem uninstall"

alias cuc="cucumber"
alias -g PIPE="|"

# helpful: https://git-scm.com/docs/git-status#_output
# $NF: take last matching field. Handles renames:
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

# roughly: run any specs that we have changed on our feature branch
function gdomspec() {
  git diff origin/$(main_branch) --stat=200 | \
    cut -f 2 -d ' ' | \
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

# returns the unique list of filenames from rspec output format
function rspec_unique_paste() {
  rspec_paste | cut -d ':' -f 1 | sort -u
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

# it's the same format
alias cucumber_paste=rspec_paste

# rerun the cucumber failures in the paste buffer
function recuc() {
  cucumber_paste | xargs cucumber
}

# Pow
alias psr="powify server stop; powify server start"

# Heroku
alias hr="heroku run"
alias hrc="heroku run rails console"
alias hrdb="heroku pg:psql"
alias hrsql="heroku pg:psql"
alias hrdm="heroku run rake db:migrate"
alias hrr="echo heroku run rake '<your command>'; heroku run rake"
alias hrrr="echo heroku run rails runner '<your command>'; heroku run rails runner"
alias hero="heroku"
alias her="heroku"
alias hl="heroku logs"
alias hlt="heroku logs -t"
alias hcg="heroku config | grep -i"

alias fs="foreman start"

# zsh shorcuts
alias reload="source ~/.zshrc"
alias reload!="source ~/.zshrc"

# file editing shortcuts
alias gitconfig="$EDITOR ~/.gitconfig"
alias vimrc="$EDITOR ~/conf/common/etc/.vimrc"
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
alias gagem="git add Gemfile Gemfile.lock"
alias gagems="git add Gemfile Gemfile.lock"
alias gajs="git add package.json yarn.lock"
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
# committerdate sorts by the last commit, so the ones that we have most
# recently been working with will appear closer to the bottom of the list
# http://stackoverflow.com/questions/5188320
# mnemonic: git change branch
alias gcb="git checkout \`git branch --sort=-committerdate | fzf\`"
alias gcl="git clone"
alias gcdf="git clean -df"
alias gco="git checkout"
alias gco-="git checkout -"
alias gcob="git checkout -b"
alias gcobi="git checkout \`git branch --sort=-committerdate | fzf\`"
alias gcogem="git checkout Gemfile Gemfile.lock"
alias gcogems="git checkout Gemfile Gemfile.lock"
alias gcojs="git checkout package.json yarn.lock" # quickly revert JS package changes

# some older projects use master, so use this to simplify the transition
function main_branch() {
  # see https://stackoverflow.com/questions/68086082
  git branch --list main master | sed -r 's/^[* ] //' | head -n 1
}

alias gcop="git checkout --patch"
alias gcom='git checkout $(main_branch)'
alias gcomm="git commit --message"
alias gcn="git commit -n"
alias gca="git commit -m 'Alphabetize'"
alias gcf="git commit -m 'Formatting'"
alias gcw="git commit -m 'Whitespace'"
alias gcm="git commit --message"
alias gcp="git cherry-pick"
alias gcpc="git cherry-pick --continue"
alias gcpi="git cherry-pick \`git reflog | fzf | cut -d ' ' -f 1\`"
alias gcv="git cherry -v"
alias gd="git diff"
alias gdc="git diff --cached"
alias gdcw="git diff --cached --ignore-all-space"
alias gdom='git diff origin/$(main_branch)'
alias gdoms='git diff origin/$(main_branch) --stat=200' # all files that changed on this branch
alias gdomw='git diff origin/$(main_branch) --ignore-all-space'
alias gds="git diff --stat" # all files that changed since revision
alias gdsom='git diff --stat origin/$(main_branch)' # all files that changed on this branch
alias gdw="git diff --ignore-all-space"
alias gex="git extract"
alias gexh="git extract HEAD"
alias geu="git edit-unmerged"
alias gf="git fetch"
alias gff="git ff"
alias gfa="git fetch --all"
alias gfmom='echo "git fetch" && git fetch && echo "git merge origin/$(main_branch) --ff-only"; git merge origin/$(main_branch) --ff-only'
alias gfrom='echo "git fetch" && git fetch && echo "git rebase origin/$(main_branch)" && git rebase origin/$(main_branch)'
alias gfwtf="git fetch && git wtf -A"
alias gl1="gl -1"
alias gl="git log --oneline --graph --decorate"
alias glh="gl -10"
alias glh1="glh -1"
alias glp="git log --patch --decorate"
alias glpw="glp --ignore-all-space"
alias glom='gl origin/$(main_branch)^..HEAD'
alias gls="git log --stat --decorate"
alias gnoff="git merge --no-ff"
alias gmom='echo "git merge origin/$(main_branch) --ff-only"; git merge origin/$(main_branch) --ff-only'
alias gmt="git mergetool"
alias gp="git push"
alias gpphm="git push && gphm"
alias gpf="git push --force"
alias gpfhm='time git push --force heroku $(main_branch)'
alias gphm='time git push heroku $(main_branch) && osascript -e "display notification \"Heroku deploy finished\"" || osascript -e "display notification \"Heroku deploy FAILED\""'
alias gphmf='time git push --force heroku $(main_branch)'
alias gpop="git pop"
alias gpr="git pull --rebase"
alias gpup="git pup"
alias grb="git rb"
alias grc="git rebase --continue"
alias gres="git reset"
alias greset="git reset"
alias gri="git rebase --interactive"
alias griom='git rebase --interactive origin/$(main_branch)'
alias grscp="git rebase --show-current-patch"
alias grlh="git reflog | head"
alias grhom='git reset --hard origin/$(main_branch)'
alias grom='git rebase origin/$(main_branch)'
alias grh="git reset --hard"
alias grp="git reset --patch"
alias grr="git reset --hard \`git reflog | fzf | cut -d ' ' -f 1\`"
alias grs="git rebase --skip"
alias grsh="git reset --soft 'HEAD^' && git reset"
alias gs="git status"
alias gsgd="git status; git diff"
alias gsh="git show"
alias gshw="git show -w"
alias gsp="git show"
alias gski="git stash --keep-index"
alias gss="git show --stat"
alias gssp="git stash show --patch"
alias gstash="git stash"
alias gsup="git sup"
alias gwip="git add -A . ; git commit -nm 'WIP'"
alias gwtf="git wtf -A"
alias gwtff="git fetch && git wtf -A"
alias ngc="git commit -n"

alias fixup="git commit -nm 'FIXUP ME'"
alias gsq="git commit -nm 'SQUASH ME'"
alias gsquash="git commit -nm 'SQUASH ME'"
alias squash="git commit -nm 'SQUASH ME'"
alias squashme="git commit -nm 'SQUASH ME'"

function hpr {
  gh pr create
}

aliases() {
  alias | grep ${1:-""}
}

# npm
alias ni='npm install'
alias nis='npm install --save'
alias nisd='npm install --save-dev'
alias ng='npm list 2> /dev/null | grep $@'
alias ngc='npm list 2> /dev/null | grep -C5 $@'
alias nr='npm run'
alias nrs='npm start' # npm run start
alias nrt='npm run test'
alias ns='npm start'

# yarn
alias yi='yarn install'
alias ya='yarn add'
alias yr='yarn run'
alias yrm='yarn remove'
alias yt='yarn test'

# use random uuid for uuid generator
alias uuid='uuid -v4'

# javascript
#alias jsl="jslint -process"

# vagrant
alias va="vagrant"
alias vaup="vagrant up"
alias vap="vagrant provision"
alias varedo="vagrant destroy -f; vagrant up"

alias wds="[ -f ./bin/webpack-dev-server ] && ./bin/webpack-dev-server || ./bin/webpacker-dev-server"

alias py="python"

alias pre="pretty"

alias ss="spring stop"
alias ssr="spring stop; r"

#alias ant='color-ant'
alias mvn='color-mvn'

alias week='date "+%V"'

alias wcl='wc -l'

alias -g pxargs="xargs -n 1"

alias tgp="./bin/test && git push"

# silver searcher - use less with color support for j/k support
# hidden shows files with leading period, except for things in ~/.agignore
# (see https://github.com/ggreer/the_silver_searcher/issues/24)
alias ag="ag --smart-case --pager 'less -R' --color-match='1;31' --hidden"
alias cag='ag -C5'
alias agc='ag -C5'
alias agc10='ag -C10'
alias agl='ag -l'
alias lag='ag -l'

# might be better platform independent, but YAGNI right now
alias xe="xargs mvim"

# by default tree doesn't show hidden files, and these can be helpful
alias tree="tree -a"

# print STDERR in red
alias -g errred='2> >(while read line; do echo -e "\e[01;31m$line\e[0m" >&2; done)'

if [[ ! "$PATH" =~ "/usr/local/bin" ]]; then
  PATH=/usr/local/bin:$PATH
fi

if [[ ! "$PATH" =~ "$CONF/common/bin" ]]; then
  PATH+=":"$CONF/common/bin
fi

if [[ ! "$PATH" =~ "/usr/local/sbin" ]]; then
  PATH="/usr/local/sbin:$PATH"
fi

# set this after /usr/local/bin setting to get latest git
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr 'M'
zstyle ':vcs_info:*' unstagedstr 'M'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}[%F{2}%b%F{5}] %F{2}%c%F{3}%u%f'
# 2018-12-02 this seems to be causing a bunch of slowness all of a sudden...
#zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' enable git
# 2023-03-09 This function causes slowness (especially in ~/conf),
# and disabling it doesn't seem to break anything
#+vi-git-untracked() {
#  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
#    git status --porcelain | grep '??' &> /dev/null ; then
#    hook_com[unstaged]+='%F{1}??%f'
#  fi
#}
precmd () { vcs_info }

# single quotes to evaluate each time the prompt is refreshed
RPROMPT='${vcs_info_msg_0_}'

# Calculate writing word diff between revisions. Cribbed / modified from:
# http://stackoverflow.com/questions/2874318/quantifying-the-amount-of-change-in-a-git-diff
function git_words_added {
  revision=${1:-origin/$(main_branch)}
  git diff --word-diff=porcelain $revision | \
    grep -e "^+[^+]" | \
    wc -w | \
    xargs
}

function git_words_removed {
  revision=${1:-origin/$(main_branch)}
  git diff --word-diff=porcelain $revision | \
    grep -e "^-[^-]" | \
    wc -w | \
    xargs
}

function git_words_diff {
  revision=${1:-origin/$(main_branch)}
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

alias news="newsboat -C ~/Dropbox/newsbeuter/config -u ~/Dropbox/newsbeuter/urls"
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

function add_newsbeuter_url {
  if result=$(grep --fixed "$1" ~/Dropbox/newsbeuter/urls); then
    echo "Matched: $result"
    echo 'That URL appears to be present already in the URL file. Not adding.'
  else
    echo "$1" >> ~/Dropbox/newsbeuter/urls
    echo "Added URL to ~/Dropbox/newsbeuter/urls"
  fi
}

function add_url {
  echo "$1" >> /Users/anthony/Documents/dev/incremental-reading/to_import/urls.txt
}

# http://stackoverflow.com/questions/2187829/constantly-updated-clock-in-zsh-prompt
#TMOUT=5 # every five seconds, reset the prompt so the clock is refreshed
#
#TRAPALRM() {
#    zle reset-prompt
#}

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

#if type brew &>/dev/null; then
#  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
#
#  autoload -Uz compinit
#  compinit
#fi

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# https://medium.com/@kinduff/automatic-version-switch-for-nvm-ff9e00ae67f3
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use --silent
  elif [[ $(nvm version) != $(nvm version default)  ]]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

alias weather="curl http://wttr.in/"
