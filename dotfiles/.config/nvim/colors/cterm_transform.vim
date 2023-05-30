" vi:syntax=vim

" base16-based cterm theme, extended with additional highlighting

" Terminal color definitions
let s:color00        = "00"
let s:color08        = "08"
let s:color07        = "07"
let s:color15        = "15"
let s:color01        = "01"
let s:color03        = "03"
let s:color02        = "02"
let s:color06        = "06"
let s:color04        = "04"
let s:color05        = "05"
if exists("base16colorspace") && base16colorspace == "256"
  let s:cterm01        = "18"
  let s:cterm02        = "19"
  let s:cterm04        = "20"
  let s:cterm06        = "21"
  let s:cterm09        = "16"
  let s:cterm0F        = "17"
  let s:cterm_diff_add = "22"
  let s:cterm_diff_chg = "220"
  let s:cterm_diff_del = "52"
else
  let s:cterm01        = "10"
  let s:cterm02        = "11"
  let s:cterm04        = "12"
  let s:cterm06        = "13"
  let s:cterm09        = "09"
  let s:cterm0F        = "14"
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
call <sid>hi("Normal",        s:color07, s:color00, "")
call <sid>hi("Bold",          "", "", "bold")
call <sid>hi("Debug",         s:color01, "", "")
call <sid>hi("Directory",     s:color04, "", "")
call <sid>hi("Error",         s:color00, s:color01, "")
call <sid>hi("ErrorMsg",      s:color01, s:color00, "")
call <sid>hi("Exception",     s:color01, "", "")
call <sid>hi("FoldColumn",    s:color06, s:cterm01, "")
call <sid>hi("Folded",        s:color08, "NONE", "") " bg: s:cterm01
call <sid>hi("IncSearch",     s:cterm01, s:cterm09, "NONE")
call <sid>hi("Italic",        "", "", "NONE")
call <sid>hi("Macro",         s:color01, "", "")
call <sid>hi("MatchParen",    "", s:color08,  "")
call <sid>hi("ModeMsg",       s:color02, "", "")
call <sid>hi("MoreMsg",       s:color02, "", "")
call <sid>hi("Question",      s:color04, "", "")
call <sid>hi("Search",        s:cterm01, s:color03,  "")
call <sid>hi("Substitute",    s:cterm01, s:color03, "NONE")
call <sid>hi("SpecialKey",    s:color08, "", "")
call <sid>hi("TooLong",       s:color01, "", "")
call <sid>hi("Underlined",    s:color01, "", "")
call <sid>hi("Visual",        "", s:cterm02, "")
call <sid>hi("VisualNOS",     s:color01, "", "")
call <sid>hi("WarningMsg",    s:color01, "", "")
call <sid>hi("WildMenu",      s:color01, "", "")
call <sid>hi("Title",         s:color04, "", "NONE")
call <sid>hi("Conceal",       s:color04, s:color00, "")
call <sid>hi("Cursor",        s:color00, s:color07, "")
call <sid>hi("NonText",       s:color08, "", "")
call <sid>hi("LineNr",        s:color07, "NONE", "") " bg: s:cterm01
call <sid>hi("LineNrAbove",   s:color08, "NONE", "") " bg: s:cterm01
call <sid>hi("LineNrBelow",   s:color08, "NONE", "") " bg: s:cterm01
call <sid>hi("SignColumn",    s:color08, "NONE", "") " bg: s:cterm01
call <sid>hi("StatusLine",    s:cterm04, s:cterm02, "NONE")
call <sid>hi("StatusLineNC",  s:color08, s:cterm01, "NONE")
call <sid>hi("VertSplit",     s:cterm02, "NONE", "NONE") " bg: s:cterm02
call <sid>hi("ColorColumn",   "", s:cterm01, "NONE")
call <sid>hi("CursorColumn",  "", s:cterm01, "NONE")
call <sid>hi("CursorLine",    "", s:cterm01, "NONE")
call <sid>hi("CursorLineNr",  s:cterm04, s:cterm01, "")
call <sid>hi("QuickFixLine",  "", s:cterm01, "NONE")
call <sid>hi("PMenu",         s:color07, s:cterm01, "NONE")
call <sid>hi("PMenuSel",      s:cterm01, s:color07, "")
call <sid>hi("TabLine",       s:color08, "NONE", "none") " bg: s:cterm01
call <sid>hi("TabLineFill",   s:color08, "NONE", "none") " bg: s:cterm01
call <sid>hi("TabLineSel",    s:color02, "NONE", "none") " bg: s:cterm01

