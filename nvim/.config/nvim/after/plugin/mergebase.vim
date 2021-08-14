if exists('g:loaded_mergebase') | finish | endif
command! -complete=customlist,s:completion -nargs=* MergeBase lua require('mergebase').mergebase(<f-args>)

function s:completion(argLead, cmdLine, curPos)
    return luaeval("require('mergebase').complete("
                \ . "vim.fn.eval('a:argLead'),"
                \ . "vim.fn.eval('a:cmdLine'),"
                \ . "vim.fn.eval('a:curPos'))")
endfunction
let g:loaded_mergebase = 1
