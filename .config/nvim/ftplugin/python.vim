set tabstop=4
set shiftwidth=4
set expandtab

let b:ale_linters = ['flake8', 'pylint']

iab pdb import pdb; pdb.set_trace()
iab ipdb import ipdb; ipdb.set_trace()

nmap <silent> [h :Semshi goto name prev<CR>
nmap <silent> ]h :Semshi goto name next<CR>
nmap <silent> [H :Semshi goto name first<CR>
nmap <silent> ]H :Semshi goto name last<CR>

nmap <silent> [k :Semshi goto class prev<CR>
nmap <silent> ]k :Semshi goto class next<CR>
nmap <silent> [K :Semshi goto class first<CR>
nmap <silent> ]K :Semshi goto class last<CR>

nnoremap <silent> [f :Semshi goto function prev<CR>
nnoremap <silent> ]f :Semshi goto function next<CR>
nnoremap <silent> [F :Semshi goto function first<CR>
nnoremap <silent> ]F :Semshi goto function last<CR>
