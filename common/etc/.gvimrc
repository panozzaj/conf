" Things that are only in graphical version of Vim

set undodir=~/.vim/tmp/undo//
set undofile
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

"set fuoptions=maxvert,maxhorz
" kill help key
nnoremap <F1> <nop>

set guioptions-=T " hide the toolbar
set guioptions-=m " hide the menu bar

" Experimental
"  toggle trailing whitespace highlighting with leader + s
set listchars=tab:>-,trail:· ",eol:$
nmap <silent> <leader>s ;set nolist!<CR>
set list

if has("gui_gtk") || has("gui_gtk2") || has("gui_gnome")
  set novisualbell
  set guifont=Inconsolata\ 12
elseif has("gui_macvim") || has("gui_mac")
  set guifont=Inconsolata:h18
elseif has("gui_win32")
  set guifont=Inconsolata:h12
end

set formatoptions+=j " 'Where it makes sense, remove a comment leader when joining lines.'

