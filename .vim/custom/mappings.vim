" Set map variables
set pastetoggle=<F2>
let mapleader="\<SPACE>"

" One-key (with or w/o modifier) mappigns
nnoremap { gT
nnoremap } gt
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-p> "0p
vnoremap <C-p> "0p
inoremap <silent><expr> <c-x> coc#refresh()

" Two-key (with or w/o modifier) mappigns
nmap <silent> [q :cp<CR>
nmap <silent> ]q :cn<CR>

nmap <silent> [d <Plug>(coc-diagnostic-prev)<CR>
nmap <silent> ]d <Plug>(coc-diagnostic-next)<CR>

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
  if len(qfall) > 0
    execute curqfidx + 1 . "cfirst"
    :copen
  else
    :cclose
  endif
endfunction
command! RemoveQFItem :call RemoveQFItem()
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>

" Messages cleanup
nmap <silent> <Leader><BS> :echo ''<CR>
nmap <silent> <Leader><CR> :noh<CR>:echo ''<CR>
" Fix syntax highlighting
nmap <Leader>s :syntax sync fromstart<CR>
" Workspace files
nmap <Leader>f :Files<CR>
" Directory local files
nmap <Leader>l :DirFiles<CR>
" Workspace tags
nmap <Leader>t :Tags<CR>
" CtrlP
nmap <Leader>e :CtrlP<CR>

" GoTo
nmap <Leader>gt :tab split<CR><C-]>
nmap <Leader>gd :tab split<CR><Plug>(coc-definition)

" Diagonostics
nmap <leader>dl :CocList diagnostics<CR>
nmap <leader>di <Plug>(coc-diagnostic-info)<CR>

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)
" Remap for do codeAction of current line
nmap <leader>ac <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf <Plug>(coc-fix-current)
"
" Remap for format selected region
nmap <leader>rf <Plug>(coc-format-selected)
vmap <leader>rf <Plug>(coc-format-selected)
