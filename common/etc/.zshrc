# load ability to do completions
autoload -Uz compinit && compinit
zmodload -i zsh/complist

# Helper function to warn when an alias conflicts with an existing command
# Usage: safe_alias <name> <command>
function safe_alias() {
  local alias_name="$1"
  local alias_command="$2"

  if (( $# != 2 )); then
    echo "Usage: safe_alias <name> <command>" >&2
    return 1
  fi

  # Check if this name exists as a real command/program
  if command -v "$alias_name" > /dev/null 2>&1 && ! alias "$alias_name" > /dev/null 2>&1; then
    echo "⚠️  Warning: alias '$alias_name' conflicts with existing command: $(command -v "$alias_name")" >&2
  fi

  alias "$alias_name"="$alias_command"
}

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

# Intentionally overrides system ls with gls (GNU ls) with custom options
alias ls='command gls --color=auto --group-directories-first --classify --human-readable --show-control-chars --quoting-style=literal'

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
# Intentionally overrides zsh built-in `r` (redo last command) with rspec runner
#alias r 'echo "Nerfed r command"'
alias r='time best_rspec'
safe_alias rff 'time best_rspec --fail-fast'
safe_alias rodff 'time best_rspec --order defined --fail-fast'

safe_alias t 'time ./bin/test'

safe_alias ll 'ls -lah'

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
# Intentionally overrides dc calculator (uncommon in scripts, useful typo correction)
alias dc='cd'
safe_alias pw 'pwd'
safe_alias pdw 'pwd'
safe_alias grpe 'grep'

# magic power for mkdir (and less typing)
safe_alias mp "mkdir -p"
function mpc() {
  mkdir -p "$1" && cd "$1"
}

# Idea: chmod changes the mod, but what is the mod?
# To query in human-readable terms, use this command.
# I believe this only works for OS X due to difference in stat command.
# http://askubuntu.com/questions/152001
safe_alias mod "stat -f '%A %N'"

# cat wrapper: ls directories instead of erroring
function cat() {
  if [[ $# -eq 1 && -d "$1" ]]; then
    local file_count=$(command ls -1 "$1" | wc -l | tr -d ' ')
    if [[ $file_count -eq 1 ]]; then
      echo "\e[95mcat: $1: Is a directory with 1 file (showing ls then cat)\e[0m" >&2
      command ls "$1"
      local single_file="$1/$(command ls -1 "$1")"
      command cat "$single_file"
    else
      echo "\e[95mcat: $1: Is a directory (showing ls instead)\e[0m" >&2
      command ls "$1"
    fi
  else
    command cat "$@"
  fi
}

alias -g NE="2> /dev/null"

export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;29'

#####
# COMMAND SHORTCUTS
#####

# Ruby
safe_alias be "bundle exec"
safe_alias beg "bundle exec guard"
safe_alias begc "bundle exec guard -c"
safe_alias bi "bundle install -j8"
safe_alias bu "bundle update"

safe_alias prs "parallel_rspec spec"
safe_alias pcf "parallel_cucumber features"

safe_alias rubycop "rubocop"
safe_alias rubocopy "rubocop"

# TODO: explain rake commands with echoes when they are running
#function verbose_alias() {
#  a=$(shift $1)
#  alias $a="$@"
#}
#verbose_alias "fooey" "echo 'test'" ; fooey

# Rake
safe_alias ® "best_rake "
safe_alias br "best_rake "
safe_alias brt "best_rake -T"
safe_alias rkae "best_rake"
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
safe_alias rials "rails"
safe_alias rdb "best_rails db"
# Intentionally overrides ripgrep (rg) - Rails generate is more commonly used in Rails projects
alias rg="best_rails generate"
safe_alias rgmo "best_rails generate model"
safe_alias rgc "best_rails generate controller"
safe_alias rr "best_rails runner"
safe_alias tf "tail -f"
safe_alias tfld "tail -f log/development.log"
safe_alias tflt "tail -f log/test.log"

alias -g aas="app/assets/stylesheets"
alias -g aaj="app/assets/javascripts"
alias -g aav="app/views" # doesn't totally make sense, but my fingers make this


# so this works for Rails 2 through 7+
function rs() {
  # kill any existing servers on this port
  lsof -i tcp:3000 | tail -n+2 | awk '{print $2}' | sort -u | xargs kill -9

  # `-b 0.0.0.0` helps with subdomains in pow
  if [[ -d script && -f script/server ]]; then
    echo ./script/server -b 0.0.0.0 $@
    ./script/server -b 0.0.0.0 $@
  else
    echo rails server -b 0.0.0.0 $@
    rails server -b 0.0.0.0 $@
  fi
}

# so this works for Rails 2 through 7+
function rc() {
  if [[ -d bin && -f bin/spring ]]; then
    echo spring rails console $@
    spring rails console $@
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
  best_rails generate migration $@
  if [ $? -eq 0 ]; then
    emig
  fi
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

alias catmig=cmig

function catdm() {
  find db/migrate | sort -r | head -1 | xargs cat
}

function tailmig() {
  find db/migrate | sort | tail -5
}

alias cr="checkruby HEAD"

# gem
alias sgi="sudo gem install"
alias sgu="sudo gem update"
alias gi="gem install"
alias gu="gem uninstall"

alias cuc="time best_cucumber"
alias -g PIPE="|"

# helpful: https://git-scm.com/docs/git-status#_output
# $NF: take last matching field. Handles renames:
# R  spec/1_spec.rb -> features/2_spec.rb
function modified_files() {
  git status --porcelain | \
    grep -v -e '^.D' -e '^D' | \
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
  echo 'Finding cucumber files that have changed since the last commit.'

  files=$(modified_files | \
    grep features/ | \
    grep -v features/support/ | \
    grep -v features/step_definitions/
  )

  if [ -z "$files" ]; then
    echo "No cucumber files changed."
    return 1
  fi

  echo -n "best_cucumber "
  echo $files | xargs echo
  echo $files | xargs best_cucumber
}

# roughly: run any cucumber files that we have changed on our feature branch
function gdomcuc() {
  echo "Finding cucumber files that have changed from $(main_branch)."

  files=$(git diff origin/$(main_branch) --stat=200 | \
    cut -f 2 -d ' ' | \
    grep features/ | \
    grep -v features/support/ | \
    grep -v features/step_definitions/
  )

  if [ -z "$files" ]; then
    echo "No cucumber files changed from $(main_branch) branch."
    return 1
  fi

  echo -n "best_cucumber "
  echo $files | xargs echo
  echo $files | xargs best_cucumber
}

# roughly: run any specs that we have changed since the last commit
# Usage: gspec [commit-hash]
#   - No args: runs specs from uncommitted changes
#   - With hash: runs specs changed since that commit
function gspec() {
  local commit_hash="$1"

  if [ -n "$commit_hash" ]; then
    echo "Finding spec files that have changed since $commit_hash."
    files=$(git diff --name-only "$commit_hash" | grep _spec.rb)
  else
    echo 'Finding spec files that have changed since the last commit.'
    files=$(modified_files | grep _spec.rb)
  fi

  if [ -z "$files" ]; then
    echo "No spec files changed."
    return 1
  fi

  echo -n "best_rspec "
  echo $files | xargs echo
  echo $files | xargs best_rspec
}
alias gdspec=gspec
alias gsspec=gspec

# roughly: run any tests that we have changed since HEAD or specified commit
# Usage: gtest [commit-hash]
#   - No args: runs tests from uncommitted changes
#   - With hash: runs tests changed since that commit
# Supports both Ruby specs (_spec.rb) and JS tests (.test.js, .spec.js)
function gtest() {
  local commit_hash="$1"

  if [ -n "$commit_hash" ]; then
    echo "Finding test files that have changed since $commit_hash."
    files=$(git diff --name-only "$commit_hash")
  else
    echo 'Finding test files that have changed in working directory.'
    files=$(modified_files)
  fi

  # Separate Ruby specs and JS tests
  ruby_specs=$(echo "$files" | grep '_spec\.rb$')
  js_tests=$(echo "$files" | grep -E '\.(test|spec)\.js$')

  local ran_tests=false

  # Run JS tests first (faster)
  if [ -n "$js_tests" ]; then
    echo "=== Running JavaScript tests with jest ==="
    echo $js_tests | xargs echo
    echo $js_tests | xargs jest
    ran_tests=true
  fi

  # Run Ruby specs
  if [ -n "$ruby_specs" ]; then
    echo "=== Running Ruby specs with best_rspec ==="
    echo $ruby_specs | xargs echo
    echo $ruby_specs | xargs best_rspec
    ran_tests=true
  fi

  if [ "$ran_tests" = false ]; then
    echo "No test files changed."
    return 1
  fi
}
alias gdtest=gtest
alias gstest=gtest

# roughly: run any specs that we have changed on our feature branch
function gdomspec() {
  echo "Finding spec files that have changed from $(main_branch)."

  files=$(git diff origin/$(main_branch) --stat=200 | \
    cut -f 2 -d ' ' | \
    grep spec/ | \
    grep '_spec\.rb$'
  )

  if [ -z "$files" ]; then
    echo "No spec files changed from $(main_branch) branch."
    return 1
  fi

  echo -n "best_rspec "
  echo $files | xargs echo
  echo $files | xargs best_rspec $@
}

function extract_rspec_failures() {
  # this is useful for pasting into a terminal that doesn't support
  # multi-line pastes, like iTerm2
  pbpaste | grep -e '^rspec' | cut -d ' ' -f 2 | sort | tr '\n' ' \\\n'
}

function rspec_paste_join() {
  # this is useful for pasting into a terminal that doesn't support
  # multi-line pastes, like iTerm2
  pbpaste | cut -d ' ' -f 2 | sort | tr '\n' ' ' | sed 's/ $/\n/'
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
DISABLE_SENTRY=1
alias hr="heroku whoami && heroku run"
function hrc {
  # If an argument is provided and it doesn't contain a dash or underscore,
  # use --remote= format for git remote name
  if [[ -n "$1" ]] && [[ ! "$1" =~ [-_] ]]; then
    heroku whoami && heroku run rails console "--remote=$1"
  else
    # Otherwise, pass all arguments as-is
    heroku whoami && heroku run rails console "$@"
  fi
}
alias hrrc="heroku whoami && heroku run rails console"
alias hrdb="heroku whoami && heroku pg:psql"
alias hrsql="heroku whoami && heroku pg:psql"
alias hrdm="heroku whoami && heroku run rake db:migrate"
alias hrr="heroku whoami && echo heroku run rake '<your command>'; heroku run rake"
alias hrrr="heroku whoami && echo heroku run rails runner '<your command>'; heroku run rails runner"
alias her="heroku"
alias hl="heroku logs"
alias hlt="heroku logs -t"

# takes heroku params before or after search term
# Examples:
#   hcg DATABASE_URL
#   hcg DATABASE_URL production
#   hcg DATABASE_URL -r production
#   hcg -r production DATABASE_URL
function hcg() {
  local heroku_args=()
  local search=""

  # Parse arguments to separate heroku flags from search term
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -r|--remote|-a|--app)
        # Flag with value (next argument)
        heroku_args+=("$1" "$2")
        shift 2
        ;;
      --remote=*|--app=*)
        # Flag with value in same argument
        heroku_args+=("$1")
        shift
        ;;
      *)
        # First non-flag argument is the search term
        if [[ -z "$search" ]]; then
          search="$1"
          shift
        else
          # Subsequent non-flag arguments: treat as remote name if no dashes/underscores
          if [[ ! "$1" =~ [-_] ]]; then
            heroku_args+=("--remote=$1")
          else
            heroku_args+=("$1")
          fi
          shift
        fi
        ;;
    esac
  done

  if [[ -z "$search" ]]; then
    echo "Usage: hcg [heroku-flags] <search-term> [remote-name]"
    return 1
  fi

  heroku config "${heroku_args[@]}" | grep -i "$search"
}

safe_alias fs "foreman start"

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

# you can do this in dry-run mode, but not in real mode, per
# fatal: the option '--ignore-missing' requires '--dry-run'
git_add_ignore_missing() {
  for arg in "$@"; do
    if [ -f "$arg" ]; then
      git add "$arg"
    fi
  done
}

# you can do this in dry-run mode, but not in real mode, per
# fatal: the option '--ignore-missing' requires '--dry-run'
git_checkout_ignore_missing() {
  for arg in "$@"; do
    if [ -f "$arg" ]; then
      git checkout "$arg" > /dev/null 2>&1
    fi
  done
}

safe_alias g "git"
alias ga="git add --all"
alias gaa="git add --all"
alias gai="git add --interactive"
alias gaia="git add --intent-to-add"
alias gaia.="git add --intent-to-add ."
alias gagems="git add Gemfile Gemfile.lock; git diff --cached Gemfile Gemfile.lock; echo 'added, consider running gem_summary to get a quick commit message'"
alias gajs="git_add_ignore_missing package.json package-lock.json yarn.lock"
alias gam="git amend"
alias gamn="git amend -n"
alias gamend="git amend"
alias ganc="git amend-nc"
alias gancn="git amend-nc -n"
alias gap="git add --patch"
alias gb-="git checkout -"
# Enhanced git branch alias with time since last commit and color coding
# Colors: orange (<1 day), yellow (<1 week), grey (>1 month)
function gb() {
  local current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  local now=$(date +%s)

  # Determine main branch (check in order: main, master, develop)
  local main_branch=""
  for candidate in main master develop; do
    if git show-ref --verify --quiet refs/heads/$candidate; then
      main_branch=$candidate
      break
    fi
  done

  # Get list of worktree branches
  local -A worktree_branches
  while read -r wt_branch; do
    worktree_branches[$wt_branch]=1
  done < <(git worktree list 2>/dev/null | grep -o '\[[^]]*\]' | tr -d '[]')

  # First pass: get all data and find max branch name length
  local branches_data=$(git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)|%(committerdate:relative)|%(committerdate:unix)')
  local max_len=0

  while IFS='|' read -r branch rel_date unix_ts; do
    local len=${#branch}
    if [ $len -gt $max_len ]; then
      max_len=$len
    fi
  done <<< "$branches_data"

  # Display main branch first if it exists
  if [ -n "$main_branch" ]; then
    local padded_main=$(printf "%-${max_len}s" "$main_branch")
    local main_prefix="  "

    if [ "$main_branch" = "$current_branch" ]; then
      main_prefix="%F{34}* %f"
    elif [[ -n "${worktree_branches[$main_branch]}" ]]; then
      main_prefix="+ "
    fi

    print -P "${main_prefix}%F{green}%B${padded_main}%b%f"
  fi

  # Second pass: display other branches with proper alignment
  while IFS='|' read -r branch rel_date unix_ts; do
    # Skip main branch (already displayed)
    if [ "$branch" = "$main_branch" ]; then
      continue
    fi

    local age=$((now - unix_ts))

    # Clean up relative date display
    if [[ "$rel_date" =~ "seconds ago" ]]; then
      rel_date="just now"
    elif [[ "$rel_date" =~ "^1 minute" ]]; then
      rel_date="1 minute ago"
    fi

    # Determine color based on age
    local color_code=""
    if [ $age -lt 86400 ]; then
      # Less than 1 day - muted orange
      color_code="208"
    elif [ $age -lt 604800 ]; then
      # Less than 1 week - muted yellow
      color_code="178"
    elif [ $age -gt 2592000 ]; then
      # More than 1 month - grey
      color_code="240"
    fi

    # Format output with color
    local padded_branch=$(printf "%-${max_len}s" "$branch")
    local prefix="  "

    # Determine prefix (*, +, or spaces)
    if [ "$branch" = "$current_branch" ]; then
      prefix="%F{34}* %f"
    elif [[ -n "${worktree_branches[$branch]}" ]]; then
      prefix="+ "
    fi

    if [ -n "$color_code" ]; then
      print -P "${prefix}${padded_branch} %F{${color_code}}[${rel_date}]%f"
    else
      print -P "${prefix}${padded_branch} [${rel_date}]"
    fi
  done <<< "$branches_data"
}
alias gba="git branch --all"
alias gbb="git bisect bad"
alias gbg="git bisect good"
alias gblame="git blame"
alias gbs="git bisect skip"
alias gbr="git branch --remote"
alias gc="git commit --verbose"
alias gcl="git clone"
alias gcdf="git clean -df"
alias gco="git checkout"
alias gco-="git checkout -"
alias gcob="git checkout -b"
alias gcobi="git checkout \`git branch --sort=-committerdate | fzf\`"
alias gcogem="git checkout Gemfile Gemfile.lock"
alias gcogems="git checkout Gemfile Gemfile.lock"
alias gcojs="git_checkout_ignore_missing package.json package-lock.json yarn.lock" # quickly revert JS package changes

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
alias gdcs="git diff --cached --stat"
alias gdcw="git diff --cached --ignore-all-space"
alias gdm='git diff $(main_branch)'
alias gdmw='git diff $(main_branch) --ignore-all-space'
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
alias gfriom='echo "git fetch" && git fetch && git-reword-helper origin/$(main_branch)'
alias gfwtf="git fetch && git wtf -A"
alias gl1="gl -1"
alias gl="git log --oneline --graph --decorate"
alias glh="gl -10"
alias glh1="glh -1"
alias glp="git log --patch --decorate"
alias glpw="glp --ignore-all-space"
alias glom='gl origin/$(main_branch)^..HEAD'
alias glss="git log --stat --decorate"
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
alias gpull="git pull"
alias gpup="git pup"
alias grb="git rb"
alias grc="git rebase --continue"
alias gres="git reset"
alias greset="git reset"
alias gri='git-reword-helper'
alias griom='git-reword-helper origin/$(main_branch)'
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
alias gsp="git stash --patch"
alias gski="git stash --keep-index"
alias gss="git show --stat"
alias gssp="git stash show --patch"
alias gsspw="git stash show --patch -w"
alias gstash="git stash"
alias gsup="git sup"
alias gwip="git add -A . ; git commit -nm 'WIP'"
alias gwtf="git wtf -A"
alias gwtff="git fetch && git wtf -A"

alias ngc="git commit -n"

# various git commit helpers
alias fixup="git commit -nm 'FIXUP ME'"
alias gsq="git commit -nm 'SQUASH ME'"
alias gsquash="git commit -nm 'SQUASH ME'"
alias squash="git commit -nm 'SQUASH ME'"
alias squashme="git commit -nm 'SQUASH ME'"

# mnemonic: git change branch
function gcb() {
  if [[ -z "$1" ]]; then
    # Open interactive branch selection with gb-style formatting
    local current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    local now=$(date +%s)

    # Determine main branch (check in order: main, master, develop)
    local main_branch=""
    for candidate in main master develop; do
      if git show-ref --verify --quiet refs/heads/$candidate; then
        main_branch=$candidate
        break
      fi
    done

    # Get list of worktree branches
    local -A worktree_branches
    while read -r wt_branch; do
      worktree_branches[$wt_branch]=1
    done < <(git worktree list 2>/dev/null | grep -o '\[[^]]*\]' | tr -d '[]')

    # Get all data and find max branch name length
    local branches_data=$(git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)|%(committerdate:relative)|%(committerdate:unix)')
    local max_len=0

    while IFS='|' read -r branch rel_date unix_ts; do
      local len=${#branch}
      if [ $len -gt $max_len ]; then
        max_len=$len
      fi
    done <<< "$branches_data"

    # Build formatted output
    local output=""

    # Main branch first if it exists
    if [ -n "$main_branch" ]; then
      local padded_main=$(printf "%-${max_len}s" "$main_branch")
      local main_prefix="  "

      if [ "$main_branch" = "$current_branch" ]; then
        main_prefix="\033[38;5;34m* \033[0m"
      elif [[ -n "${worktree_branches[$main_branch]}" ]]; then
        main_prefix="+ "
      fi

      output="${main_prefix}\033[32;1m${padded_main}\033[0m\n"
    fi

    # Other branches with proper alignment
    while IFS='|' read -r branch rel_date unix_ts; do
      # Skip main branch (already displayed)
      if [ "$branch" = "$main_branch" ]; then
        continue
      fi

      local age=$((now - unix_ts))

      # Clean up relative date display
      if [[ "$rel_date" =~ "seconds ago" ]]; then
        rel_date="just now"
      elif [[ "$rel_date" =~ "^1 minute" ]]; then
        rel_date="1 minute ago"
      fi

      # Determine color based on age
      local color_code=""
      if [ $age -lt 86400 ]; then
        color_code="208"
      elif [ $age -lt 604800 ]; then
        color_code="178"
      elif [ $age -gt 2592000 ]; then
        color_code="240"
      fi

      local padded_branch=$(printf "%-${max_len}s" "$branch")
      local prefix="  "

      if [ "$branch" = "$current_branch" ]; then
        prefix="\033[38;5;34m* \033[0m"
      elif [[ -n "${worktree_branches[$branch]}" ]]; then
        prefix="+ "
      fi

      if [ -n "$color_code" ]; then
        output+="${prefix}${padded_branch} \033[38;5;${color_code}m[${rel_date}]\033[0m\n"
      else
        output+="${prefix}${padded_branch} [${rel_date}]\n"
      fi
    done <<< "$branches_data"

    # Use fzf with ANSI colors, extract just the branch name
    local selected=$(echo -e "$output" | fzf --ansi --no-sort | sed 's/^[* +]*//' | awk '{print $1}')
    if [ -n "$selected" ]; then
      git checkout "$selected"
    fi
  else
    # Switch to the branch specified
    git checkout $1
  fi
}

function hpr {
  gh pr create
}

aliases() {
  alias | grep ${1:-""}
}

# npm
safe_alias ni 'npm install'
safe_alias nis 'npm install --save'
safe_alias nisd 'npm install --save-dev'
safe_alias ng 'npm list 2> /dev/null | grep $@'
safe_alias ngc 'npm list 2> /dev/null | grep -C5 $@'
safe_alias nr 'npm run'
safe_alias nrd 'npm run dev'
safe_alias nrs 'npm start' # npm run start
safe_alias nrt 'npm run test'
safe_alias ns 'npm start'

# yarn
safe_alias yi 'yarn install'
safe_alias ya 'yarn add'
safe_alias yr 'yarn run'
safe_alias yrm 'yarn remove'
safe_alias ys 'yarn start'
safe_alias yt 'yarn test'

# python
safe_alias pi 'pip install'

# use random uuid for uuid generator
safe_alias uuid 'uuid -v4'

# javascript
#alias jsl="jslint -process"

# vagrant
safe_alias va "vagrant"
safe_alias vaup "vagrant up"
safe_alias vap "vagrant provision"
safe_alias varedo "vagrant destroy -f; vagrant up"

# kill existing server, and then use ./bin/webpacker-dev-server or ./bin/shakapacker-dev-server
function wds() {
  # kill any existing servers on this port
  lsof -i tcp:3035 | tail -n+2 | awk '{print $2}' | sort -u | xargs kill -9

  if [[ -f ./bin/shakapacker-dev-server ]]; then
    echo ./bin/shakapacker-dev-server $@
    ./bin/shakapacker-dev-server $@
  elif [[ -f ./bin/webpacker-dev-server ]]; then
    echo ./bin/webpacker-dev-server $@
    ./bin/webpacker-dev-server $@
  else
    echo "This project does not have a ./bin/shakapacker-dev-server or ./bin/webpacker-dev-server"
  fi
}

safe_alias py "python"

safe_alias pre "pretty"

safe_alias ss "spring stop"
safe_alias ssr "spring stop; r"

#safe_alias ant 'color-ant'
safe_alias mvn 'color-mvn'

safe_alias week 'date "+%V"'

safe_alias wcl 'wc -l'

alias -g pxargs="xargs -n 1"

safe_alias tgp "./bin/test && git push"

# silver searcher - use less with color support for j/k support
# hidden shows files with leading period, except for things in ~/.agignore
# (see https://github.com/ggreer/the_silver_searcher/issues/24)
# Intentionally overrides ag with custom flags for better defaults
alias ag="ag --smart-case --pager 'less -R' --color-match='1;31' --hidden"
safe_alias cag 'ag -C5'
safe_alias cag10 'ag -C10'
safe_alias agc 'ag -C5'
safe_alias agcw 'ag -C5 -W 300'
safe_alias agc10 'ag -C10'
safe_alias agl 'ag -l'
safe_alias lag 'ag -l'
safe_alias wag 'ag -W 300' # don't print lines longer than 300 characters (good for minified files, etc.)

# might be better platform independent, but YAGNI right now
safe_alias xe "xargs mvim"

# by default tree doesn't show hidden files, and these can be helpful
# Intentionally overrides tree to show hidden files by default
alias tree="tree -a"
safe_alias tff "tree -a --fromfile"

function stree() {
  if [[ -n "$1" ]]; then
    git ls-files | egrep "$1" | tree -a --fromfile
  else
    git ls-files | tree -a --fromfile
  fi
}

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

if [[ ! "$PATH" =~ "$HOME/.docker/bin" ]]; then
  PATH="$HOME/.docker/bin:$PATH"
fi

if [[ ! "$PATH" =~ "~/.local/bin" ]]; then
  PATH=~/.local/bin:$PATH
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

alias dfc="dataform compile"
alias dff="dataform format"
alias dfr="dataform run"
alias dfrdr="dataform run --dry-run"
alias dfra="dataform run --actions"
function dfraid() {
  cmd="dataform run --include-deps --include-dependents --actions $@"
  echo $cmd
  eval $cmd
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

function install_jsctags {
  npm install jsctags
  # https://github.com/mozilla/doctorjs/issues/52
  gsed -i '51i tags: [],' ./node_modules/jsctags/jsctags/ctags/index.js
}

function add_url {
  echo "$1" >> /Users/anthony/Documents/dev/incremental-reading/to_import/urls.txt
}

# https://jvns.ca/til/programs-can-make-your-cursor-disappear/
function reset_cursor {
  echo -e "\033[?25h"
}

function echo_path {
  echo $PATH | tr ':' '\n'
}

safe_alias cl 'claude'
safe_alias CL 'claude --dangerously-skip-permissions'
# Intentionally overrides CLAUDE binary with permissions-skipping version
alias CLAUDE='claude --dangerously-skip-permissions'
alias CLC='claude --dangerously-skip-permissions -c'
alias CLR='claude --dangerously-skip-permissions -r'

function gcob_gh_issue {
  if [[ -z "$1" ]]; then
    echo "Usage: gco_branch_name_from_issue <issue-number-or-url>"
    return 1
  fi

  branch_name=$(git-issue-branch-name "$1")
  echo "Generated branch name: $branch_name"
  read "response?Create and switch to this branch? (y/n) "
  if [[ "$response" == "y" || "$response" == "Y" ]]; then
    git checkout -b $branch_name
    echo "Created and switched to branch: $branch_name"
  else
    echo "Aborted."
  fi
}

function git-new-wt {
  output=$(command git-new-wt "$@")
  echo "$output" | grep -v "^WORKTREE_DIR="
  worktree_dir=$(echo "$output" | grep "^WORKTREE_DIR=" | cut -d= -f2)
  if [[ -n "$worktree_dir" ]]; then
    cd "$worktree_dir"
  fi
}

function gem_summary {
  if [[ -n $(git diff --cached Gemfile Gemfile.lock) ]]; then
    echo "Staged changes detected:"
  else
    echo "No staged changes in Gemfile.lock"
    return 1
  fi

  git diff --cached Gemfile Gemfile.lock

  summary_prompt="output the primary gem that was updated in this format: gems: (Upgrade|Downgrade) <gemname> <version1> -> <version2>. If the gem was added, just say 'gems: Add <gemname>'. If the gem was removed, just say 'gems: Remove <gemname>'."
  summary=$(git diff --cached -U0 Gemfile Gemfile.lock | llm $summary_prompt)

  echo $summary
  if [[ -n "$summary" ]]; then
    git commit -m "$summary" --edit
  fi
}

function llm_commit {
  if [[ -n $(git diff --cached) ]]; then
    echo "Staged changes detected:"
  else
    echo "No staged changes"
    return 1
  fi

  git diff --cached

  summary_prompt='output a one line description of the change. it MUST be 50 characters or less total. if the change was only to .cursor/rules file(s), start with ".cursor/rules: "'
  summary=$(git diff --cached -U0 | llm $summary_prompt)

  echo $summary
  if [[ -n "$summary" ]]; then
    git commit -m "$summary" --edit
  fi
}

# http://stackoverflow.com/questions/2187829/constantly-updated-clock-in-zsh-prompt
#TMOUT=5 # every five seconds, reset the prompt so the clock is refreshed
#
#TRAPALRM() {
#    zle reset-prompt
#}

#if type brew &>/dev/null; then
#  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
#
#  autoload -Uz compinit
#  compinit
#fi

safe_alias weather "curl 'https://wttr.in/Fishers?u'"

# https://www.jdeen.com/blog/fix-ruby-macos-nscfconstantstring-initialize-error
# Was getting:
# objc[75787]: +[__NSCFConstantString initialize] may have been in progress in another thread when fork() was called.#
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

if is_agent; then
  echo "Running ZSH in an agentic context"

  # Disable delta pager when AI agent is active
  export GIT_PAGER="cat"
  export GIT_INTERACTIVE_DIFF_FILTER=""
fi
