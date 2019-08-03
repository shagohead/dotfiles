setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab

let b:ale_linters = ['flake8', 'pylint']

iab pdb import pdb; pdb.set_trace()
iab ipdb import ipdb; ipdb.set_trace()
