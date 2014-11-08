set tabstop=4
set softtabstop=4
set shiftwidth=4
set smartindent
"set cinoptions={0,1s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s
set nu
if has("syntax")
  syntax on
endif


set nocompatible
set backspace=2
set nobackup
set hlsearch 
set expandtab


set nocp
filetype plugin on
set langmenu=zh_CN.UTF-8
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
colorscheme torte 

function UpdateCscope()
    cs kill 0
    !buildcscope.sh
    cs add cscope.out
endfunction

map <C-F10>c :call UpdateCscope() <CR>
"set gfn=Consolas:h12


function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif /* " . gatename . " */"
  normal! kk
endfunction
map <C-F10>a :call <SID>insert_gates() <CR>
set guifont=Ubuntu\ Mono\ 16
set cscopequickfix=s-,c-,d-,i-,t-,e-
set showcmd
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

