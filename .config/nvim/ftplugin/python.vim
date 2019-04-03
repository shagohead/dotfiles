set tabstop=4
set shiftwidth=4
set expandtab

let b:ale_linters = ['flake8', 'pylint']

iab pdb import pdb; pdb.set_trace()
iab ipdb import ipdb; ipdb.set_trace()
