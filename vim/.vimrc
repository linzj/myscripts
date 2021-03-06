set tabstop=2
set softtabstop=2
set shiftwidth=2
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
  let gatename = substitute(substitute(toupper(expand("%:t")), "\\.", "_", "g"), "-", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename
  execute "normal! Go#endif  // " . gatename
  normal! kk
endfunction
map <C-F10>a :call <SID>insert_gates() <CR>
set guifont=Ubuntu\ Mono\ 18
set cscopequickfix=s-,c-,d-,i-,t-,e-
set showcmd
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
nnoremap <silent> <F12> :bn<CR>
nnoremap <silent> <S-F12> :bp<CR>
au VimEnter * if &diff | execute 'windo set wrap' | endif
if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
endif

com! -nargs=1 Search :let @/='\V'.escape(<q-args>, '\\')| normal! n
