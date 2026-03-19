
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/anthony/.lmstudio/bin"

cd .

export PATH="$HOME/.elan/bin:$PATH"
