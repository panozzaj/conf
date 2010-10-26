#####
# COMMAND SHORTCUTS
#####

alias sagi="sudo apt-get install"
alias xm="xmms2"
alias -g xclip='xclip -selection c'

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
alias vimrc="gvim ~/.vimrc"

#####
# QUICK PATHS
#####
vim=/usr/share/vim
desk=$HOME/Desktop
doc=$HOME/Documents
