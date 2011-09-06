" Things that are only in graphical version of Vim

set undodir=~/.vim/tmp/undo//
set undofile
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

" kill help key
set fuoptions=maxvert,maxhorz
noremap <F1> :set invfullscreen<CR>
inoremap <F1> <ESC>:set invfullscreen<CR>a

" shows some interesting and normally not visible stuff
" annoying with almost every color scheme but zenburn
" perhaps due to the colorscheme's settings
" see list documentation for more details
"set list
"set listchars=tab:>-,trail:·,eol:$,nbsp:%
