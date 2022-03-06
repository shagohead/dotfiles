# FIXME: удалить не нужный файл

scriptencoding utf-8

function! tools#ProfileStart(...)
  if a:0 && a:1 != 1
    let l:profile_file = a:1
  else
    let l:profile_file = '/tmp/vim.'.getpid().'.'.reltimestr(reltime())[-4:].'profile.txt'
    echom 'Profiling into' l:profile_file
    let @* = l:profile_file
  endif
  exec 'profile start '.l:profile_file
  profile! file **
  profile  func *
endfun

" WhichKey calling interface
function! tools#which_key()
  echo 'Enter first key of mapping:'
  execute "WhichKey '".nr2char(getchar())."'"
  echo ''
endfunction
