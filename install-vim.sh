#!/usr/bin/env bash
# =====================================
# Script Universal de Instalação do Vim Full Stack com Vundle (Bundle)
# Compatível com: Debian/Ubuntu, Arch, Fedora, openSUSE, Void, etc.
# =====================================

set -e

# --- Detectar Distro ---
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Não foi possível detectar a distribuição."
    exit 1
fi

echo "Detectado: $NAME"
echo "Instalando dependências básicas..."

# --- Instalar Dependências ---
case "$DISTRO" in
    ubuntu|debian|linuxmint)
        sudo apt update
        sudo apt install -y vim git curl nodejs npm fzf build-essential python3 python3-pip
        ;;
    arch|manjaro)
        sudo pacman -Sy --noconfirm vim git curl nodejs npm fzf base-devel python
        ;;
    fedora)
        sudo dnf install -y vim git curl nodejs npm fzf make gcc python3
        ;;
    opensuse*|suse)
        sudo zypper install -y vim git curl nodejs npm fzf gcc make python3
        ;;
    void)
        sudo xbps-install -Sy vim git curl nodejs npm fzf make gcc python3
        ;;
    *)
        echo "Distribuição não reconhecida. Instale manualmente: vim git curl nodejs npm fzf"
        ;;
esac

# --- Instalar Vundle (Bundle) ---
echo "Instalando Vundle (Bundle)..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# --- Criar diretório do Vim ---
mkdir -p ~/.vim/bundle

# --- Criar .vimrc ---
cat > ~/.vimrc <<'EOF'
" =====================================
" Vim 9 - Configuração Full Stack Otimizada (Vundle)
" =====================================

" --- Básico ---
set nocompatible
set encoding=utf-8
set hidden
set number relativenumber
set cursorline
set termguicolors
set background=dark
set showcmd
set laststatus=2
set wildmenu
set splitbelow splitright
set scrolloff=4
set clipboard=unnamedplus

" --- Desempenho ---
set lazyredraw
set ttyfast
set updatetime=500
set shortmess+=c
set noswapfile
set nobackup
set nowritebackup

" --- Indentação ---
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

" --- Busca ---
set hlsearch
set incsearch
set ignorecase
set smartcase

" --- Fechar automaticamente pares simples ---
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {}<Esc>i
inoremap " ""<Esc>i
inoremap ' ''<Esc>i

" --- Plugins com Vundle ---
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Aparência
Plugin 'sainnhe/gruvbox-material'
Plugin 'itchyny/lightline.vim'
Plugin 'ryanoasis/vim-devicons'

" Navegação e utilitários
Plugin 'preservim/nerdtree'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'tpope/vim-fugitive'

" Snippets e auto pares
Plugin 'jiangmiao/auto-pairs'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

" LSP e Autocomplete
Plugin 'neoclide/coc.nvim', {'branch': 'release'}

" Linguagens e sintaxe
Plugin 'sheerun/vim-polyglot'

call vundle#end()
filetype plugin indent on

" --- Tema ---
let g:gruvbox_material_background = 'medium'
let g:gruvbox_material_palette = 'mix'
colorscheme gruvbox-material

" --- Barra de status ---
let g:lightline = {
      \ 'colorscheme': 'gruvbox_material',
      \ 'active': {'left': [ ['mode', 'paste'], ['cocstatus', 'readonly', 'filename', 'modified'] ]},
      \ 'component_function': {'cocstatus': 'coc#status'}
      \ }

" --- COC ---
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-tsserver',
  \ 'coc-python',
  \ 'coc-clangd',
  \ 'coc-prettier'
  \ ]

" Teclas de autocomplete
inoremap <silent><expr> <C-Space> coc#refresh()
inoremap <silent><expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <silent><expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

" --- Snippets ---
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" --- Atalhos ---
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-f> :Rg<CR>
nnoremap <C-t> :terminal<CR>
nnoremap <leader>r :source $MYVIMRC<CR>

" --- Terminal integrado ---
autocmd TermOpen * startinsert
autocmd TermEnter * setlocal nonumber norelativenumber
EOF

# --- Instalar Plugins ---
echo "Instalando plugins do Vim com Vundle..."
vim +PluginInstall +qall

echo "✅ Instalação concluída com sucesso!"
echo "Abra o Vim e aproveite sua configuração Full Stack 🚀"
