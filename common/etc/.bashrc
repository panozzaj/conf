[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [[ ! "$PATH" == *$HOME/.rvm/bin* ]]; then
  export PATH="$PATH:$HOME/.rvm/bin"
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/anthony/.lmstudio/bin"
