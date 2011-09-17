"let notabs = matchstr(getcwd(), '/Users/anthonypanozzo/Documents/dev/asta')
"if empty(notabs)
"  " echo 'will be expanding tabs'
"  set expandtab
"else
"  " echo 'will not be expanding tabs'
"  set noexpandtab
"endif

" Actual command-t...
"macmenu &File.New\ Tab key=<nop>
"map <D-t> :CommandT<CR>
