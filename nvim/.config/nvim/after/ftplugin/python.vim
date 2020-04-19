setlocal tabstop=4
setlocal textwidth=88
setlocal shiftwidth=4
setlocal expandtab
setlocal formatoptions-=t
setlocal dictionary+=~/.config/nvim/dictionary/python

iab <buffer> pdb import pdb; pdb.set_trace()
iab <buffer> ipdb import ipdb; ipdb.set_trace()
iab <buffer> " """"""
iab <buffer>  """"""

" nnoremap <buffer> <LocalLeader>i :call python#sort_imports()<CR>
nnoremap <buffer> <LocalLeader>l :CocCommand python.runLinting<CR>

function! python#sort_imports() abort
  let l:source = getline(1, "$")
  let l:sorted = systemlist(["isort", "-"], bufnr("%"))
  if l:source == l:sorted
    echo "Buffer unchanged"
  else
    echohl ModeMsg
    echo "Buffer changed with isort"
    echohl None
    let g:sorted = l:sorted
    " FIXME: запись изменений в буффер
    "
    " TODO: запись ТОЛЬКО изменений, тут два варианта:
    " 1) вызов isort с флагом -df и применение полученного дифа
    " 2) сравнение списков строк снизу до тех пор пока не найдутся отличия
    "
    " TODO: отправлять в isort не весь буффер а только импорты
    " можно перебирать строки до тех пор пока в них есть нужные ключевые слова
    " эти строки отправть в isort и если есть отличия то перезаписать
    " содержимое того кол-ва строк, что попало в первую выборку
    "
    " TODO: альтернативный вариант:
    " вызывать isort только с проверкой на наличие отличий, и если они есть то
    " вызывать isort снова с перезаписью файла или вызывать его из плагина
  end
endfunction
