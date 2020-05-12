function! fzy#action_edit(result_value)
  execute "e ".a:result_value
endfunction

function fzy#action_tjump(result_value)
  echo a:result_value
endfunction

function! fzy#termopen(cmd, ctx)
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

  call windows#floating(11, {'filetype': 'fzy'})
  call termopen(a:cmd." > ".a:ctx.result_file, {
        \'on_exit': funcref('s:on_exit', [a:ctx]),
        \})
  startinsert
endfunction

function! fzy#command(source, ...)
  let ctx = {
        \'result_file': tempname(),
        \'action': get(a:, 1, function('fzy#action_edit'))
        \}

  if type(a:source) == v:t_list
    let ctx.source_file = tempname()
    let cmd = "fzy < ".ctx.source_file

    " Borrowed from vim-fzy
    if executable('mkfifo')
      call system('mkfifo '.ctx.source_file)
      call fzy#termopen(cmd, ctx)
      call writefile(a:source, ctx.source_file)
    else
      call writefile(a:source, ctx.source_file)
      call fzy#termopen(cmd, ctx)
    endif

  else
    call fzy#termopen(a:source." | fzy", ctx)
  end
endfunction

function! fzy#files()
  call fzy#command('fd')
endfunction

" Stolen from vim-clap
function! fzy#util_buflisted() abort
  return filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&filetype") !=# "qf"')
endfunction

" Stolen from vim-clap (which borred from fzf)
function! s:sort_buffers(...) abort
  let [b1, b2] = map(copy(a:000), 'get(g:__clap_buffers, v:val, v:val)')
  " Using minus between a float and a number in a sort function causes an error
  return b1 < b2 ? 1 : -1
endfunction

" Stolen from vim-clap
function! fzy#util_buflisted_sorted() abort
  return sort(fzy#util_buflisted(), 's:sort_buffers')
endfunction

function! fzy#history()
  " Stolen from vim-clap and modified for local history
  call fzy#command(uniq(map(
        \ filter (
        \   filter([expand('%')], 'len(v:val)')
        \   + filter(map(fzy#util_buflisted_sorted(), 'bufname(v:val)'), 'len(v:val)')
        \   + filter(copy(v:oldfiles), "filereadable(fnamemodify(v:val, ':p'))"),
        \   'v:val =~ "^'.getcwd().'"'
        \ ),
        \ 'fnamemodify(v:val, ":~:.")')))
endfunction

function! fzy#tags()
  call fzy#command(map(taglist('.*'), 'v:val.name'), function('fzy#action_tjump'))
endfunction
