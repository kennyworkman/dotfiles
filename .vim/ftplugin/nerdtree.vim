" Plugin from Wincent https://www.youtube.com/watch?v=OgQW07saWb0

setlocal colorcolumn=

if has('folding')
    setlocal nofoldenable
endif

setlocal nolist

" Move up a directory using "-" like Vim Vinegar but in NerdTree
nmap <buffer> <expr> - g:NERDTreeMapUpdir
