function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

set pastetoggle=<F2>

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

nmap <Leader>tt :tab split<CR><C-]>
nmap <Leader>ty :tab split<CR>:YcmCompleter GoTo<CR>

nmap <Leader>\<BS> :echo ''<CR>
nmap <Leader>\<CR> :noh<CR>:echo ''<CR>
nmap <Leader>\[ :Files<CR>
nmap <Leader>\] :Tags<CR>
nmap <Leader>\e :CtrlP<CR>
nmap <Leader>\b :YcmCompleter GoTo<CR>
nmap <Leader>\y :YcmCompleter GoDoc<CR>
nmap <Leader>\l :YcmCompleter GoToReferences<CR>

map <C-j> :cn<CR>
map <C-k> :cp<CR>