" Standard syntax highlighting
call <sid>hi("Boolean",      s:cterm09, "", "")
call <sid>hi("Character",    s:color01, "", "")
call <sid>hi("Comment",      s:color08, "", "")
call <sid>hi("Conditional",  s:color05, "", "")
call <sid>hi("Constant",     s:cterm09, "", "")
call <sid>hi("Define",       s:color05, "", "NONE")
call <sid>hi("Delimiter",    s:cterm0F, "", "")
call <sid>hi("Float",        s:cterm09, "", "")
call <sid>hi("Function",     s:color04, "", "")
call <sid>hi("Identifier",   s:color01, "", "NONE")
call <sid>hi("Include",      s:color04, "", "")
call <sid>hi("Keyword",      s:color05, "", "")
call <sid>hi("Label",        s:color03, "", "")
call <sid>hi("Number",       s:cterm09, "", "")
call <sid>hi("Operator",     s:color07, "", "NONE")
call <sid>hi("PreProc",      s:color03, "", "")
call <sid>hi("Repeat",       s:color03, "", "")
call <sid>hi("Special",      s:color06, "", "")
call <sid>hi("SpecialChar",  s:cterm0F, "", "")
call <sid>hi("Statement",    s:color01, "", "")
call <sid>hi("StorageClass", s:color03, "", "")
call <sid>hi("String",       s:color02, "", "")
call <sid>hi("Structure",    s:color05, "", "")
call <sid>hi("Tag",          s:color03, "", "")
call <sid>hi("Todo",         s:color03, s:cterm01, "")
call <sid>hi("Type",         s:color03, "", "NONE")
call <sid>hi("Typedef",      s:color03, "", "")

" Nvim highlighting
hi link FloatBorder Pmenu

" C highlighting
call <sid>hi("cOperator",   s:color06, "", "")
call <sid>hi("cPreCondit",  s:color05, "", "")

" C# highlighting
call <sid>hi("csClass",                 s:color03, "", "")
call <sid>hi("csAttribute",             s:color03, "", "")
call <sid>hi("csModifier",              s:color05, "", "")
call <sid>hi("csType",                  s:color01, "", "")
call <sid>hi("csUnspecifiedStatement",  s:color04, "", "")
call <sid>hi("csContextualStatement",   s:color05, "", "")
call <sid>hi("csNewDecleration",        s:color01, "", "")

" CSS highlighting
call <sid>hi("cssBraces",      s:color07, "", "")
call <sid>hi("cssClassName",   s:color05, "", "")
call <sid>hi("cssColor",       s:color06, "", "")

" Diff highlighting
call <sid>hi("DiffAdd",       "NONE", s:cterm_diff_add, "")
call <sid>hi("DiffChange",    "NONE", s:cterm_diff_chg, "")
call <sid>hi("DiffDelete",    s:cterm01, "NONE", "")
call <sid>hi("DiffText",      "", s:cterm_diff_chg, "italic")
call <sid>hi("DiffAdded",     s:color02, s:color00, "")
call <sid>hi("DiffFile",      s:color01, s:color00, "")
call <sid>hi("DiffNewFile",   s:color02, s:color00, "")
call <sid>hi("DiffLine",      s:color04, s:color00, "")
call <sid>hi("DiffRemoved",   s:color01, s:color00, "")

" Git highlighting
call <sid>hi("gitcommitOverflow",       s:color01, "", "")
call <sid>hi("gitcommitSummary",        s:color02, "", "")
call <sid>hi("gitcommitComment",        s:color08, "", "")
call <sid>hi("gitcommitUntracked",      s:color08, "", "")
call <sid>hi("gitcommitDiscarded",      s:color08, "", "")
call <sid>hi("gitcommitSelected",       s:color08, "", "")
call <sid>hi("gitcommitHeader",         s:color05, "", "")
call <sid>hi("gitcommitSelectedType",   s:color04, "", "")
call <sid>hi("gitcommitUnmergedType",   s:color04, "", "")
call <sid>hi("gitcommitDiscardedType",  s:color04, "", "")
call <sid>hi("gitcommitBranch",         s:cterm09, "", "bold")
call <sid>hi("gitcommitUntrackedFile",  s:color03, "", "")
call <sid>hi("gitcommitUnmergedFile",   s:color01, "", "bold")
call <sid>hi("gitcommitDiscardedFile",  s:color01, "", "bold")
call <sid>hi("gitcommitSelectedFile",   s:color02, "", "bold")

" GitGutter highlighting
call <sid>hi("GitGutterAdd",     s:color02, "NONE", "") " bg: s:cterm01
call <sid>hi("GitGutterChange",  s:color05, "NONE", "") " bg: s:cterm01
call <sid>hi("GitGutterDelete",  s:color01, "NONE", "") " bg: s:cterm01
call <sid>hi("GitGutterChangeDelete",  s:color05, s:cterm01, "")
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
call <sid>hi("htmlBold",    s:color03, "", "")
call <sid>hi("htmlItalic",  s:color05, "", "")
call <sid>hi("htmlEndTag",  s:color07, "", "")
call <sid>hi("htmlTag",     s:color07, "", "")

