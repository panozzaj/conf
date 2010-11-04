EDITOR='mvim -f -c "au VimLeave * !open -a Terminal"'
alias m="mvim"

# setup for Mac Ports
PATH+=:$CONF/platforms/$PLATFORM/bin
PATH+=:/opt/local/bin
MANPATH+=:/opt/local/share/man
INFOPATH+=:/opt/local/share/info

alias spi="sudo port install"

#####
# COMMAND SHORTCUTS
#####

alias ls='ls -abhG'
alias sl='ls -abhG'

# I could both copy and print the warning or just copy without, but want to increase muscle memory
alias xclip='echo "you should be using pbcopy on Mac, not xclip"'


#####
# QUICK PATHS
#####
desk=$HOME/Desktop
doc=$HOME/Documents
dev=$doc/dev

# load up rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.
