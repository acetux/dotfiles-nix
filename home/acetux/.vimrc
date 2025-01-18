set nocompatible " Disable vi compatibility

syntax on " Turn on syntax highlighting

set number " Line numbers
"set relativenumber " Relative line numbers

set scrolloff=999 " Keep cursor line centered on screen
"set scrolloff=20 " Keep 20 lines below/above cursor line

" Make search more sane
set ignorecase " Case insensitive search
set smartcase " If there are uppercase letters, become case sensitive
set hlsearch " Highlight matches
set showmatch " Live match highlighting
set incsearch " Live incremental searching

" Tab = 4 spaces
set shiftwidth=4
set softtabstop=4
