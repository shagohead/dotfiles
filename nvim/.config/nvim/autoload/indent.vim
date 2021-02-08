function! indent#breadcrumbs() abort
  let l:breadcrumbs = []
  let l:current_line = getcurpos()[1]
  let l:current_indent = indent(l:current_line)

  if l:current_indent == 0 && l:current_line > 1
    while len(getline(l:current_line)) == 0
      let l:current_line -= 1
      let l:current_indent = indent(l:current_line)
    endwhile
  endif

  while l:current_line > 1
    let l:current_line -= 1
    let l:new_indent = indent(l:current_line)

    if l:new_indent < l:current_indent
      let l:line = getline(l:current_line)
      if len(l:line) == 0
        continue
      endif

      let l:current_indent = l:new_indent
      call add(l:breadcrumbs, l:line)
      if l:new_indent == 0
        break
      endif
    endif
  endwhile

  if len(l:breadcrumbs) > 0
    echohl Title | echon "Indentation breadcrumbs:" | echohl NONE
  endif

  for line in reverse(l:breadcrumbs)
    echo line
  endfor
endfunction
