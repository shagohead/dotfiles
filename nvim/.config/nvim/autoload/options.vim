" Toggle input mode options
function! options#toggle_imode()
  if(&iminsert == 1)
    set iminsert=0
    set imsearch=0
  else
    set iminsert=1
    set imsearch=1
  endif
endfunction

" Toggle relativenumber option
function! options#toggle_numbers()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunction


