scriptencoding utf-8
" [TODO]: Cleanup this file

function! utils#setupWrapping() abort
  set wrap
  set wrapmargin=2
  set textwidth=80
endfunction

function! utils#has_floating_window() abort
  " MenuPopupChanged was renamed to CompleteChanged -> https://github.com/neovim/neovim/pull/9819
  " https://github.com/neoclide/coc.nvim/wiki/F.A.Q#how-to-make-preview-window-shown-aside-with-pum
  return (exists('##MenuPopupChanged') || exists('##CompleteChanged')) && exists('*nvim_open_win') || (has('textprop') && has('patch-8.1.1522'))
endfunction

" Find references with grep
function! utils#grep_references()
  let l:word = expand('<cword>')
  if len(l:word) < 1
    echo 'There is no word under cursor'
  else
    " let l:ext = expand('%:e')
    " let l:shell = "rg --column --line-number --no-heading --color=always --smart-case
    "       \ --type-add '".l:ext.":*.".l:ext."' -t".l:ext." "
    " call fzf#vim#grep(l:shell.shellescape(l:word), 1, 0)
    execute 'Clap grep ++query='.l:word
  endif
endfunction

function! utils#check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! utils#show_documentation() abort
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
