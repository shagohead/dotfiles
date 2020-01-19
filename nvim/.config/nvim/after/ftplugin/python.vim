setlocal tabstop=4
setlocal textwidth=88
setlocal shiftwidth=4
setlocal expandtab

iab <buffer> pdb import pdb; pdb.set_trace()
iab <buffer> ipdb import ipdb; ipdb.set_trace()
nnoremap <buffer> <LocalLeader>l :CocCommand python.runLinting<CR>
