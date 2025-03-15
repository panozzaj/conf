" vim: set ts=2 sw=2:
set nocompatible

runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect('bundle/{}', 'bundle-colorschemes/{}')

filetype plugin indent on

set history=1000 " lines of history to remember
runtime macros/matchit.vim

if !has('nvim')
    set esckeys " no delay for ESC, but cannot use ESC as beginning of key sequence (which is fine by me)
endif

highlight Pmenu guibg=brown gui=bold

set showcmd

" otherwise neovim doesn't find undos across sessions
set undodir=~/.vim/undodir
set undofile

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

" see https://github.com/macvim-dev/macvim/issues/562
if has('python3')
  command! -nargs=1 Py py3 <args>
"  set pythonthreedll=/usr/local/Frameworks/Python.framework/Versions/3.7/Python
"  set pythonthreehome=/usr/local/Frameworks/Python.framework/Versions/3.7
else
  command! -nargs=1 Py py <args>
"  set pythondll=/usr/local/Frameworks/Python.framework/Versions/2.7/Python
"  set pythonhome=/usr/local/Frameworks/Python.framework/Versions/2.7
endif

" https://github.com/vim-python/python-syntax
let g:python_highlight_all = 1

set scrolloff=2 " leave a gap between bottom of window and cursor, if possible

set synmaxcol=200 " vim is often slow with long lines that are syntax highlighted, so limit to 200 characters in length

set guioptions-=r " remove sidebars
set guioptions-=L " remove sidebars

set foldlevelstart=0
set nofoldenable      " disable folding

" Use project-specific .vimrc files
" https://robots.thoughtbot.com/opt-in-project-specific-vim-spell-checking-and-word-completion
set exrc
set secure

let g:gutentags_ctags_exclude = ['node_modules']

" Allow netrw to remove non-empty local directories
let g:netrw_local_rmdir='rm -r'
" https://gist.github.com/t-mart/610795fcf7998559ea80
autocmd FileType netrw nnoremap ? :help netrw-quickmap<CR>

let mapleader = "\<Space>"

let g:closetag_html_style=1
"source ~/.vim/closetag.vim

let g:NERDShutUp=1

" Don't continually check for lint errors, just when we save the buffer
" (minimizes random things popping up, CPU usage)
let g:ale_lint_on_text_changed = 'never'

" Don't run linters when opening a file (minimize startup time)
let g:ale_lint_on_enter = 0

" Better lint message symbols
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '!'

" Configure prettier support
let g:ale_fixers = {
\ 'scss': ['prettier'],
\ 'javascript': ['prettier'],
\ 'typescript': ['prettier'],
\ 'typescriptreact': ['prettier'],
\ 'css': ['prettier'],
\ 'python': ['black'],
\}

" see https://www.anthonygonzales.dev/blog/setup-eslint-prettier-with-typescript.html
let g:ale_linters = {}
let g:ale_linters.typescript = ['eslint', 'tsserver']

" Run 'fix' commands after saving files
let g:ale_fix_on_save = 1

" Avoid printing linter issues in "comments" to the right of the line, which
" was obtrusive to me. Could also use 'current', but I typically just look at
" the status text to see longer linter errors.
" https://github.com/dense-analysis/ale/commit/300ea232de003f5ce45549be85d5da7f84fe23b0
let g:ale_virtualtext_cursor = 'disabled'

" sort highlighted lines alphabetically (imports / parameters / lists)
vnoremap <leader>s :sort<CR>

" Enable Copilot for certain filetypes
" See https://github.com/orgs/community/discussions/38074
let g:copilot_filetypes = {
\ 'eruby': v:true,
\ 'markdown': v:true,
\ 'rspec': v:true,
\ 'rspec.ruby': v:true,
\ 'gitcommit': v:true,
\}

" Disable Copilot for large files (see https://codeinthehole.com/tips/vim-and-github-copilot/)
autocmd BufReadPre *
\ let f=getfsize(expand("<afile>"))
\ | if f > 100000 || f == -2
\ | let b:copilot_enabled = v:false
\ | endif

