" Set map variables
set pastetoggle=<F2>
let mapleader="\<SPACE>"

" One-key (with or w/o modifier) mappigns
nnoremap { gT
nnoremap } gt
nnoremap <C-p> "0p
vnoremap <C-p> "0p
inoremap <silent><expr> <c-x> coc#refresh()

nmap <C-a> :ALENext<CR>
nmap <C-j> :cn<CR>
nmap <C-k> :cp<CR>

" Two-key (with or w/o modifier) mappigns
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Tab & S-Tab for completion menu navigation
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Documentation preview
nnoremap <silent> Y :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Delete item form QuickFix list
function! RemoveQFItem()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . "cfirst"
  :copen
endfunction
command! RemoveQFItem :call RemoveQFItem()
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>

" Leader <a>(ale) prefixed maps
nmap <Leader>al :ALELint<CR>
nmap <Leader>ai :ALEInfo<CR>
nmap <Leader>ad :ALEDetail<CR>
nmap <Leader>af :ALEFix<CR>
nmap <Leader>an :ALENext<CR>
nmap <Leader>ap :ALEPrevious<CR>
nmap <Leader>ar :ALEResetBuffer<CR>

" Leader <g>(goto) prefixed maps
nmap <Leader>gt :tab split<CR><C-]>
nmap <Leader>gd :tab split<CR><Plug>(coc-definition)

" Leader one-key maps
nmap <silent> <Leader><BS> :echo ''<CR>
nmap <silent> <Leader><CR> :noh<CR>:echo ''<CR>
nmap <Leader>s :syntax sync fromstart<CR>
nmap <Leader>f :Files<CR>
nmap <Leader>d :DirFiles<CR>
nmap <Leader>t :Tags<CR>
nmap <Leader>e :CtrlP<CR>
