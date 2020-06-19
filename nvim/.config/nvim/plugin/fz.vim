"""""""
" FZF "
"""""""

function! BuildLocationList(lines)
  " TODO: fix location list creation
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
let g:fzf_layout = {'window': 'call windows#floating(13)'}


"""""""
" FZY "
"""""""

function! s:OnBufDelete(bufnr) abort
  if has_key(g:__buffers, a:bufnr)
    call remove(g:__buffers, a:bufnr)
  endif
endfunction

let g:__buffers = get(g:, '__buffers', {})

augroup plugin_fz
  autocmd!
  autocmd BufDelete            * call s:OnBufDelete(+expand('<abuf>'))
  autocmd BufWinEnter,WinEnter * let g:__buffers[bufnr('')] = reltimefloat(reltime())
augroup END
