" Make window smaller if it has less than 10 lines
function! windows#minimize()
  let l:lines = line('$')
  if l:lines < 10
    execute ':resize '.l:lines
  end
endfunction

" Opens floating window at the bottom of screen
function! windows#floating(lines, ...)
  let opts = a:0 > 0 ? a:1 : {}
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  if has_key(opts, 'filetype')
    call setbufvar(buf, '&filetype', get(opts, 'filetype'))
  endif

  let config = {
        \ 'relative': 'editor',
        \ 'width': &columns,
        \ 'height': a:lines,
        \ 'row': &lines - a:lines,
        \ 'col': 0,
        \ 'style': 'minimal'
        \ }
  let win = nvim_open_win(buf, v:true, config)
  call nvim_win_set_option(win, 'winhl', 'NormalFloat:Normal')

  if has_key(opts, 'winblend') && exists('&winblend')
    call setwinvar(win, '&winblend', get(opts, 'winblend'))
  endif
endfunction
