" ___      ___  __     ___      ___   _______    ______   
"|"  \    /"  ||" \   |"  \    /"  | /"      \  /" _  "\  
" \   \  //  / ||  |   \   \  //   ||:        |(: ( \___) 
"  \\  \/. ./  |:  |   /\\  \/.    ||_____/   ) \/ \      
"   \.    //   |.  |  |: \.        | //      /  //  \ _   
"    \\   /    /\  |\ |.  \    /:  ||:  __   \ (:   _) \  
"     \__/    (__\_|_)|___|\__/|___||__|  \___) \_______) 
"

" Webpack autoreload, look into more...
set backupcopy=yes
" Color {{{
set background=dark " Vim will use a better colorscheme against dark bg
let base16colorspace=256  " Access colors present in 256 colorspace

" Spelling highlights
augroup spell_highlights
  autocmd ColorScheme *  hi clear SpellBad
  autocmd ColorScheme * hi SpellBad cterm=underline,bold
augroup END

colorscheme base16-default-dark
syntax enable 
" }}}
" UI Layout {{{
let mapleader=","
let maplocalleader=";"
set clipboard=unnamed " Use the OS clipboard by default
set encoding=utf-8 " Consistent formatting to utf-8 spec
set tabstop=2 " Number of visual spaces per TAb
set softtabstop=2 " Number of spaces in tab when editing
set shiftwidth=2 " Makes indent the same as a tab
set expandtab " Tab becomes four spaces
set relativenumber " Line numbers become relative to current position
set number " Show line numbers
set showcmd " Show command in bottom bar
set cursorline " Highlight current line
set backspace=indent,eol,start " Can delete past insert point
" set hlsearch " Highlight search matches 
set ignorecase " Ignore cases when searching 
" }}}
" Whitespace {{{
" set listchars=eol:⏎,tab:␉·,trail:␠,nbsp:⎵
set listchars=tab:>·,trail:·
set invlist
" }}}
" Urlview {{{
" Choose and open url
nnoremap <leader>u :w<Home>silent <End> !urlview<CR>
" }}}
" Search {{{

" https://stackoverflow.com/questions/40867576/how-to-use-vimgrep-to-grep-work-thats-high-lighted-by-vim
vnoremap <F8> y:execute 'vimgrep /\V' . escape(@@, '/\') . '/ %'<CR>

" }}}
" Fold Settings {{{

set foldenable " Enable folding
set foldlevelstart=2 " Folds whole file everytime so I learn to use folds

set foldmethod=indent " For Python functions, classes 

" Toggle opening and closing of folds
nnoremap <space> za 

" Toggle recursive opening and closing of folds
nnoremap å zA

" }}}
" Writing Settings {{{
" set textwidth=74
" }}}
" Pathogen {{{
execute pathogen#infect()
" }}}
" Tmuxline + Airline Settings {{{
" For tmuxline + vim-airline integration
let g:airline#extensions#tmuxline#enabled = 1
" Start tmuxline even without vim running
let airline#extensions#tmuxline#snapshot_file = "~/.tmux-status.conf"
" }}}
" ALE {{{

" LINTERS
" Specify which linters I want for each filetype
let g:ale_linters = { 'python': ['flake8', 'pylint'],
\                     'java' : ['checkstyle', 'eclipselsp'],
\                     'go' : ['gopls'],
\                     'javascript': ['eslint'],
\                     'typescript': ['eslint'],
\}
let g:ale_linter_aliases = {'typescriptreact': 'typescript'}
let g:ale_linters_explicit = 1 " Only lint with the programs I specified
let g:ale_lint_on_enter = 0 " Don't lint when opening a file
let g:ale_lint_on_text_changed = 'never' " Don't lint when typing

" FIXERS
" Specify which fixers I want with ALEFix command/save 
let g:ale_fixers = { 'python': ['autopep8'],
\                    'javascript': ['eslint', 'prettier'],
\                    'typescript': ['eslint', 'prettier'],
\                    'typescriptreact': ['eslint', 'prettier'],
\                    'java': ['google_java_format', 'remove_trailing_lines', 'trim_whitespace'],
\                    'css': ['prettier'],
\                     'go' : ['gofmt'],
\                    'html': ['prettier'],
\                    'json': ['prettier'],
\                    'yaml': ['prettier'],
\}
let g:ale_fix_on_save = 1 " Fix when I save
let g:ale_fixer_aliases = {'typescriptreact': 'typescript'}

command! ALEDisableFixers       let g:ale_fix_on_save=0
command! ALEEnableFixers        let g:ale_fix_on_save=1

" Toggle fixer
command! ALEToggleFixer execute "let g:ale_fix_on_save = get(g:, 'ale_fix_on_save', 0) ? 0 : 1"

" Wrap long errors
" autocmd FileType qf setlocal wrap
" let g:ale_open_list = 1 "opens quickfix

" }}}
" VimWiki {{{
set nocompatible
" Filetype and plugin independently turned on
filetype plugin on
syntax on

let g:vimwiki_folding = 'expr' " Allows default folding to be controlled by external plugin

" Map å to <S-CR> (Shift - Enter) for list creation functionality in vimwiki
" https://stackoverflow.com/questions/5388562/cant-map-s-cr-in-vim
inoremap å <Esc>:VimwikiReturn 2 2<CR>
 
" Creates a table and enters insert mode
nnoremap <Leader>tt :VimwikiTable

" Only files within a wiki with ".md" extension will have vimwiki ft
let g:vimwiki_global_ext = 0

let g:vimwiki_list = [{'path': '~/notes/', 
                      \'syntax': 'markdown', 
                      \'ext': '.md'}]
" }}}
" Calendar {{{ 
" Enable google calendar integration
let g:calendar_google_calendar = 1

" Make first day Monday instead of Sunday
let g:calendar_first_day = 'monday'

" AM / PM times
let g:calendar_clock_12hour = 1 

" Change initial calendar view to day
let g:calendar_view = 'day'

" Change possible calendar views you can cycle through
let g:calendar_views = ['year', 'month', 'week', 'weekday', 'day_3', 'day', 'event', 'agenda']

" Map calender to leader c in a new buffer
nnoremap <silent> <leader>c :Calendar -position=left<cr>

" Map calender to leader C in the same buffer
nnoremap <silent> <leader>C :Calendar<CR>

" Connect to diary
augroup vimrc_calendar
  autocmd FileType calendar nmap <buffer> <CR> :<C-u>call 
  \ vimwiki#diary#calendar_action(b:calendar.day().get_day(), 
  \ b:calendar.day().get_month(), b:calendar.day().get_year(), b:calendar.day().week(), "V")<CR>  autocmd!
