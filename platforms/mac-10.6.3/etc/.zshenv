EDITOR='mvim'
export GIT_EDITOR="mvim --nofork"

# Make clean tarballs and more in Tiger
export COPY_EXTENDED_ATTRIBUTES_DISABLE=true

# Make clean tarballs and more in Leopard
export COPYFILE_DISABLE=true

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.
