
"set viminfo+=!
set viminfo+=n./.viminfo

hi ColorColumn ctermbg=16

source ~/.vim/fraccents.vim

command! Bak :normal :!make b

function! s:InsertImageTag()
  let l:current = fnamemodify(trim(system('ls -1 -t posts/ | head -1')), ':r')
  exe "silent r! echo"
  exe "silent r! echo '<figure class=\"right\">'"
  exe "silent r! echo '<a href=\"\"><img src=\"images/" . l:current . "_xxx.jpg\" loading=\"lazy\" /></a>'"
  exe "silent r! echo '<figcaption>'"
  exe "silent r! echo '</figcaption>'"
  exe "silent r! echo '</figure>'"
endfunction " InsertImageTag
command! -nargs=0 Img :call <SID>InsertImageTag()

