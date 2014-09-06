" vim: set ts=2 sw=2:
filetype off
execute pathogen#infect('bundle/{}', 'bundle-colorschemes/{}')

filetype plugin indent on
set nocompatible

set history=1000 " lines of history to remember
runtime macros/matchit.vim

set esckeys " no delay for ESC, but cannot use ESC as beginning of key sequence (which is fine by me)

highlight Pmenu guibg=brown gui=bold
syntax enable

set showcmd

set undolevels=1000 "maximum number of changes that can be undone
set laststatus=1    " always show statusline, unless one file present

" open split buffers below and to right instead of above and to left
set splitbelow
set splitright

" seems slow with ZSH and I don't get aliases either (probably due to my config)
set shell=bash

set number
set ignorecase
set is
set wrap
set visualbell " don't beep at me
set wildmode=longest,list " bash-style file completion

" The first few were defaults, but I want h and l to work between lines as well.
set whichwrap=b,s,<,>,[,],h,l
set hlsearch
set guicursor=a:blinkon0 " Set the cursor to not blink

set expandtab

set smarttab
set smartindent
set backupdir=~/.vim/tmp/backup// " change backup directory so backups don't go everywhere
set backup
set directory=~/.vim/tmp/swap//
set mouse=a " mouse support for terminal vim
set title " terminal title set to buffer name

set scrolloff=2 " leave a gap between bottom of window and cursor, if possible

set synmaxcol=200 " vim is often slow with long lines that are syntax highlighted, so limit to 200 characters in length

set guioptions-=r " remove sidebars
set guioptions-=L " remove sidebars

set foldmethod=syntax
set foldlevelstart=0
set nofoldenable      " disable folding


" ctrl-p plugin
let g:ctrlp_match_window_bottom=0 " put at top
let g:ctrlp_match_window_reversed=0 " reverse order of items

let g:closetag_html_style=1
"source ~/.vim/closetag.vim

" would need to change for linux or when I update LanguageTool version
let g:languagetool_jar = '/usr/local/Cellar/languagetool/2.2/libexec/languagetool-commandline.jar'
let g:languagetool_disable_rules = 'WHITESPACE_RULE,EN_QUOTES'

let g:NERDShutUp=1



fun! Wp()
  set nonumber              " remove line numbering when writing
  set spell spelllang=en_us " enable spell checking
  set linebreak             " break soft-wrapped lines at word boundaries
  set nojoinspaces          " when joining paragraphs, separate by one space
  set nolist                " linebreak command relies on list being off :(
  set display=lastline      " show the last line on the screen even if it doesn't fit,
                            " which is common for long lines when writing

  " get autocorrections
  call AutoCorrect()

  " move about as if soft-wrapped lines were actual lines
  nnoremap j gj
  nnoremap k gk
  nnoremap 0 g0
  nnoremap $ g$

  " set up a more readable font when writing mode invoked
  if has("gui_gtk") || has("gui_gtk2") || has("gui_gnome")
    set guifont=Inconsolata\ 16
  elseif has("gui_macvim") || has("gui_mac")
    set guifont=Inconsolata:h20
  elseif has("gui_win32")
    set guifont=Inconsolata:h16
  end

  " highlight double words ("word word")
  syn match doubleWord "\c\<\(\a\+\)\_s\+\1\>"
  hi def link doubleWord Error
endfu

