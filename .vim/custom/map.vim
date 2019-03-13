function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

set pastetoggle=<F2>

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

nnoremap { gT
nnoremap } gt
nnoremap <C-p> "1p

nmap <C-j> :cn<CR>
nmap <C-k> :cp<CR>
nmap <C-a> :ALENext<CR>

nmap <Leader>al :ALELint<CR>
nmap <Leader>ai :ALEInfo<CR>
nmap <Leader>ad :ALEDetail<CR>
nmap <Leader>af :ALEFix<CR>
nmap <Leader>an :ALENext<CR>
nmap <Leader>ap :ALEPrevious<CR>
nmap <Leader>ar :ALEResetBuffer<CR>

nmap <Leader>tt :tab split<CR><C-]>
nmap <Leader>ty :tab split<CR>:YcmCompleter GoTo<CR>

nmap <Leader>\<BS> :echo ''<CR>
nmap <Leader>\<CR> :noh<CR>:echo ''<CR>
nmap <Leader>\p :DirFiles<CR>
nmap <Leader>\[ :Files<CR>
nmap <Leader>\] :Tags<CR>
nmap <Leader>\e :CtrlP<CR>
nmap <Leader>\\ :CtrlP<CR>
nmap <Leader>\b :YcmCompleter GoTo<CR>
nmap <Leader>\y :YcmCompleter GoDoc<CR>
nmap <Leader>\l :YcmCompleter GoToReferences<CR>
