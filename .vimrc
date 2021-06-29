
"set viminfo+=!
set viminfo+=n./.viminfo

hi ColorColumn ctermbg=16

source ~/.vim/fraccents.vim

command! Bak :normal :!make b

nnoremap <leader>d :call JmDictLookup(expand('<cword>'))

