alias -g SAY='; say -v Zarvox -r400 "your command-line job has finished"'

alias spi="sudo port install"

#####
# COMMAND SHORTCUTS
#####

alias ls='ls -abhG'
alias sl='ls -abhG'

# I could both copy and print the warning or just copy without, but want to increase muscle memory
alias xclip='echo "you should be using pbcopy on Mac, not xclip"'

alias xcode='open /Developer/Applications/Xcode.app'

# recently 'hidden' FTP commands
alias start_ftp_server='sudo -s launchctl load -w /System/Library/LaunchDaemons/ftp.plist'
alias stop_ftp_server='sudo -s launchctl unload -w /System/Library/LaunchDaemons/ftp.plist'

#####
# QUICK PATHS
#####
desk=$HOME/Desktop
doc=$HOME/Documents
dev=$doc/dev
downloads=~/Downloads

# fink shell script (and presumably others) uses . as a command
#alias .=.
# initialize fink
#source /sw/bin/init.sh
#alias .="cd .."

export JAVA_HOME=/Library/Java/Home
export CATALINA_HOME=/Library/Tomcat/Home

export RUBYOPT="-ropenssl" 

# see http://blog.ghostinthemachines.com/2010/01/19/mac-os-x-fork-resource-temporarily-unavailable/
ulimit -u 512

# load zsh completions for various tools (see `brew info zsh-completions`)
if [[ ! "$fpath" =~ "/usr/local/share/zsh-completions" ]]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi
