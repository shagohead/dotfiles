function! BuildLocationList(lines)
  call setloclist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

function! BuildQuickfixList(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

function! s:buffsink(lines)
  if len(a:lines) < 2
    return
  endif

  let Cmd = get(get(g:, 'fzf_action'), a:lines[0])
  if type(Cmd) == type('')
    execute 'silent' Cmd
  elseif a:lines[0] == 'alt-d'
    let buffers = []
    for line in a:lines[1:]
      call add(buffers, matchstr(line, '\[\zs[0-9]*\ze\]'))
    endfor
    " TODO: only non-active buffers: execute('buffers a')
    execute 'bdelete' join(buffers, ' ')
    return
  else
    let b = matchstr(a:lines[1], '\[\zs[0-9]*\ze\]')
    execute 'buffer' b
  endif
endfunction

command! -bar -bang -nargs=? -complete=buffer Buffers
      \ call fzf#vim#buffers(<q-args>, {
      \ 'sink*': function('s:buffsink'),
      \ 'options': '--multi --expect alt-d',
      \ }, <bang>0)
command! DirFiles Files %:h
command! -bang -nargs=* Find
      \ call fzf#vim#grep('rg
      \ --column --line-number
      \ --no-heading --fixed-strings
      \ --ignore-case --no-ignore
      \ --hidden --follow
      \ --glob "!.git/*" --color "always"
      \ '.shellescape(<q-args>), 1, <bang>0)

let g:fzf_action = {
      \ 'ctrl-f': function('BuildQuickfixList'),
      \ 'ctrl-l': function('BuildLocationList'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit'}
let g:fzf_tags_command = 'ctags.sh'

if has('nvim')
  function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)
    call setbufvar(buf, '&signcolumn', 'no')
    let opts = {
          \ 'relative': 'editor',
          \ 'width': &columns,
          \ 'height': 13,
          \ 'row': &lines - 13,
          \ 'col': 0,
          \ 'style': 'minimal'
          \ }
    let win = nvim_open_win(buf, v:true, opts)
    call nvim_win_set_option(win, 'winhl', 'NormalFloat:Normal')
  endfunction

  let g:fzf_layout = {'window': 'call FloatingFZF()'}
else
  " TODO: vim8 popups
  function! FloatingFZF()
    let buf = bufadd('')
    call setbufvar(buf, '&signcolumn', 'no')
    return popup_create(buf, {
          \ 'line': 13,
          \ 'col': 0,
          \ 'pos': 'topleft',
          \ 'maxheight': 23,
          \ 'minheight': 13,
          \ 'wrap': v:false,
          \ 'drag': v:false,
          \ 'highlight': 'Normal',
          \ 'padding': [0, 0, 0, 0],
          \ 'border': [0, 0, 0, 0]
          \ })
  endfunction

  let g:fzf_layout = {'window': '13new'}
endif
