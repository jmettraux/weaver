
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
command! Img :call <SID>InsertImageTag()


function! s:InsertTwitterImageLine()
  let l:current = fnamemodify(trim(system('ls -1 -t posts/ | head -1')), ':r')
  exe "silent r! echo 'twitter_image: \"images/" . l:current . "_q_xxx.jpg\"'"
endfunction " InsertTwitterImageLine
command! Timg :call <SID>InsertTwitterImageLine()

command! Emdash :normal a—<ESC>
command! Semdash :normal :%s/ - / — /g<CR>

command! Fav :normal i <img id="favourite" style="height: 10pt; margin-left: 1rem; margin-top: 0.3rem;" title="a favourite" src="images/crown.svg"></img> <ESC>

command! Attri :normal 0o><CR>> <span class="attribution"><a href=""></a></span><ESC>

