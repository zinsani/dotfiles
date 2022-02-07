" Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
" call plug#begin('~/.vim/plugged')
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'Yggdroot/indentLine'

" Syntax highlighting
Plug 'andys8/vim-elm-syntax', { 'for': ['elm'] }

Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" Color theme
Plug 'morhetz/gruvbox'

" Find files
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Track the engine.
Plug 'SirVer/ultisnips'
Plug 'mlaursen/vim-react-snippets'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

" A collection of language packs for Vim.
Plug 'sheerun/vim-polyglot'
Plug 'OmniSharp/omnisharp-vim'
Plug 'dense-analysis/ale'

" Initialize plugin system
call plug#end()

" General settings
set nocompatible
set encoding=utf-8
set ttyfast
set hidden
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab
set shell=/bin/sh
set smartcase
set smarttab
set smartindent   
set incsearch
set title
set hlsearch
set ignorecase
set clipboard=unnamed
set number
set relativenumber
set wildignore+=*.so,*.swp,*.zip,*.pyc,**/.git/**
set wildignore+=**/node_modules/**
set wildignore+=**/elm-stuff/**,**/.cache/**,**/.parcel-cache/**,**/dist/**
set wildignore+=*.o,*.out,*.obj,*.so,*.pyc
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/.sass-cache/*
set wildignore+=*.swp,*~,._*
set undodir=~/.config/nvim/undodir " set undotree file directory
set undofile " set undotree to save to file

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Set this to 1 to use ultisnips for snippet handling
" let s:using_snippets = 1

" Fix backspace indent
set backspace=indent,eol,start

filetype plugin indent on
filetype plugin on
syntax on

" Map <leader>to `,`
" let mapleader=','
let mapleader=' '

nnoremap Y y$
vnoremap / /\v
" nnoremap <CR> :nohlsearch<CR>
nnoremap <leader><space> :nohlsearch<CR>
inoremap jj <ESC>

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

if exists('*complete_info')
  inoremap <silent><expr> <cr> complete_info(['selected'])['selected'] != -1 ?
              \"\<C-y>" : "\<C-g>u\<CR>"
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction



" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif


" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction



" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>d  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

let g:coc_global_extensions = [
  \ 'coc-emmet', 
  \ 'coc-css', 
  \ 'coc-html', 
  \ 'coc-json', 
  \ 'coc-prettier', 
  \ 'coc-tsserver', 
  \ 'coc-snippets',
  \ 'coc-tsserver'
  \ ]

" ALE (Asynchronous Lint Engine)
let g:ale_fixers = {
 \ 'javascript': ['eslint']
 \ }
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_fix_on_save = 1
let g:ale_linters = {
\ 'cs': ['OmniSharp']
\}
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_list_window_size = 5

" let g:LanguageClient_serverCommands = {
"   \ 'elm': ['elm-language-server'],
"   \ }

" let g:LanguageClient_rootMarkers = {
"   \ 'elm': ['elm.json'],
"   \ }

" Color theme settings
if (has("termguicolors"))
 set termguicolors
endif
colorscheme gruvbox
set bg=dark
highlight Normal ctermbg=black ctermfg=white

" FZF
nnoremap <silent> <leader>fp :GFiles<CR>
nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>fh :History<CR>
nnoremap <silent> <leader>fl :Lines<CR>
nnoremap <silent> <leader>fc :BCommits<CR>
nnoremap <silent> <leader>fco :Commits<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}


"fugitive
nmap <leader>gs :Gstatus<CR>
nmap <leader>gh :diffget //2<CR>
nmap <leader>gl :diffget //3<CR>
nmap <leader>gg :Glog<CR>
nmap <leader>gp :Gpush<CR>

" moving between windows - (Option + hjkl)
noremap <M-h>     <C-W>h
noremap <M-j>     <C-W>j
noremap <M-k>     <C-W>k
noremap <M-l>     <C-W>l

" OmniSharp: {{{

" augroup OmniSharpIntegrations
"   autocmd!
"   autocmd User OmniSharpProjectUpdated,OmniSharpReady call lightline#update()
" augroup END

" Don't autoselect first omnicomplete option, show options even if there is only
" one (so the preview documentation is accessible). Remove 'preview', 'popup'
" and 'popuphidden' if you don't want to see any documentation whatsoever.
" Note that neovim does not support `popuphidden` or `popup` yet:
" https://github.com/neovim/neovim/issues/10996
if has('patch-8.1.1880')
  set completeopt=longest,menuone,popuphidden
  " Highlight the completion documentation popup background/foreground the same as
  " the completion menu itself, for better readability with highlighted
  " documentation.
  set completepopup=highlight:Pmenu,border:off
else
  set completeopt=longest,menuone,preview
  " Set desired preview window height for viewing documentation.
  set previewheight=5
endif

" Tell ALE to use OmniSharp for linting C# files, and no other linters.
" let g:ale_linters = { 'cs': ['OmniSharp'] }

augroup omnisharp_commands
  autocmd!

  " Show type information automatically when the cursor stops moving.
  " Note that the type is echoed to the Vim command line, and will overwrite
  " any other messages in this space including e.g. ALE linting messages.
  autocmd CursorHold *.cs OmniSharpTypeLookup

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader><Leader>fu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <Leader><Leader>fi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader><Leader>pd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader><Leader>pi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader><Leader>t <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> <Leader><Leader>d <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <Leader><Leader>fs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <Leader><Leader>fx <Plug>(omnisharp_fix_usings)
  autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
  autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

  " Navigate up and down by method/property/field
  autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
  autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
  " Find all code errors/warnings for the current solution and populate the quickfix window
  autocmd FileType cs nmap <silent> <buffer> <Leader><Leader>gcc <Plug>(omnisharp_global_code_check)
  " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
  autocmd FileType cs nmap <silent> <buffer> <Leader><Leader>ca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <Leader><Leader>ca <Plug>(omnisharp_code_actions)
  " Repeat the last code action performed (does not use a selector)
  autocmd FileType cs nmap <silent> <buffer> <Leader><Leader>. <Plug>(omnisharp_code_action_repeat)
  autocmd FileType cs xmap <silent> <buffer> <Leader><Leader>. <Plug>(omnisharp_code_action_repeat)

  autocmd FileType cs nmap <silent> <buffer> <Leader><Leader>= <Plug>(omnisharp_code_format)

  autocmd FileType cs nmap <silent> <buffer> <Leader><Leader>rn <Plug>(omnisharp_rename)

  autocmd FileType cs nmap <silent> <buffer> <Leader><Leader>re <Plug>(omnisharp_restart_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader><Leader>st <Plug>(omnisharp_start_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader><Leader>sp <Plug>(omnisharp_stop_server)
augroup END

" set completeopt=menuone,noinsert,noselect
" set completepopup=highlight:Pmenu,border:off

let g:OmniSharp_popup_position = 'peek'
if has('nvim')
  let g:OmniSharp_popup_options = {
  \ 'winhl': 'Normal:NormalFloat'
  \}
else
  let g:OmniSharp_popup_options = {
  \ 'highlight': 'Normal',
  \ 'padding': [0, 0, 0, 0],
  \ 'border': [1]
  \}
endif

let g:OmniSharp_popup_mappings = {
\ 'sigNext': '<C-n>',
\ 'sigPrev': '<C-p>',
\ 'pageDown': ['<C-f>', '<PageDown>'],
\ 'pageUp': ['<C-b>', '<PageUp>']
\}

" if s:using_snippets
"   let g:OmniSharp_want_snippet = 1
" endif

let g:OmniSharp_highlight_groups = {
\ 'ExcludedCode': 'NonText'
\}

" Use Roslyin and also better performance than HTTP
let g:OmniSharp_server_stdio = 1
let g:omnicomplete_fetch_full_documentation = 1

" Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 30

" this will make it so any subsequent C# files that you open are using the same solution and you aren't prompted again (so you better choose the right solution the first time around :) )
let g:OmniSharp_autoselect_existing_sln = 1

" }}}"

" UltiSnipet Settings
" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
" let g:UltiSnipsExpandTrigger="<Tab>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"

" Smarter tab line 활성화: 모든 파일 버퍼 출력
let g:airline#extensions#tabline#enabled = 1

" Tab line 구분자 '|' 로 설정
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" Tab line 에 파일명만 출력되도록 설정
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Powerline-font 활성화
let g:airline_powerline_fonts = 1 
"
""" Workman
" Map to Alt-yneo instead of hjkl
" nnoremap ^[y h
" nnoremap ^[n j
" nnoremap ^[e k
" nnoremap ^[o l

" vnoremap ^[y h
" vnoremap ^[n j
" vnoremap ^[e k
" vnoremap ^[o l

map ]q :cn<CR>
map [q :cp<CR>

nnoremap \ h
nnoremap ˜ j
nnoremap ´ k
nnoremap ø l

vnoremap ˚ h
vnoremap ¬ j
vnoremap ≤ k
vnoremap ≥ l
