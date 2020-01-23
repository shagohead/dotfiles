setlocal tabstop=4
setlocal textwidth=88
setlocal shiftwidth=4
setlocal expandtab

iab <buffer> pdb import pdb; pdb.set_trace()
iab <buffer> ipdb import ipdb; ipdb.set_trace()
nnoremap <buffer> <LocalLeader>l :CocCommand python.runLinting<CR>
execute "nmap <buffer> <LocalLeader>r :VimuxRunCommand '".runserver_command."'<CR>"
nnoremap <buffer> <LocalLeader>t :TestNearest<CR>
nnoremap <buffer> <LocalLeader>y :TestNearest -strategy=vimux<CR>
