"-------------Plugins--------------"

set nocompatible              " be iMproved, required
filetype off                  " required

" vim-plug: https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-vinegar'
Plug 'preservim/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'StanAngeloff/php.vim'
Plug 'arnaud-lb/vim-php-namespace'
Plug 'godlygeek/tabular'
Plug 'jiangmiao/auto-pairs'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'ervandew/supertab'

call plug#end()

filetype plugin indent on    " required
