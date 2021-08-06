" Show highlighting groups for current word
" https://twitter.com/kylegferg/status/697546733602136065
function! syntax#SynStack() abort
  if !exists('*synstack')
    return
  endif
  echo map(synstack(line('.'), col('.')), "synIDattr(v:val, 'name')")
endfunc

let g:GabriQuitOnQ = ['preview', 'qf', 'fzf', 'netrw', 'help', 'taskedit', 'diff']
function! syntax#should_quit_on_q() abort
  return &diff || index(g:GabriQuitOnQ, &filetype) >= 0
endfunction

let g:GabriNoColorcolumn = [
      \'qf',
      \'fzf',
      \'netrw',
      \'help',
      \'markdown',
      \'startify',
      \'GrepperSide',
      \'text',
      \'gitconfig',
      \'gitrebase',
      \'conf',
      \'tags',
      \'vimfiler',
      \'dos',
      \'json'
      \'diff'
      \]
function! syntax#should_turn_off_colorcolumn() abort
  return &textwidth == 0
        \|| &diff
        \|| index(g:GabriNoColorcolumn, &filetype) >= 0
        \|| &buftype ==# 'terminal' || &readonly
endfunction

function! syntax#setOverLength()
  if syntax#should_turn_off_colorcolumn()
    match NONE
  else
    " Stolen from https://github.com/whatyouhide/vim-lengthmatters/blob/74e248378544ac97fb139803b39583001c83d4ef/plugin/lengthmatters.vim#L17-L33
    let s:overlengthCmd = 'highlight OverLength'
    for l:md in ['cterm', 'term', 'gui']
      let l:bg = syntax#get_color('WildMenu', 'bg', l:md)
      let l:fg = syntax#get_color('Normal', 'fg', l:md)

      if has('gui_running') && l:md !=# 'gui'
        continue
      endif

      if !empty(l:bg) | let s:overlengthCmd .= ' ' . l:md . 'bg=' . l:bg | endif
      if !empty(l:fg) | let s:overlengthCmd .= ' ' . l:md . 'fg=' . l:fg | endif
    endfor
    exec s:overlengthCmd
    " Use tw + 1 so invisble characters are not marked
    let s:overlengthSize = &textwidth
    execute 'match OverLength /\%>'. s:overlengthSize .'v.*/'
  endif
endfunction

function! syntax#get_color(synID, what, mode) abort
  return synIDattr(synIDtrans(hlID(a:synID)), a:what, a:mode)
endfunction

function! syntax#GetIcon(key) abort
  let l:ICONS = {
        \'paste': '⍴',
        \'spell': '✎',
        \'branch': exists($PURE_GIT_BRANCH) ? trim($PURE_GIT_BRANCH) : '  ',
        \'error': '×',
        \'info': '●',
        \'warn': '!',
        \'hint': '?',
        \'lock': ' ',
        \}

  return get(l:ICONS, a:key, a:key)
endfunction

function! syntax#update_colors()
  if stridx(g:colors_name, 'light') > -1
    set background=light
  endif

  hi CurrentWord cterm=undercurl gui=undercurl
  hi CursorLineNr cterm=NONE gui=NONE ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
  hi LineNr ctermbg=NONE guibg=NONE
  hi MatchParen cterm=bold,underline gui=bold,underline ctermbg=NONE guibg=NONE
  hi SignColumn ctermbg=NONE guibg=NONE
  hi StatusLine ctermbg=NONE guibg=NONE
  hi StatusLineNC ctermbg=NONE guibg=NONE
  hi TabLine ctermbg=NONE guibg=NONE
  hi TabLineFill ctermbg=NONE guibg=NONE
  hi TabLineSel ctermbg=NONE guibg=NONE
  hi VertSplit ctermbg=NONE guibg=NONE
  hi! link Comment Special

  if &background == 'dark'
    hi Cursor guibg=Cyan
    hi User3 guifg=Cyan
    hi link LspDiagnosticsSignError WarningMsg
    hi link LspDiagnosticsVirtualTextError WarningMsg
  else
    hi Cursor guibg=DarkCyan
    hi User3 guifg=DarkCyan
  endif

  exec 'hi User4 guifg='.(syntax#get_color('NonText', 'fg', 'gui'))
  exec 'hi User5 guifg='.(syntax#get_color('ErrorMsg', 'fg', 'gui'))
endfunction

function! syntax#search_with_skip(pattern, flags, stopline, timeout, skip)
  "
  " Returns true if a match is found for {pattern}, but ignores matches
  " where {skip} evaluates to false. This allows you to do nifty things
  " like, say, only matching outside comments, only on odd-numbered lines,
  " or whatever else you like.
  "
  " Mimics the built-in search() function, but adds a {skip} expression
  " like that available in searchpair() and searchpairpos().
  " (See the Vim help on search() for details of the other parameters.)
  "
  " Note the current position, so that if there are no unskipped
  " matches, the cursor can be restored to this location.
  "
  let l:matchpos = getpos('.')

  " Avoid invinite loop
  let l:guard = []

  " Loop as long as {pattern} continues to be found.
  "
  while search(a:pattern, a:flags, a:stopline, a:timeout) > 0

    if l:guard == []
      let l:guard = getpos('.')
    elseif l:guard == getpos('.')
      break
    endif

    " If {skip} is true, ignore this match and continue searching.
    "
    if eval(a:skip)
      continue
    endif

    " If we get here, {pattern} was found and {skip} is false,
    " so this is a match we don't want to ignore. Update the
    " match position and stop searching.
    "
    let l:matchpos = getpos('.')
    break

  endwhile

  " Jump to the position of the unskipped match, or to the original
  " position if there wasn't one.
  "
  call setpos('.', l:matchpos)
endfunction

function! syntax#search_outside(synName, pattern)
  "
  " Searches for the specified pattern, but skips matches that
  " exist within the specified syntax region.
  "
  call syntax#search_with_skip(a:pattern, '', '', '',
        \ 'synIDattr(synID(line("."), col("."), 0), "name") =~? "' . a:synName . '"' )
endfunction

function! syntax#search_inside(synName, pattern)
  "
  " Searches for the specified pattern, but skips matches that don't
  " exist within the specified syntax region.
  "
  call syntax#search_with_skip(a:pattern, '', '', '',
        \ 'synIDattr(synID(line("."), col("."), 0), "name") !~? "' . a:synName . '"' )
endfunction
