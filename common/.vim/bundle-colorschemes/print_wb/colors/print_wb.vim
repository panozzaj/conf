" print_wb.vim - http://github.com/panozzaj/print_wb
" Vim colorscheme. White text on a black background.
" Maintained by Anthony Panozzo
"
" See print_bw.vim by Mike Williams
" This is just a copy of that file, with the colors inverted.


" Remove all existing highlighting.
set background=dark

highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "print_wb"

highlight Normal        cterm=NONE ctermfg=white ctermbg=black gui=NONE guifg=white guibg=black
highlight NonText       ctermfg=white ctermbg=black guifg=white guibg=black
highlight LineNr        cterm=italic ctermfg=white ctermbg=black gui=italic guifg=white guibg=black

" Syntax highlighting scheme
highlight Comment       cterm=italic ctermfg=white ctermbg=black gui=italic guifg=white guibg=black

highlight Constant      ctermfg=white ctermbg=black guifg=white guibg=black
highlight String        ctermfg=white ctermbg=black guifg=white guibg=black
highlight Character     ctermfg=white ctermbg=black guifg=white guibg=black
highlight Number        ctermfg=white ctermbg=black guifg=white guibg=black
" Boolean defaults to Constant
highlight Float         ctermfg=white ctermbg=black guifg=white guibg=black

highlight Identifier    ctermfg=white ctermbg=black guifg=white guibg=black
highlight Function      ctermfg=white ctermbg=black guifg=white guibg=black

highlight Statement     ctermfg=white ctermbg=black guifg=white guibg=black
highlight Conditional   ctermfg=white ctermbg=black guifg=white guibg=black
highlight Repeat        ctermfg=white ctermbg=black guifg=white guibg=black
highlight Label         ctermfg=white ctermbg=black guifg=white guibg=black
highlight Operator      ctermfg=white ctermbg=black guifg=white guibg=black
" Keyword defaults to Statement
" Exception defaults to Statement

highlight PreProc       cterm=bold ctermfg=white ctermbg=black gui=bold guifg=white guibg=black
" Include defaults to PreProc
" Define defaults to PreProc
" Macro defaults to PreProc
" PreCondit defaults to PreProc

highlight Type          cterm=bold ctermfg=white ctermbg=black gui=bold guifg=white guibg=black
" StorageClass defaults to Type
" Structure defaults to Type
" Typedef defaults to Type

highlight Special       cterm=italic ctermfg=white ctermbg=black gui=italic guifg=white guibg=black
" SpecialChar defaults to Special
" Tag defaults to Special
" Delimiter defaults to Special
highlight SpecialComment cterm=italic ctermfg=white ctermbg=black gui=italic guifg=white guibg=black
" Debug defaults to Special

highlight Todo          cterm=italic,bold ctermfg=white ctermbg=black gui=italic,bold guifg=white guibg=black
" Ideally, the bg color would be black but VIM cannot print black on white!
highlight Error         cterm=bold,reverse ctermfg=white ctermbg=grey gui=bold,reverse guifg=white guibg=grey

" vim:et:ff=unix:tw=0:ts=4:sw=4
" EOF print_wb.vim