fun! BasicAbbreviations()
  iabbrev wrt with respect to
  iabbrev otoh on the other hand
  iabbrev btw by the way
  iabbrev Wrt With respect to
  iabbrev Otoh On the other hand
  iabbrev Btw By the way
  iabbrev imo in my opinion
  iabbrev Imo in my opinion

  " I commonly fat-finger these ruby commands
  iabbrev 3nd end
  iabbrev ned end
  iabbrev od do
  iabbrev p[ []

  " some spelling mistakes not (yet) caught by autocorrect.vim
  iabbrev testamonial testimonial
  iabbrev testamonials testimonials
  iabbrev Testamonial Testimonial
  iabbrev Testamonials Testimonials

  iabbrev soultion solution
  iabbrev soultions solutions
  iabbrev Soultion Solution
  iabbrev Soultions Solutions

  iabbrev facililty facility
  iabbrev facilty facility

  iabbrev prenset present
  iabbrev Prenset Present

  iabbrev everythign everything
  iabbrev Everythign Everything

  iabbrev propogated propagated
  iabbrev Propogated Propagated

  iabbrev defecit deficit
  iabbrev Defecit Deficit
  
  iabbrev migth might
  iabbrev Migth Might

  " programming expansions
  iabbrev _pry require 'pry'; binding.pry
  iabbrev _fgc FactoryGirl.create
  iabbrev _fgb FactoryGirl.build
  iabbrev _saop save_and_open_page

  " Some helpful shortcuts
  iabbrev dtt <C-R>=strftime("%F")<CR>
  iabbrev dts <C-R>=strftime("%F %H%M")<CR>
  iabbrev dtsiso <C-R>=strftime("%FT%T%z")<CR>
  iabbrev dtsrfc <C-R>=strftime("%a, %d %b %Y %H:%M:%S %z")<CR>
endfu
call BasicAbbreviations()



cabbr cdhere cd %:p:h
cabbr mkdirhere !mkdir -p %:h

cabbr autocommit call Autocommit()
fun! Autocommit()
  au BufWritePost * silent !git add <afile>
  au BufWritePost * silent !git commit <afile> -m 'Generated commit'
endfu

" does not work? trying to remove surround parens and add a space
nnoremap <leader>p ds(i

" show kill ring list
nnoremap <leader>y :YRShow<CR>

" show only this fold section
nnoremap <leader>z zMzv

" copy current file name (relative/absolute) to system clipboard
if has("mac") || has("gui_macvim") || has("gui_mac")
  " relative path  (src/foo.txt)
  nnoremap <leader>cf :let @*=expand("%")<CR>

  " relative path  (src/foo.txt)
  nnoremap <leader>cf :let @*=expand("%")<CR>

  " absolute path  (/something/src/foo.txt)
  nnoremap <leader>cF :let @*=expand("%:p")<CR>

  " filename       (foo.txt)
  nnoremap <leader>ct :let @*=expand("%:t")<CR>

  " directory name (/something/src)
  nnoremap <leader>ch :let @*=expand("%:p:h")<CR>
endif
if has("gui_gtk") || has("gui_gtk2") || has("gui_gnome") || has("unix")
  " relative path  (src/foo.txt)
  nnoremap <leader>cf :let @+=expand("%")<CR>

  " absolute path  (/something/src/foo.txt)
  nnoremap <leader>cF :let @+=expand("%:p")<CR>

  " filename       (foo.txt)
  nnoremap <leader>ct :let @+=expand("%:t")<CR>

  " directory name (/something/src)
  nnoremap <leader>ch :let @+=expand("%:p:h")<CR>
endif

" make current file executable
nnoremap <leader>x :! chmod +x %<CR>

" Jekyll shortcuts
nnoremap <leader>jp :! ./scripts/preview %<CR> " preview jekyll post in browser


" latex-suite
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat="pdf"

" these should be in another file, but don't care for now

" should also move things from vim72/** that I added into my personal .vim directory
autocmd BufReadPost * if getline(2) =~ "This is the personal log of Anthony.  Please stop reading unless you are Anthony." | call Wp() | endif

autocmd BufRead,BufNewFile *.txt set filetype=conf
autocmd BufRead,BufNewFile {Capfile,Gemfile,Rakefile,Thorfile,config.ru,.caprc,.irbrc,irb_tempfile*,Vagrantfile} set ft=ruby
autocmd FileType conf set foldmethod=manual
autocmd BufRead,BufNewFile *.less setfiletype less

" Don't expand tab in Makefiles
autocmd FileType make set noexpandtab

" Use the javascript syntax highlighting for JSON files
autocmd BufNewFile,BufRead *.json set ft=javascript
autocmd BufNewFile,BufRead *.plist set ft=xml
autocmd BufRead,BufNewFile *.erb set filetype=eruby.html
autocmd BufRead,BufNewFile *.scss set filetype=scss

" fabricator file shortcut
autocmd User Rails Rnavcommand fabricator spec/fabricators -suffix=_fabricator.rb -default=model()

" Ctrl+W, Alt+W to kill word backward in insert mode (like other apps)
inoremap <C-BS> <C-W>
inoremap <A-BS> <C-W>
" Ctrl+W, Alt+W to kill word backward in command mode
cnoremap <C-BS> <C-W>
cnoremap <A-BS> <C-W>

" Command-T overrides
let g:CommandTMatchWindowAtTop = 1 " want the best command-t matches at the top so they never move
let g:CommandTMaxHeight = 8 " only show a few lines for the output

" quicker way to flush the queue
nnoremap <leader>T <Esc>:CommandTFlush<CR>

" on file load, go to the last known cursor position if it is valid
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" |
  \ endif

function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
nnoremap <leader>l :PromoteToLet<cr>

nnoremap <leader>w :%s/\s\+$//<cr>

function! SetExecutableBit()
  let fname = expand("%:p")
  checktime
  execute "au FileChangedShell " . fname . " :echo"
  silent !chmod a+x %
  checktime
  execute "au! FileChangedShell " . fname
endfunction
command! Xbit call SetExecutableBit()

" via: http://whynotwiki.com/Vim
" Ruby
" Use v or # to get a variable interpolation (inside of a string)}
" ysiw#   Wrap the token under the cursor in #{}
" v...s#  Wrap the selection in #{}
let g:surround_113 = "#{\r}"   " v
let g:surround_35  = "#{\r}"   " #


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

"""""""""""""""""""""""""""""""""""
" some additional things I added to be more consistent with other
" tab/window-like applications
" CTRL-Shift-Tab is Previous window
noremap <C-S-Tab> <C-W>W
inoremap <C-S-Tab> <C-O><C-W>W
cnoremap <C-S-Tab> <C-C><C-W>W
onoremap <C-S-Tab> <C-C><C-W>W

nnoremap Y y$
nnoremap D d$
nnoremap du :diffupdate<CR>

" When on command-line or search, Ctrl+A goes to beginning of line (like every
" other Mac and Unix mapping.)
cnoremap <C-A> <Home>


" Toggle trailing whitespace highlighting with leader + s  (default on)
set listchars=tab:>-,trail:· ",eol:$
nmap <silent> <leader>s ;set nolist!<CR>
set list

set wildignore=*.o,*.class,*.png,*.pdf,*.ps,*.gif,*.jpg,*.aux,*.toc,*.cod,*.bak,*.mp3,*.m4a,*.wmv,*.mpg,*.mov,*.doc,*.bc
set wildignore+=vendor/rails/**
set wildignore+=build/android  " Titanium

" Enable automatic spell checking for txt and tex files
let spell_auto_type="tex,txt"

" Highlight common debugging statements that should not be committed (one
" layer of protection, at least)
" http://stackoverflow.com/questions/11269066/toggling-a-match-in-vimrc
"highlight Debugging ctermbg=yellow ctermfg=blue guibg=yellow guifg=blue
"highlight link MaybeDebugging Debugging
"" could make these specific to the language used (filetype) but fine for now
"call matchadd("MaybeDebugging", "debugger")
"call matchadd("MaybeDebugging", "puts")
"call matchadd("MaybeDebugging", "show me the page")
"call matchadd("MaybeDebugging", "and I debug")
"call matchadd("MaybeDebugging", "console.log")
"call matchadd("MaybeDebugging", "console.dir")
"call matchadd("MaybeDebugging", "alert")

"function TurnOnDebuggingMatching()
"  highlight link MaybeDebugging Debugging
"  let s:hilightdebugging = 1
"endfunction
"
"function TurnOffDebuggingMatching()
"  highlight link MaybeDebugging NONE
"  let s:hilightdebugging = 0
"endfunction
"
"function ToggleDebuggingMatching()
"  if s:hilightdebugging
"    call TurnOffDebuggingMatching()
"  else
"    call TurnOnDebuggingMatching()
"  endif
"endfunction
"
"nnoremap <leader>d :call ToggleDebuggingMatching()<CR>

"call TurnOnDebuggingMatching()

" Colorscheme stuff
function! RandomColorscheme()
  " random color, from http://vim.1045645.n5.nabble.com/Random-color-scheme-at-start-td1165585.html
  let mycolors = split(globpath(&rtp,"**/colors/*.vim"),"\n")
  let i = localtime() % len(mycolors)
  exe 'so ' . mycolors[i]
  unlet mycolors
  highlight clear SignColumn " important for vim-gitgutter plugin to not look strange
  "if s:hilightdebugging
  "  call TurnOnDebuggingMatching()  " restore my custom debugging highlighting if we were using it
  "endif

  " set autocomplete popup menu to somewhat readable color
  " (some color schemes have bad default here)
  highlight Pmenu guibg=black guifg=lightmagenta
  highlight Pmenusel guibg=lightmagenta guifg=black
endfunction

let g:gitgutter_eager = 0 " prevent reload of all buffers on window focus (which takes a long time)

nnoremap <leader>co <Esc>:call RandomColorscheme()<CR>

nnoremap <leader>h :highlight clear SignColumn<CR>




" Turns an word into a regex to match that word
function! English(word)
  " Case-insensitive, and properly bounded.
  return '\c\<' . a:word . '\>'
endfunction

" For proofreading.
" From the bottom of http://www.cs.princeton.edu/~npjohnso/dot.vimrc
function! Proofreading()
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
endfunction

" http://pastebin.com/f46e9ffca
" toggle spellcheck and autocorrect
function! <SID>ToggleSpellCorrect()
    if &spell
        iabclear
        call BasicAbbreviations()
    else
        call AutoCorrect()
    endif
    setlocal spell! spell?
endfunction
map <silent><F12>       ;<C-U>call <SID>ToggleSpellCorrect()<CR>
vmap<silent><F12>       ;<C-U>call <SID>ToggleSpellCorrect()<CR>gv
imap<silent><F12>       <C-O>;call <SID>ToggleSpellCorrect()<CR>

" enter command mode without using shift key
noremap ; :
noremap : ;

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
noremap <Leader>mm mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm


" for lining cucumber tables up
" see https://github.com/tpope/vim-cucumber/issues/4
" see https://gist.github.com/287147
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
nnoremap <leader>a :call <SID>align()<CR>
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" http://vim.wikia.com/wiki/Switching_case_of_characters
" highlight text and press ~ to twiddle
function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction
vnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv

" When editing git commit message, go to top of the file (forgetting any saved
" positions)
autocmd BufReadPost COMMIT_EDITMSG exe "normal! gg"
" Same for `hub pull-request` file name
autocmd BufReadPost PULLREQ_EDITMSG exe "normal! gg"

" Convert Ruby 1.8 hash rockets to 1.9 JSON style hashes.
" Based on https://github.com/hashrocket/dotmatrix/commit/6c77175adc19e94594e8f2d6ec29371f5539ceeb
" from https://github.com/henrik/dotfiles/commit/aaa45c1cc0f9a6195a9155223a7e904aa10b256f
command! -bar -range=% NotRocket execute '<line1>,<line2>s/:\(\w\+\)\s*=>/\1:/e' . (&gdefault ? '' : 'g')

nnoremap <leader>9 :NotRocket<CR>

" kill manual key.
nnoremap K <nop>

" create buffer on `gf` if the file does not currently exist (slight
" modification from help file to accommodate colon remapping)
nnoremap gf :e <cfile><CR>

set formatoptions+=j " 'Where it makes sense, remove a comment leader when joining lines.'

" For working with soft-wrapped files [experimental]
" Anywhere on sentence, take that sentence and make it the first of a new paragraph
nnoremap <leader>s} )(i<BS><CR><CR><ESC>
" Anywhere on sentence, take that sentence and make it the last of this paragraph
nnoremap <leader>s{ ()i<BS><CR><CR><ESC>
" Join this paragraph with the previous paragraph
nnoremap <leader>j{ {k3J
" Join this paragraph with the next paragraph
nnoremap <leader>j} 3J

" function for working with files with hard line breaks
cabbr eighty call Eighty()
fun! Eighty()
  set textwidth=80                               " wrap to size characters
  set formatoptions+=a                           " automatically reformat when inserting or deleting
  let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1) " highlight any line > size characters
  colo neon
endfu

if has("mac") || has("gui_macvim") || has("gui_mac")
  source ~/conf/platforms/mac-10.8.2/etc/.vimrc
endif

if has("gui_gtk") || has("gui_gtk2") || has("gui_gnome") || has("unix")
  source ~/conf/platforms/ubuntu-10.04/etc/.vimrc
endif

if &l:diff
  colors peachpuff
  set diffopt+=iwhite   " ignore whitespace differences for diff
else
  if !exists("g:randomizedColorsOnStart")
    call RandomColorscheme()
  endif
  let g:randomizedColorsOnStart=1
endif

" see https://coderwall.com/p/ozhuxg
function! PasteAsCoffee()
  read !pbpaste | js2coffee
endfunction
command! PasteAsCoffee :call PasteAsCoffee()
nnoremap <leader>pc :PasteAsCoffee<CR>

comma! -nargs=1 Silent
      \ | execute ':silent !'.<q-args>
      \ | execute ':redraw!'

" Well, I never thought it would come to this, but... emacs-like bindings.
" Pulled from https://github.com/maxbrunsfeld/vim-emacs-bindings.

function! KillLine()
  let [text_before_cursor, text_after_cursor] = SplitLineTextAtCursor()
  if len(text_after_cursor) == 0
    normal! dd
  else
    normal! d$
  endif
  return ''
endfunction

function! SplitLineTextAtCursor()
  let line_text = getline(line('.'))
  let text_after_cursor  = line_text[col('.')-1 :]
  let text_before_cursor = (col('.') > 1) ? line_text[: col('.')-2] : ''
  return [text_before_cursor, text_after_cursor]
endfunction

inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <M-b> <C-o>b
inoremap <M-f> <C-o>e<Right>
inoremap <C-d> <Del>
inoremap <M-d> <C-o>de
inoremap <M-h> <C-w>

" Already seems to work
"inoremap <C-h> <BS>
" These actually have somewhat useful bindings and I want to not be in insert mode
"inoremap <C-a> <C-o>:call <SID>home()<CR>
"inoremap <C-e> <End>
" Would mess with digraphs
"inoremap <C-k> <C-r>=<SID>kill_line()<CR>

nnoremap <C-k> :call KillLine()<CR>
nnoremap <C-x><C-o> <C-W><C-W>
nnoremap <C-x><C-2> :vsplit
nnoremap <C-x><C-3> :split
