set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'bling/vim-airline'
Plugin 'fugitive.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdtree'
"Plugin 'scrooloose/nerdcommenter'
Plugin 'Syntastic'
Plugin 'tpope/vim-commentary'
Plugin 'kien/ctrlp.vim'
Plugin 'surround.vim'
Plugin 'elzr/vim-json'
"Plugin 'tpope/vim-unimpaired'
Plugin 'altercation/vim-colors-solarized'
Plugin 'majutsushi/tagbar'
"Plugin 'a.vim'
"Plugin 'klen/python-mode'
"Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'Yggdroot/indentLine'
"Plugin 'flazz/vim-colorschemes'
"Plugin 'desert-warm-256'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'pangloss/vim-javascript'
Plugin 'marcopaganini/termschool-vim-theme'
Plugin 'scwood/vim-hybrid'
Plugin 'AutoComplPop'
Plugin 'valloric/youcompleteme'
Plugin 'ternjs/tern_for_vim'
Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'mattn/emmet-vim'

call vundle#end()            " required
filetype plugin indent on    " required
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

let g:typescript_indent_disable = 1

"set regexpengine=1
"let g:javascript_conceal_function   = "ƒ"
"let g:javascript_conceal_null       = "ø"
"let g:javascript_conceal_this       = "@"
"let g:javascript_conceal_return     = "⇚"
"let g:javascript_conceal_undefined  = "¿"
"let g:javascript_conceal_NaN        = "ℕ"
"let g:javascript_conceal_prototype  = "¶"
"let g:javascript_conceal_static     = "•"
"let g:javascript_conceal_super      = "Ω"
syntax enable
"au FileType javascript call JavaScriptFold()

"if has("gui_running")
"set guifont=Liberation\ Mono\ for\ Powerline:h14
"endif

" Change the mapleader from \ to ,
let mapleader=","


" Colorscheme
"let g:solaried_termcolors=256
set background=dark
"colorscheme termschool
colorscheme solarized

set ruler
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set backspace=indent,eol,start
set autoindent
set copyindent
set showmatch
set smarttab
set incsearch
set title
set hlsearch
set history=1000
set undolevels=1000
set list
set listchars=tab:>-,trail:-,extends:#
set wrap
set pastetoggle=<leader>p
set encoding=utf-8
set showcmd
set hidden " Controversial
set wildmenu
set wildmode=list:longest
"set visualbell
set number
set relativenumber
set undofile
set ignorecase
set smartcase
set gdefault
set colorcolumn=80
set textwidth=79
set formatoptions=cqnr1
set cursorline
set nojoinspaces
set splitright
set completeopt-=preview
set splitbelow
set clipboard=unnamed

" Status
set laststatus=2
set statusline=%<%f\                     " Filename
set statusline+=%w%h%m%r                 " Options
set statusline+=%{fugitive#statusline()} " Git Hotness
set statusline+=\ [%{&ff}/%Y]            " Filetype
set statusline+=\ [%{getcwd()}]          " Current dir
set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

set wildignore+=*.so,*.swp,*.zip,*.pyc
set wildignore+=*.o,*.out,*.obj,*.so,*.pyc
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/.sass-cache/*
set wildignore+=*.swp,*~,._*

let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_html_tidy_ignore_errors=[
      \'proprietary attribute "ng-',
      \'proprietary attribute "ion-'
      \'proprietary attribute "sj-'
      \]
"let g:syntastic_python_checkers = ['pylint']
let g:syntastic_javascript_checkers = ['eslint']
au BufRead,BufNewFile *.json set filetype=json
let g:syntastic_json_checkers=['jsonlint']
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"

" air-line
set guifont=DejaVu\ Sans:s12
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

"set linespace=0
set nobackup

noremap <F1> <ESC>
"nnoremap j gj
"nnoremap k gk
"nnoremap ; :
nnoremap Y y$
nnoremap / /\v
vnoremap / /\v
nmap <tab> %
vmap <tab> %
nnoremap <CR> :nohlsearch<CR>
nnoremap <leader><space> :nohlsearch<CR>
inoremap jj <ESC>


" Nerdtree
"map <C-e> <plug>NERDTreeTabsToggle<CR>
"map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>
nmap <leader>n<space> :NERDTreeToggle<CR>
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0


" Tagbar
nnoremap <silent> <leader>t<space> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1


" Ctrlp
"let g:ctrlp_custom_ignore = {
"\ 'dir':  '\v[\/]\.(git|hg|svn)$',
"\ 'file': '\v\.(exe|so|dll)$',
"\ 'link': 'some_bad_symbolic_links',
"\ }
let g:ctrlp_working_path_mode = 0
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/](\.git|\.hg|\.svn|node_modules|platforms|build|plugins)$',
      \ 'file': '\.so$\|\.pyc$' }

" ctrlp exclude
let g:ctrlp_mruf_case_sensitive = 0
nnoremap <leader>b :CtrlPBuffer<CR>


"Indent-guides
" let g:indent_guides_auto_colors = 0
"autocmd filetype python,html,htmldjango,htmljinja,js :IndentGuidesEnable
"let g:indent_guides_auto_colors = 1
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermfg=none ctermbg=234
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermfg=none ctermbg=235
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermfg=none ctermbg=235
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=black
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=darkgrey
"let g:indent_guides_start_level = 2
"let g:indent_guides_guide_size = 1

let g:indentLine_color_term = 239

"python-mode
let g:pymode_folding = 0
let g:pymode_rope_goto_definition_bind = '<leader>d<space>'
let g:pymode_lint_ignore = "E265,W0612,W0611"
let g:pymode_rope_completion = 0

set visualbell
set t_vb=

let g:used_javascript_libs = 'underscore,angularjs,angularui,angularuirouter,react,jquery'

" cscope
function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction
au BufEnter /* call LoadCscope()

nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR> 
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>    
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>    
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>    
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>    
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>    
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR> 
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>    

set csprg=/usr/bin/cscope
set csto=1
set csverb


" minibufexpl 
let g:miniBufExplBuffersNeeded = 1

noremap ˙     <C-W>h
noremap ∆     <C-W>j
noremap ˚     <C-W>k
noremap ¬     <C-W>l

"noremap <C-Down>  <C-W>j
"noremap <C-Up>    <C-W>k
"noremap <C-Left>  <C-W>h
"noremap <C-Right> <C-W>l

"command WQ wq
"command Wq wq
"command W w
"command Q q
"command WA wa
"command Wa wa


nnoremap <silent> <leader>a<space> :A<CR>

"indent line setting
nnoremap <silent> <leader>il :IndentLinesToggle<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LOCAL SETTING
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" tags
set tags=./tags,tags

" indentation
map <F7> mzgg=G`z

nnoremap <Alt-Left> <C-O>

"iTerm color set
set t_Co=256

autocmd BufRead *.as set filetype=actionscript
