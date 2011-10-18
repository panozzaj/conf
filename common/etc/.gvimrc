" Things that are only in graphical version of Vim

set undodir=~/.vim/tmp/undo//
set undofile
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

" kill help key
"set fuoptions=maxvert,maxhorz
noremap <F1> :set invfullscreen<CR>
inoremap <F1> <ESC>:set invfullscreen<CR>a

set guioptions-=T " hide the toolbar

if has("gui_gtk") || has("gui_gtk2") || has("gui_gnome")
  set guifont=Inconsolata\ 12
elseif has("gui_macvim") || has("gui_mac")
  set guifont=Inconsolata:h12
elseif has("gui_win32")
  set guifont=Inconsolata:h12
end
