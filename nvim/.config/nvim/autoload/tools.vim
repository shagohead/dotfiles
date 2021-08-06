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

function! tools#action_edit(result_value)
  execute "e ".a:result_value
endfunction

function tools#action_tjump(result_value)
  echo a:result_value
endfunction

function! tools#termopen(cmd, ctx)
  function! s:on_exit(ctx, job_id, data, event)
    close
    if filereadable(a:ctx.result_file)
      try
        call a:ctx.action(readfile(a:ctx.result_file)[0])
      catch /^Vim\%((\a\+)\)\=:E684/
      endtry
    end

    call delete(a:ctx.result_file)
    if has_key(a:ctx, 'source_file')
        call delete(a:ctx.source_file)
    endif
  endfunction

  call tools#floating_window(11, {'filetype': 'fzy'})
  call termopen(a:cmd." > ".a:ctx.result_file, {
        \'on_exit': funcref('s:on_exit', [a:ctx]),
        \})
  startinsert
endfunction

function! tools#command(source, ...)
  let ctx = {
        \'result_file': tempname(),
        \'action': get(a:, 1, function('tools#action_edit'))
        \}

  if type(a:source) == v:t_list
    let ctx.source_file = tempname()
    let cmd = "fzy < ".ctx.source_file

    " Borrowed from vim-fzy
    if executable('mkfifo')
      call system('mkfifo '.ctx.source_file)
      call tools#termopen(cmd, ctx)
      call writefile(a:source, ctx.source_file)
    else
      call writefile(a:source, ctx.source_file)
      call tools#termopen(cmd, ctx)
    endif

  else
    call tools#termopen(a:source." | fzy", ctx)
  end
endfunction

function! tools#files()
  call tools#command('fd')
endfunction

" Stolen from vim-clap
function! tools#util_buflisted() abort
  return filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&filetype") !=# "qf"')
endfunction

" Stolen from vim-clap (which borred from fzf)
function! s:sort_buffers(...) abort
  let [b1, b2] = map(copy(a:000), 'get(g:__buffers, v:val, v:val)')
  " Using minus between a float and a number in a sort function causes an error
  return b1 < b2 ? 1 : -1
endfunction

" Stolen from vim-clap
function! tools#util_buflisted_sorted() abort
  return sort(tools#util_buflisted(), 's:sort_buffers')
endfunction

function! tools#history()
  " Stolen from vim-clap and modified for local history
  call tools#command(uniq(map(
        \   filter([expand('%')], 'len(v:val)')
        \   + filter(map(tools#util_buflisted_sorted(), 'bufname(v:val)'), 'len(v:val)')
        \   + filter(copy(v:oldfiles), 'v:val =~ "^'.getcwd().'"'),
        \ 'fnamemodify(v:val, ":~:.")')))
        " \   + filter(filter(copy(v:oldfiles), "filereadable(fnamemodify(v:val, ':p'))"), 'v:val =~ "^'.getcwd().'"'),
endfunction

function! tools#tags()
  call tools#command(map(taglist('.*'), 'v:val.name'), function('tools#action_tjump'))
endfunction

" WhichKey calling interface
function! tools#which_key()
  echo 'Enter first key of mapping:'
  execute "WhichKey '".nr2char(getchar())."'"
  echo ''
endfunction
