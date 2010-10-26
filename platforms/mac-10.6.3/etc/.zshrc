EDITOR='mvim -f -c "au VimLeave * !open -a Terminal"'

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

PATH+=":"$CONF/platforms/$PLATFORM/bin