augroup END

" Workaround for google authentification
let g:calendar_google_api_key = 'AIzaSyAfmpLVaA-ZNc--_yOpmkcbta5PcqOlzsI'
let g:calendar_google_client_id = '134348316443-6u8s8p8dmf03vooa311mr1s9vnao6933.apps.googleusercontent.com'
let g:calendar_google_client_secret = 'daPRZcSZLshv8ptLpxB0Lk5d'

" }}}
" Vimify {{{ 
" Authentification token for vimify
let g:spotify_token='OGZmNmVjYzNhMzRhNDMwM2IzZDhjNmQ2YjUwYWVkMGU6NjQ2YTkzN2E1YjNlNGE2NGIzYzBiNTkzNDA3ZmJhZGU='

" Toggle play
map <leader>s  :Spotify<CR>

" Next track
map <leader>sn  :SpNext<CR>

" Previous track
map <leader>sp  :SpPrevious<CR>

" Search
map <leader>S  :SpSearch

" }}}
" VOoM {{{

" List of markup types that Voom will identify
" let g:voom_ft_modes = {'markdown': 'markdown', 'tex': 'latex'}

" Open a Vim Outline of Markup in markdown in side buffer
nnoremap <silent> <leader>v :Voom markdown<cr>

" Sort Headings in the Voom buffer recursively
nnoremap <silent> <leader>vs :Voomsort "deep"<cr>

" Execute code under heading in python3
nnoremap <silent> <leader>ve :Voomexec py<cr>

" Redirect Python's stderr and stout to log buffer like running interactive
" interpreter
nnoremap <silent> <leader>vl :Voomlog<cr>

" Make tree buffer wider
let g:voom_log_width = 35

" Use Python 3 Always
let g:voom_python_versions = [3]

" }}}
" Goyo {{{

" Quickly toggle Goyo
map <leader>gg :Goyo<CR>

"}}}
" Limelight {{{

" Quickly toggle Limelight
map <leader>ll :Limelight!!<CR>

"}}}
" vimtex {{{

" Show information about latex project
map <leader>li :VimtexInfo<CR>

" Show documentation for package under cursor
map <leader>ld :VimtexDocPackage<CR>

" Enable compilation and preview
map <leader>lc :VimtexCompile<CR>

" Show Table of Contents
map <leader>lt :VimtexTocOpen<CR>

" Show log from compiling in a scratch buffer
map <leader>ll :VimtexErrors<CR>
" Set pdf viewer to skim
let g:vimtex_view_method = "skim"

"}}}
" Command-T {{{

" Use the much faster UNIX find command instead of ruby
let g:CommandTFileScanner = "find"

" Shift-Enter opens file in a vertical split (mapped in iterm to that weird a
" thing)
let g:CommandTAcceptSelectionVSplitMap = "å"

" Open file in normal split
let g:CommandTAcceptSelectionSplitMap = "<C-Enter>"

"}}}
" NERDTree {{{

