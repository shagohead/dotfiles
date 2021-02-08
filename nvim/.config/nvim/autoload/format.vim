function! format#PythonFormat()
  if mode() != 'n'
    return 1
  endif

  " TODO: reformat multiline strings
  let lines = getline(v:lnum, v:lnum + v:count - 1)
  echomsg string(lines)
  return 0
endfunction
