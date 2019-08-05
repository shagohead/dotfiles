setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab

let b:ale_linters = ['flake8', 'pylint']

iab <buffer> pdb import pdb; pdb.set_trace()
iab <buffer> ipdb import ipdb; ipdb.set_trace()

nnoremap <buffer> <LocalLeader>i :ImportName<CR>
nnoremap <buffer> <LocalLeader>l :CocCommand python.runLinting<CR>
nnoremap <buffer> <LocalLeader>s :SortImports<CR>
