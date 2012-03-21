filetype off
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
filetype plugin indent on
set nocompatible

set history=1000 " lines of history to remember
runtime macros/matchit.vim

highlight Pmenu guibg=brown gui=bold
syntax enable

set showcmd

set undolevels=1000 "maximum number of changes that can be undone

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

let g:closetag_html_style=1
"source ~/.vim/closetag.vim 

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
set backupdir=~/.vim/tmp/backup// " change backup directory so backups don't go everywhere
set backup
set directory=~/.vim/tmp/swap//
set mouse=a " mouse support for terminal vim
set title " terminal title set to buffer name

"set foldmethod=syntax
set scrolloff=2 " leave a gap between bottom of window and cursor, if possible

cabbr manual set foldmethod=manual

let g:rubycomplete_rails = 1

"cabbr wp call Wp()
fun! Wp()
  set lbr
  source ~/.vim/autocorrect.vim
  nnoremap j gj
  nnoremap k gk
  nnoremap 0 g0
  nnoremap $ g$
  set nonumber
  set spell spelllang=en_us
  set lbr
  set nolist " lbr command relies on list being off :(
  if has("gui_gtk") || has("gui_gtk2") || has("gui_gnome")
    set guifont=Inconsolata\ 16
  elseif has("gui_macvim") || has("gui_mac")
    set guifont=Inconsolata:h16
  elseif has("gui_win32")
    set guifont=Inconsolata:h16
  end
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

au BufRead,BufNewFile {Capfile,Gemfile,Rakefile,Thorfile,config.ru,.caprc,.irbrc,irb_tempfile*,Vagrantfile} set ft=ruby
au FileType conf set foldmethod=manual
au BufRead,BufNewFile *.less setfiletype less
"au BufRead,BufNewFile *.ino setfiletype ino

imap <C-BS> <C-W>

let g:CommandTMatchWindowAtTop = 1 " want the best command-t matches at the top so they never move
nnoremap <leader>T <Esc>:CommandTFlush<CR>


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

nnoremap Y y$
nnoremap D d$

" Experimental
"  toggle trailing whitespace highlighting with leader + s
set listchars=tab:>-,trail:· ",eol:$
nmap <silent> <leader>s ;set nolist!<CR>
set list

" Don't expand tab in Makefiles
autocmd FileType make set noexpandtab

" Use the javascript syntax highlighting for JSON files
autocmd BufNewFile,BufRead *.json set ft=javascript