" Disable Copilot for certain filename patterns
autocmd BufReadPre *
\ if expand("%:t") =~# '\.min\.' ||
\    expand("%:t") =~# '\.minified\.' ||
\    expand("%:t") =~# '\.min\.js$' ||
\    expand("%:t") =~# '\.minified\.js$' ||
\    expand("%:t") =~# '^\.env$' ||
\    expand("%:t") =~# '.pem$'
\ | let b:copilot_enabled = v:false
\ | endif

function! Wp()
  setlocal nonumber              " remove line numbering when writing
  setlocal spell spelllang=en_us " enable spell checking
  setlocal linebreak             " break soft-wrapped lines at word boundaries
  setlocal nojoinspaces          " when joining paragraphs, separate by one space
  setlocal nolist                " linebreak command relies on list being off :(
  setlocal display=lastline      " show the last line on the screen even if it doesn't fit,
                            " which is common for long lines when writing

  " Don't count acronyms as spelling errors (all upper-case letters, at least
  " three characters)
  " Also will not count acronym with 's' at the end a spelling error
  " Also will not count numbers that are part of this
  syntax match AcronymNoSpell '\<\(\u\|\d\)\{3,}s\?\>' contains=@NoSpell

  " Don't count url-ish things as spelling errors
  syntax match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell

  " get autocorrections
  call AutoCorrect()

  " move about as if soft-wrapped lines were actual lines
  nnoremap j gj
  nnoremap k gk
  nnoremap 0 g0
  nnoremap ^ g0
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

function! BasicAbbreviations()
  iabbrev wrt with respect to
  iabbrev otoh on the other hand
  iabbrev btw by the way
  iabbrev Wrt With respect to
  iabbrev Otoh On the other hand
  iabbrev Btw By the way
  iabbrev imo in my opinion
  iabbrev Imo in my opinion

  " Woven words
  iabbrev acndidate candidate
  iabbrev acndidates candidates
  iabbrev canidate candidates
  iabbrev canidates candidates
  iabbrev caniddate candidate
  iabbrev caniddates candidates
  iabbrev cnadidate candidate
  iabbrev cnadidates candidates

  iabbrev simulaiton simulation
  iabbrev simulaitons simulations

  iabbrev asessment assessment
  iabbrev asessments assessments
  iabbrev assesment assessment
  iabbrev assesments assessments

  " I commonly fat-finger these ruby commands
  iabbrev 3nd end
  iabbrev ned end
  iabbrev od do
  iabbrev p[ []
  iabbrev retrun return
  iabbrev retunr return
  iabbrev retunr return
  iabbrev retun return
  iabbrev done(): done();
  iabbrev }): });
  iabbrev lenght length
  iabbrev hae have
  iabbrev tht that
  iabbrev slef self
  iabbrev prsent present
  iabbrev presnet present
  iabbrev presetn present
  iabbrev prsent? present?
  iabbrev presnet? present?
  iabbrev presetn? present?

  " some spelling mistakes not (yet) caught by autocorrect.vim
  " or custom corrections that I wouldn't want to put in there
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

  iabbrev kidn kind
  iabbrev Kidn Kind

  iabbrev flaneur flâneur

  iabbrev differnet different
  iabbrev Differnet Different

  iabbrev postiives positives

  " Some helpful shortcuts
  iabbrev dtt <C-R>=strftime("%F")<CR>
  iabbrev dts <C-R>=strftime("%F %H%M")<CR>
  iabbrev dtsiso <C-R>=strftime("%FT%T%z")<CR>
  iabbrev dtsrfc <C-R>=strftime("%a, %d %b %Y %H:%M:%S %z")<CR>
endfu
call BasicAbbreviations()



cabbr cdhere cd %:p:h

cabbr autocommit call Autocommit()
fun! Autocommit()
  au BufWritePost * silent !git add <afile>
  au BufWritePost * silent !git commit <afile> -m 'Generated commit'
endfu

" delete surrounding braces in function/method declarations
nmap <leader>dp csbs
" could also be cs(s, etc.

" show only this fold section
nnoremap <leader>z zMzv

