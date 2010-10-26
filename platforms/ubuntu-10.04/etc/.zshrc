EDITOR="gvim"

#####
# COMMAND SHORTCUTS
#####

alias sagi="sudo apt-get install"
alias xm="xmms2"

alias -g xclip='xclip -selection c'
# I could both copy and print the warning or just copy without, but want to increase muscle memory
alias pbcopy='echo "you should be using xclip on Ubuntu, not pbcopy"'

# Heroku
export PATH=$PATH:/var/lib/gems/1.8/bin

# zsh shorcuts
alias zshc="gvim ~/.zshrc"

# general shorcuts
alias d2u="todos -d"
alias u2d="todos -u"
alias go=gnome-open

# workaround for problem that gvim has with spitting out garbage in Ubuntu 9.10.
# can remove when this problem is fixed, although I suppose it isn't hurting much
gvim () { command gvim $@ 2> /dev/null }

# gvim shortcut
alias g="gvim"
alias vimrc="$EDITOR ~/.vimrc"

alias ls='ls -aAbhX --color=auto'
alias sl='ls -aAbhX --color=auto'

# Set up home and end keys
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
case $TERM in (xterm*)
	bindkey '\e[H' beginning-of-line
	bindkey '\e[F' end-of-line ;;
esac

#####
# QUICK PATHS
#####
vim=/usr/share/vim
desk=$HOME/Desktop
doc=$HOME/Documents
