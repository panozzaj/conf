set nocompatible

highlight Pmenu guibg=brown gui=bold
syntax enable

set guifont=Inconsolata:h18
set showcmd

if &l:diff
  colors peachpuff
  set diffopt+=iwhite   " ignore whitespace differences for diff
else
  colors neon
endif

set nu
set ic
set is
set wrap

set visualbell

let g:NERDShutUp=1
let g:Twiki_FoldAtHeadings=1

set wildmode=longest,list " bash-style file completion

" The first few were defaults, but I want h and l to work between lines as well.
set whichwrap=b,s,<,>,[,],h,l
set hls
set gcr=a:blinkon0 " Set the cursor to not blink
set expandtab
set smarttab
set smartindent
let g:rubycomplete_rails = 1
set backupdir=/tmp " change backup directory so backups don't go everywhere
set guioptions-=T " hide the toolbar

"set foldmethod=syntax
set scrolloff=2 " leave a gap between bottom of window and cursor, if possible

" enter command mode without using shift key
nnoremap ; :
nnoremap : ;

cabbr manual set foldmethod=manual

cabbr wp call Wp()
fun! Wp()
  set lbr
  source ~/.vim/autocorrect.vim
  nnoremap j gj
  nnoremap k gk
  nnoremap 0 g0
  nnoremap $ g$
  set nonumber
  set spell spelllang=en_us
  set guifont=Inconsolata\ 14
endfu

cabbr autocommit call Autocommit()
fun! Autocommit()
  au BufWritePost * silent !git add <afile>
  au BufWritePost * silent !git commit <afile> -m 'Generated commit'
endfu

fun! Writing()
  call Autocommit()
  call Wp()
  colo lettuce
endfu

fun! Blog()
  call Writing()
  cd Documents/blog_stuff
  set syntax=html
endfu

fun! Log()
  call Writing()
  cd Documents/logs
endfu

fun! Gtd()
  call Wp()
  cd Documents/gtd
endfu

iabbrev dts <C-R>=strftime("%Y%m%d - %H%M")<CR>

iabbrev wrt with respect to
iabbrev otoh on the other hand
iabbrev btw by the way
iabbrev Wrt With respect to
iabbrev Otoh On the other hand
iabbrev Btw By the way
iabbrev imo in my opinion
iabbrev Imo in my opinion

" latex-suite
filetype plugin on
set grepprg=grep\ -nH\ $*
filetype indent on
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat="pdf"

" should be in another file, but don't care for now
" should also move things from vim72/** that I added into my personal .vim directory
au BufReadPost * if getline(2) =~ "This is the personal log of Anthony.  Please stop reading unless you are Anthony." | call Wp() | endif

au BufRead,BufNewFile {Capfile,Gemfile,Rakefile,Thorfile,config.ru,.caprc,.irbrc,irb_tempfile*} set ft=ruby
au FileType conf set foldmethod=manual

"""""""""""""""""""""""""""""""""""
" some from mswin.vim for consistency/quickness
" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
vnoremap <S-Del> "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y

" CTRL-V and SHIFT-Insert are Paste
map <C-V>       "+gP
map <S-Insert>          "+gP

cmap <C-V>      <C-R>+
cmap <S-Insert>         <C-R>+

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.

exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

imap <S-Insert>         <C-V>
vmap <S-Insert>         <C-V>

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q>           <C-V>

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w

" CTRL-F4 is Close window
noremap <C-F4> <C-W>c
inoremap <C-F4> <C-O><C-W>c
cnoremap <C-F4> <C-C><C-W>c
onoremap <C-F4> <C-C><C-W>c

"""""""""""""""""""""""""""""""""""
" some additional things I added to be more consistent with other
" tab/window-like applications
" CTRL-Shift-Tab is Previous window
noremap <C-S-Tab> <C-W>W
inoremap <C-S-Tab> <C-O><C-W>W
cnoremap <C-S-Tab> <C-C><C-W>W
onoremap <C-S-Tab> <C-C><C-W>W

noremap <C-PageUp> <C-W>W
inoremap <C-PageUp> <C-O><C-W>W
cnoremap <C-PageUp> <C-C><C-W>W
onoremap <C-PageUp> <C-C><C-W>W

noremap <C-PageDown> <C-W>w
inoremap <C-PageDown> <C-O><C-W>w
cnoremap <C-PageDown> <C-C><C-W>w
onoremap <C-PageDown> <C-C><C-W>w

" CTRL-A is Select all
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG
