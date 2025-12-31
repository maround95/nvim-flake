" Very basic kanata.cfg highlighting

if exists("b:current_syntax")
  finish
endif

syntax region kanataBlockComment start="#|" end="|#" contains=kanataBlockComment
syntax match kanataComment ";;.*$"
syntax match kanataAlias "@[A-Za-z0-9_]\+"
syntax match kanataNumber "\v<\d+>"
syntax match kanataDisabled "\<XX\>"
syntax keyword kanataKeyword defcfg defsrc defalias deflayer
syntax keyword kanataFunc tap-hold-press one-shot layer-while-held macro

" Highlight links
hi def link kanataComment       Comment
hi def link kanataBlockComment  Comment
hi def link kanataKeyword       Keyword
hi def link kanataFunc          Function
hi def link kanataAlias         Identifier
hi def link kanataNumber        Number
hi def link kanataDisabled      NonText

let b:current_syntax = "kanata"
