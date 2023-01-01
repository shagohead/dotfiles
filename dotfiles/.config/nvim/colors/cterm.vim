" vi:syntax=vim

" base16-based cterm theme, extended with additional highlighting

" Terminal color definitions
let s:cterm00        = "00"
let g:base16_cterm00 = "00"
let s:cterm03        = "08"
let g:base16_cterm03 = "08"
let s:cterm05        = "07"
let g:base16_cterm05 = "07"
let s:cterm07        = "15"
let g:base16_cterm07 = "15"
let s:cterm08        = "01"
let g:base16_cterm08 = "01"
let s:cterm0A        = "03"
let g:base16_cterm0A = "03"
let s:cterm0B        = "02"
let g:base16_cterm0B = "02"
let s:cterm0C        = "06"
let g:base16_cterm0C = "06"
let s:cterm0D        = "04"
let g:base16_cterm0D = "04"
let s:cterm0E        = "05"
let g:base16_cterm0E = "05"
if exists("base16colorspace") && base16colorspace == "256"
  let s:cterm01        = "18"
  let g:base16_cterm01 = "18"
  let s:cterm02        = "19"
  let g:base16_cterm02 = "19"
  let s:cterm04        = "20"
  let g:base16_cterm04 = "20"
  let s:cterm06        = "21"
  let g:base16_cterm06 = "21"
  let s:cterm09        = "16"
  let g:base16_cterm09 = "16"
  let s:cterm0F        = "17"
  let g:base16_cterm0F = "17"
  let s:cterm_diff_add = "22"
  let s:cterm_diff_chg = "220"
  let s:cterm_diff_del = "52"
else
  let s:cterm01        = "10"
  let g:base16_cterm01 = "10"
  let s:cterm02        = "11"
  let g:base16_cterm02 = "11"
  let s:cterm04        = "12"
  let g:base16_cterm04 = "12"
  let s:cterm06        = "13"
  let g:base16_cterm06 = "13"
  let s:cterm09        = "09"
  let g:base16_cterm09 = "09"
  let s:cterm0F        = "14"
  let g:base16_cterm0F = "14"
  let s:cterm_diff_add = "02"
  let s:cterm_diff_chg = "04"
  let s:cterm_diff_del = "01"
endif

" Theme setup
hi clear
syntax reset
let g:colors_name = "cterm"

" Highlighting function
fun <sid>hi(group, ctermfg, ctermbg, attr)
  if a:ctermfg != ""
    exec "hi " . a:group . " ctermfg=" . a:ctermfg
  endif
  if a:ctermbg != ""
    exec "hi " . a:group . " ctermbg=" . a:ctermbg
  endif
  if a:attr != ""
    exec "hi " . a:group . " cterm=" . a:attr
  endif
endfun

" Vim editor colors
call <sid>hi("Normal",        s:cterm05, s:cterm00, "")
call <sid>hi("Bold",          "", "", "bold")
call <sid>hi("Debug",         s:cterm08, "", "")
call <sid>hi("Directory",     s:cterm0D, "", "")
call <sid>hi("Error",         s:cterm00, s:cterm08, "")
call <sid>hi("ErrorMsg",      s:cterm08, s:cterm00, "")
call <sid>hi("Exception",     s:cterm08, "", "")
call <sid>hi("FoldColumn",    s:cterm0C, s:cterm01, "")
call <sid>hi("Folded",        s:cterm03, "NONE", "") " bg: s:cterm01
call <sid>hi("IncSearch",     s:cterm01, s:cterm09, "NONE")
call <sid>hi("Italic",        "", "", "NONE")
call <sid>hi("Macro",         s:cterm08, "", "")
call <sid>hi("MatchParen",    "", s:cterm03,  "")
call <sid>hi("ModeMsg",       s:cterm0B, "", "")
call <sid>hi("MoreMsg",       s:cterm0B, "", "")
call <sid>hi("Question",      s:cterm0D, "", "")
call <sid>hi("Search",        s:cterm01, s:cterm0A,  "")
call <sid>hi("Substitute",    s:cterm01, s:cterm0A, "NONE")
call <sid>hi("SpecialKey",    s:cterm03, "", "")
call <sid>hi("TooLong",       s:cterm08, "", "")
call <sid>hi("Underlined",    s:cterm08, "", "")
call <sid>hi("Visual",        "", s:cterm02, "")
call <sid>hi("VisualNOS",     s:cterm08, "", "")
call <sid>hi("WarningMsg",    s:cterm08, "", "")
call <sid>hi("WildMenu",      s:cterm08, "", "")
call <sid>hi("Title",         s:cterm0D, "", "NONE")
call <sid>hi("Conceal",       s:cterm0D, s:cterm00, "")
call <sid>hi("Cursor",        s:cterm00, s:cterm05, "")
call <sid>hi("NonText",       s:cterm03, "", "")
call <sid>hi("LineNr",        s:cterm05, "NONE", "") " bg: s:cterm01
call <sid>hi("LineNrAbove",   s:cterm03, "NONE", "") " bg: s:cterm01
call <sid>hi("LineNrBelow",   s:cterm03, "NONE", "") " bg: s:cterm01
call <sid>hi("SignColumn",    s:cterm03, "NONE", "") " bg: s:cterm01
call <sid>hi("StatusLine",    s:cterm04, s:cterm02, "NONE")
call <sid>hi("StatusLineNC",  s:cterm03, s:cterm01, "NONE")
call <sid>hi("VertSplit",     s:cterm02, "NONE", "NONE") " bg: s:cterm02
call <sid>hi("ColorColumn",   "", s:cterm01, "NONE")
call <sid>hi("CursorColumn",  "", s:cterm01, "NONE")
call <sid>hi("CursorLine",    "", s:cterm01, "NONE")
call <sid>hi("CursorLineNr",  s:cterm04, s:cterm01, "")
call <sid>hi("QuickFixLine",  "", s:cterm01, "NONE")
call <sid>hi("PMenu",         s:cterm05, s:cterm01, "NONE")
call <sid>hi("PMenuSel",      s:cterm01, s:cterm05, "")
call <sid>hi("TabLine",       s:cterm03, "NONE", "none") " bg: s:cterm01
call <sid>hi("TabLineFill",   s:cterm03, "NONE", "none") " bg: s:cterm01
call <sid>hi("TabLineSel",    s:cterm0B, "NONE", "none") " bg: s:cterm01

" Standard syntax highlighting
call <sid>hi("Boolean",      s:cterm09, "", "")
call <sid>hi("Character",    s:cterm08, "", "")
call <sid>hi("Comment",      s:cterm03, "", "")
call <sid>hi("Conditional",  s:cterm0E, "", "")
call <sid>hi("Constant",     s:cterm09, "", "")
call <sid>hi("Define",       s:cterm0E, "", "NONE")
call <sid>hi("Delimiter",    s:cterm0F, "", "")
call <sid>hi("Float",        s:cterm09, "", "")
call <sid>hi("Function",     s:cterm0D, "", "")
call <sid>hi("Identifier",   s:cterm08, "", "NONE")
call <sid>hi("Include",      s:cterm0D, "", "")
call <sid>hi("Keyword",      s:cterm0E, "", "")
call <sid>hi("Label",        s:cterm0A, "", "")
call <sid>hi("Number",       s:cterm09, "", "")
call <sid>hi("Operator",     s:cterm05, "", "NONE")
call <sid>hi("PreProc",      s:cterm0A, "", "")
call <sid>hi("Repeat",       s:cterm0A, "", "")
call <sid>hi("Special",      s:cterm0C, "", "")
call <sid>hi("SpecialChar",  s:cterm0F, "", "")
call <sid>hi("Statement",    s:cterm08, "", "")
call <sid>hi("StorageClass", s:cterm0A, "", "")
call <sid>hi("String",       s:cterm0B, "", "")
call <sid>hi("Structure",    s:cterm0E, "", "")
call <sid>hi("Tag",          s:cterm0A, "", "")
call <sid>hi("Todo",         s:cterm0A, s:cterm01, "")
call <sid>hi("Type",         s:cterm0A, "", "NONE")
call <sid>hi("Typedef",      s:cterm0A, "", "")

" Nvim highlighting
hi link FloatBorder Pmenu

" C highlighting
call <sid>hi("cOperator",   s:cterm0C, "", "")
call <sid>hi("cPreCondit",  s:cterm0E, "", "")

" C# highlighting
call <sid>hi("csClass",                 s:cterm0A, "", "")
call <sid>hi("csAttribute",             s:cterm0A, "", "")
call <sid>hi("csModifier",              s:cterm0E, "", "")
call <sid>hi("csType",                  s:cterm08, "", "")
call <sid>hi("csUnspecifiedStatement",  s:cterm0D, "", "")
call <sid>hi("csContextualStatement",   s:cterm0E, "", "")
call <sid>hi("csNewDecleration",        s:cterm08, "", "")

" CSS highlighting
call <sid>hi("cssBraces",      s:cterm05, "", "")
call <sid>hi("cssClassName",   s:cterm0E, "", "")
call <sid>hi("cssColor",       s:cterm0C, "", "")

" Diff highlighting
call <sid>hi("DiffAdd",       "NONE", s:cterm_diff_add, "")
call <sid>hi("DiffChange",    "NONE", s:cterm_diff_chg, "")
call <sid>hi("DiffDelete",    s:cterm01, "NONE", "")
call <sid>hi("DiffText",      "", s:cterm_diff_chg, "italic")
call <sid>hi("DiffAdded",     s:cterm0B, s:cterm00, "")
call <sid>hi("DiffFile",      s:cterm08, s:cterm00, "")
call <sid>hi("DiffNewFile",   s:cterm0B, s:cterm00, "")
call <sid>hi("DiffLine",      s:cterm0D, s:cterm00, "")
call <sid>hi("DiffRemoved",   s:cterm08, s:cterm00, "")

" Git highlighting
call <sid>hi("gitcommitOverflow",       s:cterm08, "", "")
call <sid>hi("gitcommitSummary",        s:cterm0B, "", "")
call <sid>hi("gitcommitComment",        s:cterm03, "", "")
call <sid>hi("gitcommitUntracked",      s:cterm03, "", "")
call <sid>hi("gitcommitDiscarded",      s:cterm03, "", "")
call <sid>hi("gitcommitSelected",       s:cterm03, "", "")
call <sid>hi("gitcommitHeader",         s:cterm0E, "", "")
call <sid>hi("gitcommitSelectedType",   s:cterm0D, "", "")
call <sid>hi("gitcommitUnmergedType",   s:cterm0D, "", "")
call <sid>hi("gitcommitDiscardedType",  s:cterm0D, "", "")
call <sid>hi("gitcommitBranch",         s:cterm09, "", "bold")
call <sid>hi("gitcommitUntrackedFile",  s:cterm0A, "", "")
call <sid>hi("gitcommitUnmergedFile",   s:cterm08, "", "bold")
call <sid>hi("gitcommitDiscardedFile",  s:cterm08, "", "bold")
call <sid>hi("gitcommitSelectedFile",   s:cterm0B, "", "bold")

" GitGutter highlighting
call <sid>hi("GitGutterAdd",     s:cterm0B, "NONE", "") " bg: s:cterm01
call <sid>hi("GitGutterChange",  s:cterm0E, "NONE", "") " bg: s:cterm01
call <sid>hi("GitGutterDelete",  s:cterm08, "NONE", "") " bg: s:cterm01
call <sid>hi("GitGutterChangeDelete",  s:cterm0E, s:cterm01, "")
hi link GitGutterAddLineNr GitGutterAdd
hi link GitGutterChangeLineNr GitGutterChange
hi link GitGutterDeleteLineNr GitGutterDelete

" GitSigns highlighting
hi link GitSignsAdd GitGutterAdd
hi link GitSignsChange GitGutterChange
hi link GitSignsDelete GitGutterDelete
hi link GitSignsAddNr GitGutterAddLineNr
hi link GitSignsChangeNr GitGutterChangeLineNr
hi link GitSignsDeleteNr GitGutterDeleteLineNr
" hi link GitSignsAddLn GitGutterAddLine
" hi link GitSignsChangeLn GitGutterChangeLine
call <sid>hi("GitSignsDeleteLn", "", s:cterm_diff_del, "")
call <sid>hi("GitSignsDeletePreview", "", s:cterm_diff_del, "")
hi link GitSignsCurrentLineBlame NonText
hi link GitSignsAddInline TermCursor
hi link GitSignsDeleteInline TermCursor
hi link GitSignsChangeInline TermCursor
hi link GitSignsAddLnInline GitSignsAddInline
hi link GitSignsChangeLnInline GitSignsChangeInline
hi link GitSignsDeleteLnInline GitSignsDeleteInline
hi link GitSignsAddLnVirtLn GitSignsAddLn
hi link GitSignsChangeVirtLn GitSignsChangeLn
" hi link GitSignsDeleteVirtLn GitGutterDeleteLine
hi link GitSignsAddLnVirtLnInLine GitSignsAddLnInline
hi link GitSignsChangeVirtLnInLine GitSignsChangeLnInline
hi link GitSignsDeleteVirtLnInLine GitSignsDeleteLnInline

" HTML highlighting
call <sid>hi("htmlBold",    s:cterm0A, "", "")
call <sid>hi("htmlItalic",  s:cterm0E, "", "")
call <sid>hi("htmlEndTag",  s:cterm05, "", "")
call <sid>hi("htmlTag",     s:cterm05, "", "")

" JavaScript highlighting
call <sid>hi("javaScript",        s:cterm05, "", "")
call <sid>hi("javaScriptBraces",  s:cterm05, "", "")
call <sid>hi("javaScriptNumber",  s:cterm09, "", "")
" pangloss/vim-javascript highlighting
call <sid>hi("jsOperator",          s:cterm0D, "", "")
call <sid>hi("jsStatement",         s:cterm0E, "", "")
call <sid>hi("jsReturn",            s:cterm0E, "", "")
call <sid>hi("jsThis",              s:cterm08, "", "")
call <sid>hi("jsClassDefinition",   s:cterm0A, "", "")
call <sid>hi("jsFunction",          s:cterm0E, "", "")
call <sid>hi("jsFuncName",          s:cterm0D, "", "")
call <sid>hi("jsFuncCall",          s:cterm0D, "", "")
call <sid>hi("jsClassFuncName",     s:cterm0D, "", "")
call <sid>hi("jsClassMethodType",   s:cterm0E, "", "")
call <sid>hi("jsRegexpString",      s:cterm0C, "", "")
call <sid>hi("jsGlobalObjects",     s:cterm0A, "", "")
call <sid>hi("jsGlobalNodeObjects", s:cterm0A, "", "")
call <sid>hi("jsExceptions",        s:cterm0A, "", "")
call <sid>hi("jsBuiltins",          s:cterm0A, "", "")

" Mail highlighting
call <sid>hi("mailQuoted1",  s:cterm0A, "", "")
call <sid>hi("mailQuoted2",  s:cterm0B, "", "")
call <sid>hi("mailQuoted3",  s:cterm0E, "", "")
call <sid>hi("mailQuoted4",  s:cterm0C, "", "")
call <sid>hi("mailQuoted5",  s:cterm0D, "", "")
call <sid>hi("mailQuoted6",  s:cterm0A, "", "")
call <sid>hi("mailURL",      s:cterm0D, "", "")
call <sid>hi("mailEmail",    s:cterm0D, "", "")

" Markdown highlighting
call <sid>hi("markdownCode",              s:cterm0B, "", "")
call <sid>hi("markdownError",             s:cterm05, s:cterm00, "")
call <sid>hi("markdownCodeBlock",         s:cterm0B, "", "")
call <sid>hi("markdownHeadingDelimiter",  s:cterm0D, "", "")

" NERDTree highlighting
call <sid>hi("NERDTreeDirSlash",  s:cterm0D, "", "")
call <sid>hi("NERDTreeExecFile",  s:cterm05, "", "")

" PHP highlighting
call <sid>hi("phpMemberSelector",  s:cterm05, "", "")
call <sid>hi("phpComparison",      s:cterm05, "", "")
call <sid>hi("phpParent",          s:cterm05, "", "")
call <sid>hi("phpMethodsVar",      s:cterm0C, "", "")

