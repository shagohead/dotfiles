" Toggle relativenumber option
function! options#toggle_numbers()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunction


