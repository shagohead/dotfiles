hi clear
syntax reset
let g:colors_name = "cterm256"

" editor
hi ColorColumn ctermfg=NONE ctermbg=232
hi Conceal ctermfg=4 ctermbg=0
hi CursorColumn ctermfg=NONE ctermbg=240
hi CursorLine ctermfg=NONE ctermbg=NONE cterm=underline
hi CursorLineNr ctermfg=255 ctermbg=NONE cterm=underline
hi Debug ctermfg=1 ctermbg=NONE
hi Directory ctermfg=4 ctermbg=NONE
hi Error ctermfg=9 ctermbg=NONE
hi ErrorMsg ctermfg=9 ctermbg=NONE
hi Exception ctermfg=9 ctermbg=NONE
hi! link FloatBorder Pmenu
hi Folded ctermfg=NONE ctermbg=233
hi FoldColumn ctermfg=NONE ctermbg=233
hi IncSearch ctermfg=15 ctermbg=53 cterm=underline
hi LineNr ctermfg=240 ctermbg=NONE
hi MoreMsg ctermfg=2 ctermbg=NONE
hi NonText ctermfg=245 ctermbg=NONE
hi Pmenu ctermfg=NONE ctermbg=NONE
hi PmenuSel ctermfg=233 ctermbg=15
hi Question ctermfg=11 ctermbg=NONE
hi! link QuickFixLine Search
hi Search ctermfg=250 ctermbg=0 cterm=underline
hi SignColumn ctermfg=7 ctermbg=NONE
hi Substitute cterm=reverse,italic
hi SpecialKey ctermfg=201 ctermbg=NONE
hi TabLine ctermfg=240 ctermbg=NONE cterm=NONE
hi TabLineFill cterm=NONE
hi TabLineSel cterm=bold
hi Title ctermfg=1 ctermbg=NONE
hi VertSplit cterm=NONE
hi Visual ctermfg=NONE ctermbg=235
hi VisualNOS ctermfg=1 ctermbg=NONE
hi WarningMsg ctermfg=142 ctermbg=NONE
hi WildMenu ctermfg=1 ctermbg=NONE

" diffs
hi DiffAdd ctermbg=22
hi DiffChange ctermbg=58
hi DiffText ctermbg=100 cterm=NONE
hi DiffDelete ctermfg=236 ctermbg=NONE
hi GitSignsDeleteLn ctermbg=52
hi GitSignsDeletePreview ctermfg=NONE ctermbg=52
hi GitSignsAddInline ctermbg=34
hi GitSignsChangeInline ctermbg=142
hi GitSignsDeleteInline ctermbg=124

" matchparen plugin
hi MatchParen ctermfg=NONE ctermbg=NONE cterm=underline

" default syntax
hi Boolean ctermfg=14 ctermbg=NONE
hi Comment ctermfg=250 ctermbg=NONE
hi Conditional ctermfg=11 ctermbg=NONE
hi Constant ctermfg=46 ctermbg=NONE
hi Function ctermfg=4 ctermbg=NONE
hi Identifier ctermfg=4 ctermbg=NONE
hi Include ctermfg=184 ctermbg=NONE
hi! link Label Conditional
hi Keyword ctermfg=201 ctermbg=NONE
hi Operator ctermfg=51 ctermbg=NONE
hi PreProc ctermfg=3 ctermbg=NONE
hi Repeat ctermfg=51 ctermbg=NONE
hi Special ctermfg=5 ctermbg=NONE
hi String ctermfg=10 ctermbg=NONE
hi Statement ctermfg=164 ctermbg=NONE
hi Type ctermfg=14 ctermbg=NONE
hi Todo ctermfg=11 ctermbg=NONE

" go syntax
hi go1 ctermfg=15
hi! link goImport Include
hi goPackage ctermfg=1 ctermbg=NONE

" python syntax
hi python1 ctermfg=15

" vim syntax
hi vimGroup ctermfg=12 ctermbg=NONE
hi! link vimHiTerm Normal

" lsp
hi lsp_markdown2 ctermfg=15

" markdown
hi markdownCode ctermfg=2
hi markdownError ctermfg=7 ctermbg=0
hi markdownCodeBlock ctermfg=2
hi markdownHeadingDelimiter ctermfg=4

" cmp
hi CmpItemAbbrDeprecated ctermfg=8 ctermbg=NONE cterm=strikethrough
hi CmpItemAbbrMatch ctermfg=4 ctermbg=NONE
hi CmpItemAbbrMatchFuzzy ctermfg=4 ctermbg=NONE
hi CmpItemKindVariable ctermfg=12 ctermbg=NONE
hi CmpItemKindInterface ctermfg=12 ctermbg=NONE
hi CmpItemKindText ctermfg=12 ctermbg=NONE
hi CmpItemKindFunction ctermfg=13 ctermbg=NONE
hi CmpItemKindMethod ctermfg=13 ctermbg=NONE
hi CmpItemKindKeyword ctermfg=7 ctermbg=NONE
hi CmpItemKindProperty ctermfg=7 ctermbg=NONE
hi CmpItemKindUnit ctermfg=7 ctermbg=NONE