" copy current file name (relative/absolute) to system clipboard
if has("mac") || has("gui_macvim") || has("gui_mac")
  " relative path  (src/foo.txt)
  nnoremap <leader>cfr :let @*=expand("%")<CR>

  " absolute path  (/something/src/foo.txt)
  nnoremap <leader>cfa :let @*=expand("%:p")<CR>

  " filename       (foo.txt)
  nnoremap <leader>cff :let @*=expand("%:t")<CR>

  " directory name (/something/src)
  nnoremap <leader>cfd :let @*=expand("%:p:h")<CR>
endif

if has("gui_gtk") || has("gui_gtk2") || has("gui_gnome") || has("unix")
  " relative path  (src/foo.txt)
  nnoremap <leader>cfr :let @+=expand("%")<CR>

  " absolute path  (/something/src/foo.txt)
  nnoremap <leader>cfa :let @+=expand("%:p")<CR>

  " filename       (foo.txt)
  nnoremap <leader>cff :let @+=expand("%:t")<CR>

  " directory name (/something/src)
  nnoremap <leader>cfd :let @+=expand("%:p:h")<CR>
endif

" make current file executable
nnoremap <leader>x :call SetExecutableBit()<CR>

" see http://vim.wikia.com/wiki/Setting_file_attributes_without_reloading_a_buffer
function! SetExecutableBit()
  let fname = expand("%:p")
  checktime
  execute "au FileChangedShell " . fname . " :echo"
  silent !chmod a+x %
  checktime
  execute "au! FileChangedShell " . fname
  echo ' '
  echo 'File is now executable.'
endfunction
command! Xbit call SetExecutableBit()

command! Vimrc vsp ~/.vimrc
command! Vvimrc vsp ~/.vimrc
command! Svimrc sp ~/.vimrc

" Word transposition. Lifted from:
" http://superuser.com/questions/290360/how-to-switch-words-in-an-easy-manner-in-vim/290449#290449

" exchange word under cursor with the next word without moving the cursor
nnoremap gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o><C-l>

" move the current word to the right and keep the cursor on it
nnoremap ]w "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o>/\w\+\_W\+<CR><C-l>

