setlocal tabstop=4
setlocal textwidth=88
setlocal shiftwidth=4
setlocal expandtab
setlocal dictionary+=~/.config/nvim/dictionary/python
setlocal formatoptions-=t
setlocal formatoptions+=ro
setlocal formatexpr=format#PythonFormat()
setlocal nojoinspaces

ia <buffer> pdb import pdb; pdb.set_trace()
ia <buffer> ipdb import ipdb; ipdb.set_trace()

nnoremap <buffer> <LocalLeader>l :CocCommand python.runLinting<CR>
