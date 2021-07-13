scriptencoding utf-8

function! statusline#rhs() abort
  return winwidth(0) > 80 ? printf('%02d/%02d:%02d', line('.'), line('$'), col('.')) : ''
endfunction

function! statusline#fileSize() abort
  let l:size = getfsize(expand('%'))
  if l:size == 0 || l:size == -1 || l:size == -2
    return ''
  endif
  if l:size < 1024
    return l:size.' bytes'
  elseif l:size < 1024*1024
    return printf('%.1f', l:size/1024.0).'k'
  elseif l:size < 1024*1024*1024
    return printf('%.1f', l:size/1024.0/1024.0) . 'm'
  else
    return printf('%.1f', l:size/1024.0/1024.0/1024.0) . 'g'
  endif
endfunction

function! statusline#getDiffColors() abort
  return ['%#DiffDelete#', '%#DiffChange#', '%#DiffAdd#', '%#DiffText#']
endfunction

function! statusline#coc_diagnostic_info() abort
  let l:info = get(b:, 'coc_diagnostic_info', {})
  if empty(l:info)
    return ''
  endif

  let [l:DELETE, l:CHANGE, l:ADD, l:TEXT] = statusline#getDiffColors()
  let l:msgs = []
  if get(l:info, 'error', 0)
    call add(l:msgs, printf('%s%d %s %%*', l:DELETE,  l:info['error'] , syntax#GetIcon('error')))
  endif
  if get(info, 'warning', 0)
    call add(l:msgs, printf('%s%d %s %%*', l:CHANGE,  l:info['warning'] , syntax#GetIcon('warn')))
  endif

  return join(l:msgs, ' ')
endfunction

function! statusline#gitInfo() abort
  if !exists('*fugitive#head')
    return ''
  endif

  let l:out = fugitive#head(10)
  if !empty(l:out)
    let l:out = syntax#GetIcon('branch') . l:out
  endif
  return l:out
endfunction

function! statusline#readOnly() abort
  if !&modifiable && &readonly
    return syntax#GetIcon('lock') . ' RO'
  elseif &modifiable && &readonly
    return 'RO'
  elseif !&modifiable && !&readonly
    return syntax#GetIcon('lock')
  else
    return ''
  endif
endfunction

function! statusline#lsp_status() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

function! statusline#filepath() abort
  let l:filename = expand('%:~:.:t')
  let l:base = expand('%:~:.:h')
  let l:prefix = empty(l:base) || l:base ==# '.' ? '' : l:base.'/'
  let [l:DELETE, l:CHANGE, l:ADD, l:TEXT] = statusline#getDiffColors()

  if isdirectory(expand('%'))
    return '%4* Dirvish%*'
  elseif empty(l:prefix) && empty(l:filename)
    return printf('%%4* %%f%%* %s%%*', &modified ? l:CHANGE . '-' . '%*' : '%4*')
  else
    return printf('%%4* %s%%*%s%s%%*', l:prefix, &modified ? l:CHANGE : '%6*', l:filename)
  endif
endfunction

" :h mode() to see all modes
let s:dictmode={
      \'no'     : 'N-Operator Pending',
      \'v'      : 'V.',
      \'V'      : 'V·Line',
      \"\<C-V>" : 'V·Block',
      \'s'      : 'S.',
      \'S'      : 'S·Line',
      \"\<C-S>" : 'S·Block.',
      \'i'      : 'I.',
      \'ic'     : 'I·Compl',
      \'ix'     : 'I·X-Compl',
      \'R'      : 'R.',
      \'Rc'     : 'Compl·Replace',
      \'Rx'     : 'V·Replace',
      \'Rv'     : 'X-Compl·Replace',
      \'c'      : 'Command',
      \'cv'     : 'Vim Ex',
      \'ce'     : 'Ex',
      \'r'      : 'Propmt',
      \'rm'     : 'More',
      \'r?'     : 'Confirm',
      \'!'      : 'Sh',
      \'t'      : 'T.',
      \}

exec printf('hi! StatusLine gui=NONE cterm=NONE guibg=NONE ctermbg=NONE guifg=%s ctermfg=%s', syntax#get_color('Identifier', 'fg', 'gui'), syntax#get_color('Identifier', 'fg', 'cterm'))

function! statusline#getMode() abort
  return get(s:dictmode, mode(), mode() ==# 'n' ? '' : mode().' NOT IN MAP')
endfunction
