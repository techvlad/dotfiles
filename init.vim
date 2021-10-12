
" Plugins
call plug#begin("~/.vim/plugged")

Plug 'joshdick/onedark.vim'

call plug#end()

" Enable line numbers
set number

""" Colorscheme setup
" Enable truecolor if can
if (has("termguicolors"))
    set termguicolors
endif
colorscheme onedark
