fzf_cellar_dir="$(brew --cellar fzf)"

# Use the latest version of fzf since it uses versions
fzf_dir="$(brew --cellar fzf)/$(ls "$(brew --cellar fzf)" | tail -n 1)"

# Setup fzf
# ---------
if [[ ! "$PATH" == *$fzf_dir/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$fzf_dir/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$fzf_dir/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$fzf_dir/shell/key-bindings.zsh"
