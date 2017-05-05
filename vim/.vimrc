syntax on
set number

set nocompatible              " required
filetype off                  " required
"set rtp+=~/.vim/bundle/vundle/
"call vundle#rc()

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim


call plug#begin('~/.vim/plugged')


Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }


call plug#end()

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <C-n> :NERDTreeToggle<CR>



"default colorscheme
colorscheme nord

filetype plugin indent on    " required

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |

au BufNewFile,BufRead *.js,*.html,*.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |

let python_highlight_all=1
syntax on

set  rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/
set laststatus=2
set t_Co=256
