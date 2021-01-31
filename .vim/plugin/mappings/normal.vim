" Like vim-vinegar https://www.youtube.com/watch?v=OgQW07saWb0
" TODO: Figure out what the hell he did here
nnoremap <silent> - :silent edit <C-R>=empty(expand('%')) ? '.' : expand('%:p:h')<CR><CR>
