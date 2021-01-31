" Increase default size of 31 a little
let g:NERDTreeWinSize=40

" Disables excess text in display
let g:NERDTreeMinimalUI=1

" Keeps
let g:NERDTreeCreatePrefix='silent keepalt keepjumps'

" TODO: Figure out how this works...
if has('autocmd')
  augroup ftplugin_nerdtree
    autocmd!
    autocmd User NERDTreeInit call autocmds#attempt_select_last_file()
  augroup END
endif

