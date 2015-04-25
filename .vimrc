syntax on
set tabstop=4
set shiftwidth=4
set autoindent
set number
"set foldmethod=syntax

nmap <C-h> :diffget LOCAL<CR>
nmap <C-l> :diffget REMOTE<CR>
nmap <C-k> [c
nmap <C-j> ]c

:nnoremap / /\v
:nnoremap s :%s/\v

set incsearch
set hlsearch