"Toggle nerdtree buffer.
map <leader>n :NERDTreeToggle<CR>

"}}}
" YouCompleteMe {{{

" Clear blacklist - YCM work in all files
" let g:ycm_filetype_blacklist = {}

" Make window go away
let g:ycm_autoclose_preview_window_after_completion = 1

" Remember I can always use <C-y> to accept completion

" Series of intuitive (I hope) jump shortcuts
map <leader>g        :YcmCompleter GoTo<CR>
map <leader>gd       :YcmCompleter GoToDefinition<CR>
map <leader>gr       :YcmCompleter GoToReferences<CR>
map <leader>d        :YcmCompleter GetDoc<CR>

"}}}
" UltiSnips {{{
"
"" Edit Snippet file in vertical split
let g:UltiSnipsEditSplit = 'vertical'

" Use this directory when editing files
let g:UltiSnipsSnippetsDir="~/.vim/mysnippets"

" Expand Trigger is Ctrl-j (So doesn't conflict with Tab from YCM
let g:UltiSnipsExpandTrigger = '<C-j>'

" Cycle through different fields in the snippet
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"

" See what I have in the current buffer for snippets
let g:UltiSnipsListSnippets="<C-Space>"

" Look for snippets in the vim-snippets plugin
" Need the whole plugin (for now) because some stuff is dynamically generated
let g:UltiSnipsSnippetDirectories = ["UltiSnips", "~/.vim/mysnippets"]

" Open snippet file for filetype with a hotkey so I can edit it
map <leader>ss  :UltiSnipsEdit<CR>

" Select from list of possible snippet files to edit
map <leader>SS :UltiSnipsEdit!<CR>
"}}}
" Omnicomplete (Built-in vim completion engine) {{{

set omnifunc=syntaxcomplete#Complete

" }}}
" Emmet {{{

"html/css utilities

let g:user_emmet_install_global = 1
autocmd FileType hbs,html,css EmmetInstall

let g:user_emmet_leader_key='<C-j>'

" }}}
" vim-go {{{
let g:go_fmt_command = "goimports" " Run goimports along gofmt on each save

" }}}
" .proto files {{{

augroup filetype
  au! BufRead,BufNewFile *.proto setfiletype proto
augroup end

" }}}
" .py files {{{

" PEP8 Formatting 
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix 

" Highlights lines that over 80 (Shouldn't happen cause of above specs)
augroup pyfile_autocmds
    autocmd BufEnter *.py highlight OverLength ctermbg=red guibg=#592929
    autocmd BufEnter *.py match OverLength /\%81v.*/
    autocmd BufWritePre *.py %s/\s\+$//e " Strips trailing whitespaces on save
augroup END

" }}}
" .java files {{{

au BufNewFile,BufRead *.java
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix 

" }}}
" .go files {{{

au BufNewFile,BufRead *.go
    \ set noexpandtab |
    \ set tabstop=4 |
    \ set shiftwidth=4 |
    \ set softtabstop=4 |
    \ set autoindent |
    \ set fileformat=unix 

" }}}
" .js files {{{

" Add relevant snippets to .js files
autocmd FileType js UltiSnipsAddFiletypes 

au BufNewFile,BufRead *.js
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set noexpandtab |
    \ set autoindent |
    \ set fileformat=unix 

" }}}
" .tsx files {{{
"

au BufNewFile,BufRead *.tsx
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set noexpandtab |
    \ set autoindent |
    \ set fileformat=unix 

au BufNewFile,BufRead *.ts
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set noexpandtab |
    \ set autoindent |
    \ set fileformat=unix 

" }}}
" .hbs files {{{

" Add relevant snippets to .js files
autocmd FileType js UltiSnipsAddFiletypes 

au BufNewFile,BufRead *.hbs
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ let  g:mustache_abbreviations=1

" }}}
" " .s files {{{

au BufNewFile,BufRead *.s
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix 

" }}}
" " .c files {{{

au BufNewFile,BufRead *.c
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix 

" }}}
" .sh files {{{

au BufNewFile,BufRead *.sh
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix 

au BufNewFile,BufRead *.nf
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix 

" }}}
" .md files {{{ 
" Hard line breaks and "auto-wrap" text format option
au FileType markdown setlocal textwidth=80 fo=t
au BufNewFile,BufRead *.md
    \ setlocal spell spelllang=en_us


" }}}
" other files {{{

" Formatting
au BufNewFile,BufRead *.html
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set autoindent 

" Formatting
au BufNewFile,BufRead *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set autoindent

" }}}
" Visual Line Navigation Snippet {{{

" Map j and k to gj/gk, but only when no count is given
" However, for larger jumps like 6j add the current position to the jump list
" so that you can use <c-o>/<c-i> to jump to the previous position
nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

" }}}

set modelines=1
" vim:foldmethod=marker:foldlevel=0  
