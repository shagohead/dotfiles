" Add QuickFix item
function! quickfix#add() abort
  call setqflist([{
        \'bufnr': bufnr(),
        \'lnum': line('.'),
        \'col': col('.'),
        \'text': getline('.'),
        \}], 'a')
endfunction

function! quickfix#add_loc() abort
  call setloclist(0, [{
        \'bufnr': bufnr(),
        \'lnum': line('.'),
        \'col': col('.'),
        \'text': getline('.'),
        \}], 'a')
endfunction

" Toggle QuickFix window
function! quickfix#toggle() abort
  if len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')) > 0
    :cclose
  else
    :copen
  endif
endfunction
