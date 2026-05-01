
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# asdf version manager — prepend shims so they win over /usr/bin (path_helper
# in /etc/profile prepends /usr/bin, which would otherwise shadow asdf shims).
export PATH="$HOME/.asdf/shims:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/anthony/.lmstudio/bin"

cd .

export PATH="$HOME/.elan/bin:$PATH"
export PATH=$PATH:$HOME/.maestro/bin
