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

alias xcode='open /Developer/Applications/Xcode.app'

#####
# QUICK PATHS
#####
desk=$HOME/Desktop
doc=$HOME/Documents
dev=$doc/dev
downloads=~/Downloads

# fink shell script (and presumably others) uses . as a command
alias .=.
# initialize fink
source /sw/bin/init.sh
alias .="cd .."

export JAVA_HOME=/Library/Java/Home
export CATALINA_HOME=/Library/Tomcat/Home

export RUBYOPT="-ropenssl" 

# see http://blog.ghostinthemachines.com/2010/01/19/mac-os-x-fork-resource-temporarily-unavailable/
ulimit -u 512