set wildignore=*.o,*.class,*.png,*.pdf,*.ps,*.gif,*.jpg,*.aux,*.toc,*.cod,*.bak,*.mp3,*.m4a,*.wmv,*.mpg,*.mov,*.doc,*.bc
set wildignore+=vendor/rails/**
set wildignore+=build/android  " Titanium

" Enable automatic spell checking for txt and tex files
let spell_auto_type="tex,txt"

" Turns an word into a regex to match that word
function English(word)
  " Case-insensitive, and properly bounded.
  return '\c\<' . a:word . '\>'
endfunction

" For proofreading.
" From the bottom of http://www.cs.princeton.edu/~npjohnso/dot.vimrc
fun! Proofreading()
  highlight Weakener ctermbg=yellow ctermfg=blue guibg=reg guifg=blue
  call matchadd("Weakener", English('general'), 1)
  call matchadd("Weakener", English('generally'), 1)
  call matchadd("Weakener", English('in general'), 1)
  call matchadd("Weakener", English('usual'), 1)
  call matchadd("Weakener", English('usually'), 1)
  call matchadd("Weakener", English('often'), 1)
  call matchadd("Weakener", English('frequent'), 1)
  call matchadd("Weakener", English('frequenty'), 1)
  call matchadd("Weakener", English('many'), 1)
  call matchadd("Weakener", English('in many cases'), 1)
  call matchadd("Weakener", English('effective'), 1)
  call matchadd("Weakener", English('effectively'), 1)
  call matchadd("Weakener", English('can'), 1)
  call matchadd("Weakener", English('may'), 1)
  call matchadd("Weakener", English('could'), 1)
  call matchadd("Weakener", English('should'), 1)
  call matchadd("Weakener", English('might'), 1)
  call matchadd("Weakener", English('possible'), 1)
  call matchadd("Weakener", English('possibly'), 1)
  call matchadd("Weakener", English('potential'), 1)
  call matchadd("Weakener", English('potentially'), 1)

  " Contractions
  highlight Contraction ctermbg=white ctermfg=blue guibg=white guifg=blue
  call matchadd("Contraction", English("I'm"), 1)
  call matchadd("Contraction", English("He's"), 1)
  call matchadd("Contraction", English("She's"), 1)
  call matchadd("Contraction", English("It's"), 1)
  call matchadd("Contraction", English("let's"), 1)
  call matchadd("Contraction", English("[a-z]*'ve"), 1)
  call matchadd("Contraction", English("[a-z]*'ll"), 1)
  call matchadd("Contraction", English("[a-z]*n't"), 1)

  " From Wikipedia's list of Weasel Words
  highlight WeaselWord ctermbg=red ctermfg=white guibg=red guifg=white
  call matchadd("WeaselWord", English("reveal"), 1)
  call matchadd("WeaselWord", English("expose"), 1)
  call matchadd("WeaselWord", English("observe"), 1)
  call matchadd("WeaselWord", English("feel"), 1)
  call matchadd("WeaselWord", English("supposed"), 1)
  call matchadd("WeaselWord", English("alleged"), 1)
  call matchadd("WeaselWord", English("insist"), 1)
  call matchadd("WeaselWord", English("insisted"), 1)
  call matchadd("WeaselWord", English("maintain"), 1)
  call matchadd("WeaselWord", English("maintained"), 1)
  call matchadd("WeaselWord", English("purported"), 1)
  call matchadd("WeaselWord", English("naturally"), 1)
  call matchadd("WeaselWord", English("obviously"), 1)
  call matchadd("WeaselWord", English("clearly"), 1)
  call matchadd("WeaselWord", English("actually"), 1)
  call matchadd("WeaselWord", English("fundamentally"), 1)
  call matchadd("WeaselWord", English("essentially"), 1)
  call matchadd("WeaselWord", English("basically"), 1)
  call matchadd("WeaselWord", English("ironically"), 1)
  call matchadd("WeaselWord", English("amusingly"), 1)
  call matchadd("WeaselWord", English("unfortunately"), 1)
  call matchadd("WeaselWord", English("interestingly"), 1)
  call matchadd("WeaselWord", English("sadly"), 1)
  call matchadd("WeaselWord", English("tragically"), 1)

  " From wikipedia's list of time-sensitive words
  highlight TimeSensitive ctermbg=yellow ctermfg=blue guibg=yellow guifg=blue
  call matchadd("TimeSensitive", English("yesterday"), 1)
  call matchadd("TimeSensitive", English("today"), 1)
  call matchadd("TimeSensitive", English("tomorrow"), 1)
  call matchadd("TimeSensitive", English("recent"), 1)
  call matchadd("TimeSensitive", English("recently"), 1)
  call matchadd("TimeSensitive", English("current"), 1)
  call matchadd("TimeSensitive", English("currently"), 1)
  call matchadd("TimeSensitive", English("eventual"), 1)
  call matchadd("TimeSensitive", English("eventually"), 1)
  call matchadd("TimeSensitive", English("imminent"), 1)
  call matchadd("TimeSensitive", English("imminently"), 1)
  call matchadd("TimeSensitive", English("soon"), 1)

  " From wikipedia's list of Peacock terms
  highlight PeacockTerm ctermbg=yellow ctermfg=red guibg=yellow guifg=red
  call matchadd("PeacockTerm", English("good"), 1)
  call matchadd("PeacockTerm", English("bad"), 1)
  call matchadd("PeacockTerm", English("acclaimed"), 1)
  call matchadd("PeacockTerm", English("amazing"), 1)
  call matchadd("PeacockTerm", English("astonishing"), 1)
  call matchadd("PeacockTerm", English("beautiful"), 1)
  call matchadd("PeacockTerm", English("best"), 1)
  call matchadd("PeacockTerm", English("classic"), 1)
  call matchadd("PeacockTerm", English("defining"), 1)
  call matchadd("PeacockTerm", English("eminent"), 1)
  call matchadd("PeacockTerm", English("enigma"), 1)
  call matchadd("PeacockTerm", English("exciting"), 1)
  call matchadd("PeacockTerm", English("fabulous"), 1)
  call matchadd("PeacockTerm", English("famous"), 1)
  call matchadd("PeacockTerm", English("infamous"), 1)
  call matchadd("PeacockTerm", English("fantastic"), 1)
  call matchadd("PeacockTerm", English("fully"), 1)
  call matchadd("PeacockTerm", English("genius"), 1)
  call matchadd("PeacockTerm", English("global"), 1)
  call matchadd("PeacockTerm", English("greatest"), 1)
  call matchadd("PeacockTerm", English("iconic"), 1)
  call matchadd("PeacockTerm", English("immensely"), 1)
  call matchadd("PeacockTerm", English("impactful"), 1)
  call matchadd("PeacockTerm", English("incendiary"), 1)
  call matchadd("PeacockTerm", English("indisputable"), 1)
  call matchadd("PeacockTerm", English("influential"), 1)
  call matchadd("PeacockTerm", English("innovative"), 1)
  call matchadd("PeacockTerm", English("intriguing"), 1)
  call matchadd("PeacockTerm", English("leader"), 1)
  call matchadd("PeacockTerm", English("legendary"), 1)
  call matchadd("PeacockTerm", English("major"), 1)
  call matchadd("PeacockTerm", English("mature"), 1)
  call matchadd("PeacockTerm", English("memorable"), 1)
  call matchadd("PeacockTerm", English("pioneer"), 1)
  call matchadd("PeacockTerm", English("popular"), 1)
  call matchadd("PeacockTerm", English("prestigious"), 1)
  call matchadd("PeacockTerm", English("seminal"), 1)
  call matchadd("PeacockTerm", English("significant"), 1)
  call matchadd("PeacockTerm", English("single-handedly"), 1)
  call matchadd("PeacockTerm", English("staunch"), 1)
  call matchadd("PeacockTerm", English("talented"), 1)
  call matchadd("PeacockTerm", English("top"), 1)
  call matchadd("PeacockTerm", English("visionary"), 1)
  call matchadd("PeacockTerm", English("virtually"), 1)
  call matchadd("PeacockTerm", English("well-known"), 1)
  call matchadd("PeacockTerm", English("world-class"), 1)
  call matchadd("PeacockTerm", English("worst"), 1)
endfu

" http://pastebin.com/f46e9ffca
" toggle spellcheck and autocorrect
function! <SID>ToggleSpellCorrect()
    "if &spell
        "iabclear
    "else
        "runtime autocorrect.vim
    "endif
    setlocal spell! spell?
endfunction
map <silent><F12>       ;<C-U>call <SID>ToggleSpellCorrect()<CR>
vmap<silent><F12>       ;<C-U>call <SID>ToggleSpellCorrect()<CR>gv
imap<silent><F12>       <C-O>;call <SID>ToggleSpellCorrect()<CR>

" enter command mode without using shift key
noremap ; :
noremap : ;

" Settings for VimClojure
let vimclojure#HighlightBuiltins = 1
let vimclojure#ParenRainbow = 1


" Potentially dangerous, but useful at times - when vimrc is edited, reload it
"autocmd! bufwritepost vimrc source ~/.vim_runtime/vimrc

"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Remove the Windows ^M - when the encodings get messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Keep search matches in the middle of the window.
"nnoremap * *zzzv
"nnoremap # #zzzv
"nnoremap n nzzzv
"nnoremap N Nzzzv

set foldlevelstart=0

" Space to toggle folds. (commenting out because it messes with space = advance cursor)
"nnoremap <Space> za
"vnoremap <Space> za


"function! MyFoldText() " {{{
    "let line = getline(v:foldstart)

    "let nucolwidth = &fdc + &number * &numberwidth
    "let windowwidth = winwidth(0) - nucolwidth - 3
    "let foldedlinecount = v:foldend - v:foldstart

    "" expand tabs into spaces
    "let onetab = strpart('          ', 0, &tabstop)
    "let line = substitute(line, '\t', onetab, 'g')

    "let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    "let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    "return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
"endfunction " }}}
"set foldtext=MyFoldText()

" kill manual key.
nnoremap K <nop>


" Rename.vim  -  Rename a buffer within Vim and on the disk
"
" Copyright June 2007 by Christian J. Robinson <heptite@gmail.com>
"
" Distributed under the terms of the Vim license.  See ":help license".
"
" Usage:
"
" :Rename[!] {newname}
command! -nargs=* -complete=file -bang Rename :call Rename("<args>", "<bang>")

function! Rename(name, bang)
        let l:curfile = expand("%:p")
        let v:errmsg = ""
        silent! exe "saveas" . a:bang . " " . a:name
        if v:errmsg =~# '^$\|^E329'
                if expand("%:p") !=# l:curfile && filewritable(expand("%:p"))
                        silent exe "bwipe! " . l:curfile
                        if delete(l:curfile)
                                echoerr "Could not delete " . l:curfile
                        endif
                endif
        else
                echoerr v:errmsg
        endif
endfunction

" create buffer on `gf` if the file does not currently exist (slight
" modification from help file to accommodate colon remapping)
nnoremap gf :e <cfile><CR>

" function for working with files with hard line breaks
cabbr eighty call Eighty()
fun! Eighty()
  set textwidth=80                               " wrap to size characters
  set formatoptions+=a                           " automatically reformat when inserting or deleting
  let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1) " highlight any line > size characters
  colo neon
endfu

if has("mac") || has("gui_macvim") || has("gui_mac")
  source ~/conf/platforms/mac-10.6.3/etc/.vimrc
endif

if has("gui_gtk") || has("gui_gtk2") || has("gui_gnome") || has("unix")
  source ~/conf/platforms/ubuntu-10.04/etc/.vimrc
endif