" move the current word to the left and keep the cursor on it
nnoremap [w "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o><C-l>


" Jekyll shortcuts
nnoremap <leader>jp :! ./scripts/preview %<CR> " preview jekyll post in browser

" Markdown links (visual mode)
" link (url is in clipboard)
vnoremap <leader>lu <Esc>`>a](<C-r>*)<C-o>`<[<Esc>f)
" link (disregard clipboard)
vnoremap <leader>ll <Esc>`>a]()<C-o>`<[<Esc>f)

"nnoremap <leader>e :Errors<CR><C-W><C-W>
nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>

" HTML tag closing and reindenting
iabbrev </ </<C-X><C-O><ESC>==A

" latex-suite
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat="pdf"

" highlight the search match
let g:ag_highlight=1
let g:ag_prg="ag -i --vimgrep"

" see http://learnvimscriptthehardway.stevelosh.com/chapters/14.html
augroup panozzaj_group
  autocmd!

  autocmd BufNewFile,BufRead *.txt set filetype=text
  autocmd BufNewFile,BufRead *.less set filetype=less
  autocmd BufNewFile,BufRead *_spec.rb set filetype=rspec.ruby
  autocmd BufNewFile,BufRead *_factory.rb set filetype=rspec.ruby
  autocmd BufNewFile,BufRead *.json set filetype=javascript
  autocmd BufNewFile,BufRead *.plist set filetype=xml
  autocmd BufNewFile,BufRead *.scss set filetype=scss

  autocmd FileType conf set foldmethod=manual
  autocmd FileType less set omnifunc=csscomplete#CompleteCSS
  autocmd FileType make set noexpandtab " Don't expand tab in Makefiles

  autocmd FileType json setlocal tabstop=2 shiftwidth=2

  " on file load, go to the last known cursor position if it is valid
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \ exe "normal g`\"" |
    \ endif
augroup END

augroup commit_message_overrides
   autocmd!
  " When editing git commit message, go to top of the file
  " (forget any saved positions)
  autocmd BufReadPost COMMIT_EDITMSG exe "normal! gg"
  " Same for `hub pull-request` file name
  autocmd BufReadPost PULLREQ_EDITMSG exe "normal! gg"
augroup END

function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
nnoremap <leader>l :PromoteToLet<cr>

" via: http://whynotwiki.com/Vim
" Ruby
" Use v or # to get a variable interpolation (inside of a string)}
" ysiw#   Wrap the token under the cursor in #{}
" v...s#  Wrap the selection in #{}
let g:surround_113 = "#{\r}"   " v
let g:surround_35  = "#{\r}"   " #


" these are mostly defaults, except for flipping the open order
" to match my split opening order (splitbelow, splitright)
" see https://github.com/mileszs/ack.vim/blob/master/doc/ack.txt
" TODO: actually make changes
"let g:ack_mappings = {
"      \ "t": "<C-W><CR><C-W>T",
"      \ "T": "<C-W><CR><C-W>TgT<C-W>j",
"      \ "o": "<CR>",
"      \ "O": "<CR><C-W><C-W>:ccl<CR>",
"      \ "go": "<CR><C-W>j",
"      \ "h": "<C-W><CR><C-W>K",
"      \ "H": "<C-W><CR><C-W>K<C-W>b",
"      \ "v": "<C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t",
"      \ "gv": "<C-W><CR><C-W>H<C-W>b<C-W>J" }

" Use CTRL-Q to enter block selection mode
noremap <C-Q>           <C-V>

" CTRL-Tab is next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w

" CTRL-Shift-Tab is previous window
noremap <C-S-Tab> <C-W>W
inoremap <C-S-Tab> <C-O><C-W>W
cnoremap <C-S-Tab> <C-C><C-W>W
onoremap <C-S-Tab> <C-C><C-W>W

nnoremap Y y$
nnoremap D d$
nnoremap du :diffupdate<CR>

set listchars=tab:>-,trail:·
set list

" trim trailing whitespace from file
" see https://vi.stackexchange.com/a/456
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
command! TrimWhitespace call TrimWhitespace()

" Otherwise I get duplicate entries in netrw when combined with vim-vinegar
" See https://github.com/tpope/vim-vinegar/issues/27
let g:netrw_fastbrowse=0

" Quickly open split in current file's directory
"nnoremap <leader>s :sp %:h/.<CR>
"nnoremap <leader>v :vsp %:h/.<CR>

" Quickly open split of current file
nnoremap <leader>s :sp<CR>
nnoremap <leader>v :vsp<CR>

" Only enable normal mode functions. Otherwise, since my leader is currently
" space, we insert random stuff on space or have delays after typing space.
" Another approach could be using :imap <leader> to list insert mode things
" and remapping them manually instead. It doesn't seem possible with current
" emmet.vim code to configure one leader in insert mode and another in normal
" mode.
let g:user_emmet_mode='n'

" Mnemonic: emmet
let g:user_emmet_leader_key='<leader>e'
" Mnemonic: emmet expand (also easily hittable)
let g:user_emmet_expandabbr_key = '<leader>ee'

let g:user_emmet_settings = {
  \  'javascript.jsx' : {
  \      'extends' : 'jsx',
  \      'quote_char': "'",
  \  },
  \  'html' : {
  \    'quote_char': "'",
  \  },
  \}

" for fzf.vim
set rtp+=/opt/homebrew/bin/fzf

" Default key bindings, plus ctrl+s to be like other fuzzy finders
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

nnoremap <leader>t :GFiles<CR>

" recent files
nnoremap <leader>R :History<CR>

" Command-T also uses these
" Should not ignore files I might want to normally open
"set wildignore=*.o,*.class,*.png,*.pdf,*.ps,*.gif,*.jpg,*.aux,*.toc,*.cod,*.bak,*.mp3,*.m4a,*.wmv,*.mpg,*.mov,*.doc,*.bc
"set wildignore+=*/vendor/rails
"set wildignore+=*/node_modules  " npm
"set wildignore+=*/.git          " vcs
"let g:netrw_banner = 1  " https://github.com/tpope/vim-vinegar/issues/97
"let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

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

" set autocomplete popup menu to somewhat readable color
" (some color schemes have bad default here)
function! ResetPopupMenu()
  highlight Pmenu guibg=black guifg=lightmagenta
  highlight Pmenusel guibg=lightmagenta guifg=black
endfunction


function! RandomColorscheme()
  if !exists("g:randomColorschemeCalled")
    let g:randomColorschemeCalled = 0
  endif

  " Get all colorschemes
  let mycolors = split(globpath(&rtp,"**/colors/*.vim"),"\n")

  " Select a random colorscheme
  let i = localtime() % len(mycolors)
  let chosen_colorscheme = fnamemodify(mycolors[i], ':t:r')
  exe 'so ' . mycolors[i]
  unlet mycolors

  " Only echo if we've already called this function once
  " (otherwise we see on startup)
  if g:randomColorschemeCalled
    redraw
    echo "Applied colorscheme: " . chosen_colorscheme
  endif

  let g:randomColorschemeCalled = 1

  highlight clear SignColumn " important for vim-gitgutter plugin to not look strange

  call ResetPopupMenu()
endfunction


let g:niji_matching_filetypes = ['javascript']

" see http://ctoomey.com/posts/an-incremental-approach-to-vim/#know-your-leader
function! ListLeaders()
     silent! redir @a
     silent! nmap <LEADER>
     silent! redir END
     silent! new
     silent! put! a
     silent! g/^s*$/d
     silent! %s/^.*,//
     silent! normal ggVg
     silent! sort
     silent! let lines = getline(1,"$")
endfunction
nnoremap <leader>\ :call ListLeaders()<CR>

let g:gitgutter_eager = 0 " prevent reload of all buffers on window focus (which takes a long time)

nnoremap <leader>co <Esc>:call RandomColorscheme()<CR>

" enter command mode without using shift key
noremap ; :
noremap : ;

" Apply macro to current visual mode selection
" https://github.com/stoeffel/.dotfiles/blob/master/vim/visual-at.vim
" from https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction


" In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

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

" Convert Ruby 1.8 hash rockets to 1.9 JSON style hashes.
" Based on https://github.com/hashrocket/dotmatrix/commit/6c77175adc19e94594e8f2d6ec29371f5539ceeb
" from https://github.com/henrik/dotfiles/commit/aaa45c1cc0f9a6195a9155223a7e904aa10b256f
command! -bar -range=% NotRocket execute '<line1>,<line2>s/:\(\w\+\)\s*=>/\1:/e' . (&gdefault ? '' : 'g')

function! PrettyJSON()
  :%!python -m json.tool
endfunction
:command! PrettyJSON :call PrettyJSON()

" https://github.com/reedes/vim-litecorrect#correct-previous-misspelling
nnoremap <C-s> [s1z=<c-o>
inoremap <C-s> <c-g>u<Esc>[s1z=`]A<c-g>u

nnoremap <leader>9 :NotRocket<CR>

" kill manual key and replace with Ag search
nnoremap K :Ag! <cword><cr>
vnoremap K :<C-u>call VisualSelectionSearch()<CR>

function! VisualSelectionSearch()
    " Save the current contents of the register and its type
    let l:originalReg = getreg('"')
    let l:originalRegType = getregtype('"')

    " Yank the visually selected text into the unnamed register without newlines
    normal! gv"xy

    " Escape special characters for the search pattern
    let l:searchTerm = escape(@x, '\')

    " Build and execute the Ag command with the yanked text
    execute "Ag! " . shellescape(l:searchTerm, 1)

    " Restore the original contents and type of the unnamed register
    call setreg('"', l:originalReg, l:originalRegType)
endfunction

" create buffer on `gf` if the file does not currently exist (slight
" modification from help file to accommodate colon remapping)
nnoremap gf :e <cfile><CR>

" For working with soft-wrapped files [experimental]
" Anywhere on sentence, take that sentence and make it the first of a new paragraph
"nnoremap <leader>s} )(i<BS><CR><CR><ESC>
" Anywhere on sentence, take that sentence and make it the last of this paragraph
"nnoremap <leader>s{ ()i<BS><CR><CR><ESC>
" Join this paragraph with the previous paragraph
nnoremap <leader>j{ {k3J
" Join this paragraph with the next paragraph
nnoremap <leader>j} 3J

"nnoremap <leader>rt :! grunt --no-color test:e2e --specs=% --no-colors<CR>

nnoremap <leader>= <Cq<CR>

" function for working with files with hard line breaks
cabbr eighty call Eighty()
fun! Eighty()
  set textwidth=80                               " wrap to size characters
  set formatoptions+=a                           " automatically reformat when inserting or deleting
  let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1) " highlight any line > size characters
  colo neon
endfu

"if has("mac") || has("gui_macvim") || has("gui_mac")
"  source ~/conf/platforms/$PLATFORM/etc/.vimrc
"endif

" xmledit plugin - use for html
"let g:xmledit_enable_html=1

if &l:diff
  colors peachpuff
  set diffopt+=iwhite   " ignore whitespace differences for diff
else
  if !exists("g:randomizedColorsOnStart")
    call RandomColorscheme()
  endif
  let g:randomizedColorsOnStart=1
endif

comma! -nargs=1 Silent
      \ | execute ':silent !'.<q-args>
      \ | execute ':redraw!'

"" readline-like bindings. might be obviated by https://github.com/tpope/vim-rsi
nnoremap <M-b> b
nnoremap <M-f> w
nnoremap <C-b> <Left>
nnoremap <C-f> <Right>
inoremap <M-b> <C-o>b
inoremap <M-f> <C-o>e<Right>
"nnoremap <C-k> :call KillLine()<CR>  " messes with ultisnips default "previous field" mapping

" emacs muscle memory
nnoremap <C-x><C-o> <C-W><C-W>
nnoremap <C-x><C-2> :vsplit
nnoremap <C-x><C-3> :split

" space at end is helpful for speed reasons
nnoremap ! :! 

" Retains current last output, which adds context.
" I generally have a good idea of when I am insert mode
set noshowmode

" tern for vim
"let g:tern_show_argument_hints = 'on_hold'
"let g:tern_show_signature_in_pum = 1



" http://stackoverflow.com/questions/8450919/how-can-i-delete-all-hidden-buffers
function! DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction

if has("gui_running")
  " for some reason this wasn't working by default for me?
  source ~/.gvimrc
endif


" TODO: extract to plugin
" from http://vimcasts.org/episodes/working-with-tabs/
" and http://vim.wikia.com/wiki/Using_tab_pages
" " For mac users (using the 'apple' key)
nnoremap <D-S-]> gt
nnoremap <D-S-[> gT
nnoremap <D-1> 1gt
nnoremap <D-2> 2gt
nnoremap <D-3> 3gt
nnoremap <D-4> 4gt
nnoremap <D-5> 5gt
nnoremap <D-6> 6gt
nnoremap <D-7> 7gt
nnoremap <D-8> 8gt
nnoremap <D-9> :tablast<CR>
nnoremap <D-LEFT> :tabprevious<CR>
nnoremap <D-RIGHT> :tabnext<CR>
" also has 'for linux and windows users (using the control key)'
" but punting for now

" Otherwise if I accidentally click with the mouse when I am insert
" mode, it moves it there and messes up my editing. I can't think of
" a time when I actually want to navigate in insert mode, I always just
" escape out and navigate using normal mode.
set mouse-=i

" https://stackoverflow.com/questions/11903889
" Get alt working to not put in special characters
set macmeta

augroup NetrwKeymaps
  autocmd!
  autocmd FileType netrw call s:NetrwKeymaps()
augroup END

function! s:NetrwKeymaps()
  " Remove the global ? mapping
  nunmap ?
  " Optionally, remap ? just for netrw buffers
  nmap <buffer> ? <Plug>NetrwHideEdit
endfunction