" Python highlighting
call <sid>hi("pythonOperator",  s:cterm0E, "", "")
call <sid>hi("pythonRepeat",    s:cterm0E, "", "")
call <sid>hi("pythonInclude",   s:cterm0E, "", "")
call <sid>hi("pythonStatement", s:cterm0E, "", "")

" Ruby highlighting
call <sid>hi("rubyAttribute",               s:cterm0D, "", "")
call <sid>hi("rubyConstant",                s:cterm0A, "", "")
call <sid>hi("rubyInterpolationDelimiter",  s:cterm0F, "", "")
call <sid>hi("rubyRegexp",                  s:cterm0C, "", "")
call <sid>hi("rubySymbol",                  s:cterm0B, "", "")
call <sid>hi("rubyStringDelimiter",         s:cterm0B, "", "")

" SASS highlighting
call <sid>hi("sassidChar",     s:cterm08, "", "")
call <sid>hi("sassClassChar",  s:cterm09, "", "")
call <sid>hi("sassInclude",    s:cterm0E, "", "")
call <sid>hi("sassMixing",     s:cterm0E, "", "")
call <sid>hi("sassMixinName",  s:cterm0D, "", "")

" Signify highlighting
call <sid>hi("SignifySignAdd",     s:cterm0B, s:cterm01, "")
call <sid>hi("SignifySignChange",  s:cterm0D, s:cterm01, "")
call <sid>hi("SignifySignDelete",  s:cterm08, s:cterm01, "")

" Spelling highlighting
call <sid>hi("SpellBad",     "", "", "undercurl")
call <sid>hi("SpellLocal",   "", "", "undercurl")
call <sid>hi("SpellCap",     "", "", "undercurl")
call <sid>hi("SpellRare",    "", "", "undercurl")

" Startify highlighting
call <sid>hi("StartifyBracket",  s:cterm03, "", "")
call <sid>hi("StartifyFile",     s:cterm07, "", "")
call <sid>hi("StartifyFooter",   s:cterm03, "", "")
call <sid>hi("StartifyHeader",   s:cterm0B, "", "")
call <sid>hi("StartifyNumber",   s:cterm09, "", "")
call <sid>hi("StartifyPath",     s:cterm03, "", "")
call <sid>hi("StartifySection",  s:cterm0E, "", "")
call <sid>hi("StartifySelect",   s:cterm0C, "", "")
call <sid>hi("StartifySlash",    s:cterm03, "", "")
call <sid>hi("StartifySpecial",  s:cterm03, "", "")

" Java highlighting
call <sid>hi("javaOperator",     s:cterm0D, "", "")

" Lightspeed highlighting
call <sid>hi("LightspeedShortcut", "bg", s:cterm08, "bold,underline") " bg: 09
call <sid>hi("LightspeedOneCharMatch", "bg", s:cterm08, "bold") " bg: 09

" LspSignature highlighting
call <sid>hi("LspSignatureActiveParameter", s:cterm08, "", "") " fg: 01

" TreeSitter
call <sid>hi("TSDefinition", "", "", "reverse")

" nvim-cmp
highlight! CmpItemAbbrDeprecated ctermbg=NONE cterm=strikethrough ctermfg=8
highlight! CmpItemAbbrMatch ctermbg=NONE ctermfg=4
highlight! CmpItemAbbrMatchFuzzy ctermbg=NONE ctermfg=4
highlight! CmpItemKindVariable ctermbg=NONE ctermfg=12
highlight! CmpItemKindInterface ctermbg=NONE ctermfg=12
highlight! CmpItemKindText ctermbg=NONE ctermfg=12
highlight! CmpItemKindFunction ctermbg=NONE ctermfg=13
highlight! CmpItemKindMethod ctermbg=NONE ctermfg=13
highlight! CmpItemKindKeyword ctermbg=NONE ctermfg=7
highlight! CmpItemKindProperty ctermbg=NONE ctermfg=7
highlight! CmpItemKindUnit ctermbg=NONE ctermfg=7

" Remove functions
delf <sid>hi

" Remove color variables
unlet s:cterm00 s:cterm01 s:cterm02 s:cterm03 s:cterm04 s:cterm05 s:cterm06 s:cterm07 s:cterm08 s:cterm09 s:cterm0A s:cterm0B s:cterm0C s:cterm0D s:cterm0E s:cterm0F