" JavaScript highlighting
call <sid>hi("javaScript",        s:color07, "", "")
call <sid>hi("javaScriptBraces",  s:color07, "", "")
call <sid>hi("javaScriptNumber",  s:cterm09, "", "")
" pangloss/vim-javascript highlighting
call <sid>hi("jsOperator",          s:color04, "", "")
call <sid>hi("jsStatement",         s:color05, "", "")
call <sid>hi("jsReturn",            s:color05, "", "")
call <sid>hi("jsThis",              s:color01, "", "")
call <sid>hi("jsClassDefinition",   s:color03, "", "")
call <sid>hi("jsFunction",          s:color05, "", "")
call <sid>hi("jsFuncName",          s:color04, "", "")
call <sid>hi("jsFuncCall",          s:color04, "", "")
call <sid>hi("jsClassFuncName",     s:color04, "", "")
call <sid>hi("jsClassMethodType",   s:color05, "", "")
call <sid>hi("jsRegexpString",      s:color06, "", "")
call <sid>hi("jsGlobalObjects",     s:color03, "", "")
call <sid>hi("jsGlobalNodeObjects", s:color03, "", "")
call <sid>hi("jsExceptions",        s:color03, "", "")
call <sid>hi("jsBuiltins",          s:color03, "", "")

" Mail highlighting
call <sid>hi("mailQuoted1",  s:color03, "", "")
call <sid>hi("mailQuoted2",  s:color02, "", "")
call <sid>hi("mailQuoted3",  s:color05, "", "")
call <sid>hi("mailQuoted4",  s:color06, "", "")
call <sid>hi("mailQuoted5",  s:color04, "", "")
call <sid>hi("mailQuoted6",  s:color03, "", "")
call <sid>hi("mailURL",      s:color04, "", "")
call <sid>hi("mailEmail",    s:color04, "", "")

" Markdown highlighting
call <sid>hi("markdownCode",              s:color02, "", "")
call <sid>hi("markdownError",             s:color07, s:color00, "")
call <sid>hi("markdownCodeBlock",         s:color02, "", "")
call <sid>hi("markdownHeadingDelimiter",  s:color04, "", "")

" NERDTree highlighting
call <sid>hi("NERDTreeDirSlash",  s:color04, "", "")
call <sid>hi("NERDTreeExecFile",  s:color07, "", "")

" PHP highlighting
call <sid>hi("phpMemberSelector",  s:color07, "", "")
call <sid>hi("phpComparison",      s:color07, "", "")
call <sid>hi("phpParent",          s:color07, "", "")
call <sid>hi("phpMethodsVar",      s:color06, "", "")

" Python highlighting
call <sid>hi("pythonOperator",  s:color05, "", "")
call <sid>hi("pythonRepeat",    s:color05, "", "")
call <sid>hi("pythonInclude",   s:color05, "", "")
call <sid>hi("pythonStatement", s:color05, "", "")

" Ruby highlighting
call <sid>hi("rubyAttribute",               s:color04, "", "")
call <sid>hi("rubyConstant",                s:color03, "", "")
call <sid>hi("rubyInterpolationDelimiter",  s:cterm0F, "", "")
call <sid>hi("rubyRegexp",                  s:color06, "", "")
call <sid>hi("rubySymbol",                  s:color02, "", "")
call <sid>hi("rubyStringDelimiter",         s:color02, "", "")

" SASS highlighting
call <sid>hi("sassidChar",     s:color01, "", "")
call <sid>hi("sassClassChar",  s:cterm09, "", "")
call <sid>hi("sassInclude",    s:color05, "", "")
call <sid>hi("sassMixing",     s:color05, "", "")
call <sid>hi("sassMixinName",  s:color04, "", "")

" Signify highlighting
call <sid>hi("SignifySignAdd",     s:color02, s:cterm01, "")
call <sid>hi("SignifySignChange",  s:color04, s:cterm01, "")
call <sid>hi("SignifySignDelete",  s:color01, s:cterm01, "")

" Spelling highlighting
call <sid>hi("SpellBad",     "", "", "undercurl")
call <sid>hi("SpellLocal",   "", "", "undercurl")
call <sid>hi("SpellCap",     "", "", "undercurl")
call <sid>hi("SpellRare",    "", "", "undercurl")

" Startify highlighting
call <sid>hi("StartifyBracket",  s:color08, "", "")
call <sid>hi("StartifyFile",     s:color15, "", "")
call <sid>hi("StartifyFooter",   s:color08, "", "")
call <sid>hi("StartifyHeader",   s:color02, "", "")
call <sid>hi("StartifyNumber",   s:cterm09, "", "")
call <sid>hi("StartifyPath",     s:color08, "", "")
call <sid>hi("StartifySection",  s:color05, "", "")
call <sid>hi("StartifySelect",   s:color06, "", "")
call <sid>hi("StartifySlash",    s:color08, "", "")
call <sid>hi("StartifySpecial",  s:color08, "", "")

" Java highlighting
call <sid>hi("javaOperator",     s:color04, "", "")

" Lightspeed highlighting
call <sid>hi("LightspeedShortcut", "bg", s:color01, "bold,underline") " bg: 09
call <sid>hi("LightspeedOneCharMatch", "bg", s:color01, "bold") " bg: 09

" LspSignature highlighting
call <sid>hi("LspSignatureActiveParameter", s:color01, "", "") " fg: 01

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
