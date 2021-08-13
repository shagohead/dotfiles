scriptencoding utf-8

function! tools#execute_macro_over_visual_range() abort
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Opens floating window at the bottom of screen
function! tools#floating_window(lines, ...)
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

" Make window smaller if it has less than 10 lines
function! tools#minimize_window()
  let l:lines = line('$')
  if l:lines < 10
    execute ':resize '.l:lines
  end
endfunction

function! tools#OpenFileFolder() abort
  silent call system('open '.expand('%:p:h:~'))
endfunction

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
