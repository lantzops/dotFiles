" ============================================================================
"  ~/.vimrc  —  retro & feature-rich  (vim 9.2)
" ============================================================================

" ---- Plugins (vim-plug) --------------------------------------------------
call plug#begin('~/.vim/plugged')

" Retro colorschemes
Plug 'morhetz/gruvbox'
Plug 'srcery-colors/srcery-vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'tomasr/molokai'
Plug 'sjl/badwolf'
Plug 'ajmwagar/vim-deus'

" UI
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'
Plug 'Yggdroot/indentLine'
Plug 'ap/vim-css-color'

" Files & search
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Editing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'sheerun/vim-polyglot'
Plug 'easymotion/vim-easymotion'

" LSP / completion / snippets
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'

call plug#end()

" ---- Core --------------------------------------------------------------
set nocompatible
filetype plugin indent on
syntax on

" ---- UI ----------------------------------------------------------------
set number relativenumber
set cursorline
set termguicolors
set background=dark
set showcmd showmatch ruler
set laststatus=2
set wildmenu wildmode=longest:full,full
set splitright splitbelow
set scrolloff=8 sidescrolloff=8
set lazyredraw ttyfast
set noerrorbells visualbell t_vb=
set title
set signcolumn=yes
set updatetime=300
set shortmess+=c

" ---- Search ------------------------------------------------------------
set incsearch hlsearch
set ignorecase smartcase

" ---- Indent ------------------------------------------------------------
set expandtab
set tabstop=4 softtabstop=4 shiftwidth=4
set autoindent smartindent smarttab

" ---- Files / undo ------------------------------------------------------
set hidden autoread
set noswapfile nobackup nowritebackup
set undofile
set undodir=~/.vim/undo
if !isdirectory($HOME.'/.vim/undo')
  call mkdir($HOME.'/.vim/undo', 'p')
endif

" ---- Misc --------------------------------------------------------------
set encoding=utf-8 fileencoding=utf-8
set mouse=a
set clipboard=unnamedplus
set backspace=indent,eol,start
set history=1000
set timeoutlen=500

" ---- Theme -------------------------------------------------------------
silent! colorscheme srcery
let g:airline_theme = 'deus'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" ---- Startify (BBS splash) --------------------------------------------
let g:startify_custom_header = [
  \ '   ╔══════════════════════════════════════════════════════╗',
  \ '   ║                                                      ║',
  \ '   ║   ██╗   ██╗ ██╗ ███╗   ███╗     ██████╗  ██████╗     ║',
  \ '   ║   ██║   ██║ ██║ ████╗ ████║     ╚════██╗ ╚════██╗    ║',
  \ '   ║   ██║   ██║ ██║ ██╔████╔██║      █████╔╝  █████╔╝    ║',
  \ '   ║   ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║     ██╔═══╝  ██╔═══╝     ║',
  \ '   ║    ╚████╔╝  ██║ ██║ ╚═╝ ██║   ██╗╚██████╗╚██████╗    ║',
  \ '   ║     ╚═══╝   ╚═╝ ╚═╝     ╚═╝   ╚═╝ ╚═════╝ ╚═════╝    ║',
  \ '   ║                                                      ║',
  \ '   ║              ▓▓▓  retro vim 9.2  ▓▓▓                 ║',
  \ '   ║                                                      ║',
  \ '   ╚══════════════════════════════════════════════════════╝',
  \ '']
let g:startify_lists = [
  \ { 'type': 'files',     'header': ['   MRU']            },
  \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
  \ ]
let g:startify_fortune_use_unicode = 1

" ---- NERDTree ----------------------------------------------------------
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1

" ---- indentLine --------------------------------------------------------
let g:indentLine_char = '│'
let g:indentLine_color_term = 239

" ---- gitgutter ---------------------------------------------------------
let g:gitgutter_sign_added = '┃'
let g:gitgutter_sign_modified = '┃'
let g:gitgutter_sign_removed = '┃'

" ---- Keymaps -----------------------------------------------------------
let mapleader = " "

" Files / quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" Toggles / explore
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>v :edit $MYVIMRC<CR>
nnoremap <leader>r :source $MYVIMRC<CR>

" Fuzzy
nnoremap <leader>f :Files<CR>
nnoremap <leader>F :Rg<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>l :Lines<CR>

" Git
nnoremap <leader>g :Git<CR>
nnoremap <leader>gd :Gdiffsplit<CR>
nnoremap <leader>gb :Git blame<CR>

" Splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Buffers
nnoremap <S-l> :bnext<CR>
nnoremap <S-h> :bprev<CR>
nnoremap <leader>d :bdelete<CR>

" Keep selection after indent
vnoremap < <gv
vnoremap > >gv

" Easymotion
nmap <leader>s <Plug>(easymotion-overwin-f)

" ---- coc.nvim (LSP) ---------------------------------------------------
let g:coc_global_extensions = [
  \ 'coc-pyright',
  \ 'coc-sh',
  \ 'coc-yaml',
  \ 'coc-json',
  \ 'coc-lua',
  \ 'coc-docker',
  \ 'coc-snippets',
  \ ]

" Detect Ansible playbooks/roles as yaml.ansible (gets ansible LSP)
augroup ansible_ft
  autocmd!
  autocmd BufRead,BufNewFile */playbooks/*.{yml,yaml} setfiletype yaml.ansible
  autocmd BufRead,BufNewFile */roles/*/{tasks,handlers,vars,defaults,meta}/*.{yml,yaml} setfiletype yaml.ansible
  autocmd BufRead,BufNewFile */group_vars/*,*/host_vars/* setfiletype yaml.ansible
augroup END

" Tab + Shift-Tab to navigate completion menu, Enter to confirm
inoremap <silent><expr> <Tab>
  \ coc#pum#visible() ? coc#pum#next(1) :
  \ CheckBackspace() ? "\<Tab>" :
  \ coc#refresh()
inoremap <expr><S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
  \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Trigger completion
inoremap <silent><expr> <C-space> coc#refresh()

" Goto code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Hover
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Rename / code action / format
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>ca <Plug>(coc-codeaction-cursor)
nmap <leader>fm <Plug>(coc-format)
xmap <leader>fm <Plug>(coc-format-selected)

" Diagnostics navigation
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nnoremap <silent> <leader>cd :CocList diagnostics<CR>

" Highlight symbol under cursor on hold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Snippets
let g:coc_snippet_next = '<tab>'
let g:coc_snippet_prev = '<s-tab>'

" Theme switcher (<leader>t + first letter)
nnoremap <leader>tg :colorscheme gruvbox<CR>
nnoremap <leader>ts :colorscheme srcery<CR>
nnoremap <leader>tp :colorscheme PaperColor<CR>
nnoremap <leader>tm :colorscheme molokai<CR>
nnoremap <leader>tb :colorscheme badwolf<CR>
nnoremap <leader>td :colorscheme deus<CR>
nnoremap <leader>tr :colorscheme retrobox<CR>
