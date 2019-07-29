command! -bang -nargs=* Find
      \ call fzf#vim#grep('rg
      \ --column --line-number
      \ --no-heading --fixed-strings
      \ --ignore-case --no-ignore
      \ --hidden --follow
      \ --glob "!.git/*" --color "always"
      \ '.shellescape(<q-args>), 1, <bang>0)

function! s:edit_devicon_prepended_file(item)
  let l:file_path = a:item[4:-1]
  execute 'silent e' l:file_path
endfunction

" TODO: add initial path from argument (DirFiles are broken)
" TODO: fix broken hotkeys
" try:
"   - call wrap to get sink function and options
"   - call custom sink with wrapper data
"
command! -bang -nargs=? -complete=dir Files
      \ call fzf#run({
      \ 'source': $FZF_DEFAULT_COMMAND.' | devicon-lookup',
      \ 'sink': function('s:edit_devicon_prepended_file'),
      \ 'window': '13new'})
      " \ call fzf#run(fzf#wrap('files', {
      " \ 'options': '--expect=ctrl-v,ctrl-x,ctrl-l,ctrl-t', 
      " \ 'source': $FZF_DEFAULT_COMMAND.' | devicon-lookup',
      " \ 'sink': function('s:edit_devicon_prepended_file'),
      " \ '_action': {
      "   \ 'ctrl-v': 'vsplit',
      "   \ 'ctrl-x': 'split',
      "   \ 'ctrl-l': function('<SNR>20_build_quickfix_list'),
      "   \ 'ctrl-t': 'tab split'}
      " \ }))

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_tags_command = 'ctags.sh'
let g:fzf_layout = {'window': '13new'}
let g:fzf_action = {
      \ 'ctrl-l': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit'}

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

" autocmd! FileType fzf
" autocmd  FileType fzf set laststatus=0 noshowmode noruler
"   \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
