" WhichKey calling interface
function! mappings#which_key()
  echo 'Enter first key of mapping:'
  execute "WhichKey '".nr2char(getchar())."'"
  echo ''
endfunction

