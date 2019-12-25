let g:quickfixlists = {}

" Toggle QuickFix window
function! quickfix#toggle() abort
  if len(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')) > 0
    :cclose
  else
    :copen
  endif
endfunction

" Clear QuickFix list
function! quickfix#clear() abort
  cclose
  call setqflist([], 'r')
endfunction

" Save QuickFix list in variable
function! quickfix#save() abort
  let l:initial = input("Save QF list with key (in form: `key:[message]`): ")
  if len(l:initial) < 1
    return
  endif

  let l:initial_list = split(l:initial, ":")
  let l:key = l:initial_list[0]
  let l:message = ""
  if len(l:initial_list) > 1
    let l:message = l:initial_list[1]
  endif

  let g:quickfixlists[l:key] = {'message': l:message, 'list': getqflist()}
  echo "\n"
  echom "QuickFix list saved at key " . l:key
endfunction

" Load QuickFix list from variable
function! quickfix#load()
  cclose
  let l:available = []

  for key in keys(g:quickfixlists)
    let l:message = g:quickfixlists[l:key].message
    if l:message
      let l:title = " - " . l:key . ":" . l:message
    else
      let l:title = " - " . l:key
    endif
    call add(l:available, l:title)
  endfor

  if len(l:available) < 1
    echo "There is no save QuickFix lists"
    return
  endif

  let l:available_str = join(l:available, "\n")
  let l:key = input("Available lists:\n" . l:available_str . "\nEnter list key: ")
  if len(l:key) < 1
    echo "\nQuickFixLoad aborted"
    return
  endif

  if !has_key(g:quickfixlists, l:key)
    echo "\nThere is no saved list with key: " . l:key
    return
  endif

  call setqflist(g:quickfixlists[l:key].list, 'r')
  copen
endfunction

" Delete item form QuickFix list
function! quickfix#remove() abort
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  if len(qfall) > 0
    execute curqfidx + 1 . "cfirst"
    :copen
  else
    :cclose
  endif
endfunction

