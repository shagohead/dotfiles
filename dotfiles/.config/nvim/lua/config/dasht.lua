return function()
  vim.cmd([[
  nnoremap <silent> <Leader>K :call Dasht(dasht#cursor_search_terms())<CR>
  nnoremap <silent> <Leader><Leader>K :call Dasht(dasht#cursor_search_terms(), '!')<CR>
  vnoremap <silent> <Leader>K y:<C-U>call Dasht(getreg(0))<CR>
  vnoremap <silent> <Leader><Leader>K y:<C-U>call Dasht(getreg(0), '!')<CR>
  let g:dasht_filetype_docsets = {}
  let g:dasht_filetype_docsets['sh'] = ['Bash']
  let g:dasht_filetype_docsets['go'] = ['Go']
  let g:dasht_filetype_docsets['python'] = ['Python_3']
  let g:dasht_filetype_docsets['sql'] = ['PostgreSQL']
  ]])
end
