""" Plugins
call plug#begin("~/.vim/plugged")

Plug 'joshdick/onedark.vim' " Color schema
Plug 'vim-airline/vim-airline' " Fancy airlines
Plug 'ntpeters/vim-better-whitespace' " Whitespace hightlight
Plug 'nathanaelkane/vim-indent-guides' " Indent level

call plug#end()

set number

""" Colorscheme setup
" Enable truecolor if can
if (has("termguicolors"))
    set termguicolors
endif
colorscheme onedark

""" Personal settings
set number " Enable line numbers
set nowrap " Do not wrap lines
set mouse=a " Enable full mouse support
set autoread " Read file when changing from outside
set textwidth=80 " Plain text automatic line break
set colorcolumn=80,120 " Hightlight column
set noshowmode " Disable unnecessary -- INSERT --
set incsearch " Show matches while typing search pattern
set ignorecase " Ignorecase while search
set magic " Enable RegExp in search pattern
set fileencodings=utf-8,cp1251,koi8-r,cp866 " Default file encodings
set cursorline " Enable cursorline
set listchars=space:·,tab:│\ ,eol:¬ " Invisible chars
set list " Show invisible chars
set clipboard=unnamedplus " Use system clipboard by default
" Enable automatic indentation
set smarttab
set smartindent
set autoindent

" Better Whitespace
highlight ExtraWhitespace guibg=#E06C75

