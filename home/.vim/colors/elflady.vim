" vim: tw=0 ts=4 sw=4

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "elflady"
hi Normal		guifg=cyan			guibg=black
hi Comment	term=bold		ctermfg=DarkCyan		guifg=#80a0ff
hi Constant	term=underline	ctermfg=Magenta		guifg=Magenta
hi Special	term=bold		ctermfg=DarkMagenta	guifg=Red
hi Identifier term=underline	cterm=bold			ctermfg=Cyan guifg=#40ffff
hi Statement term=bold		ctermfg=Yellow gui=bold	guifg=#aa4444
hi PreProc	term=underline	ctermfg=LightBlue	guifg=#ff80ff
hi Type	term=underline		ctermfg=LightGreen	guifg=#60ff60 gui=bold
hi Function	term=bold		ctermfg=White guifg=White
hi Repeat	term=underline	ctermfg=White		guifg=white
hi Operator				ctermfg=Red			guifg=Red
hi Ignore				ctermfg=black		guifg=bg
hi Error	term=reverse ctermbg=Red ctermfg=White guibg=Red guifg=White
hi Todo	term=standout ctermbg=Yellow ctermfg=Black guifg=Blue guibg=Yellow
hi SpellBad   term=reverse ctermbg=Red ctermfg=White gui=undercurl guisp=Red
hi SpellCap   term=reverse ctermbg=12 ctermfg=Black gui=undercurl guisp=Blue
hi SpellRare  term=reverse ctermbg=13 ctermfg=Black gui=undercurl guisp=Magenta
hi SpellLocal term=underline ctermbg=14 ctermfg=Black gui=undercurl guisp=Cyan
hi MatchParen term=bold ctermfg=White ctermbg=Black guibg=DarkCyan
hi SignatureMarkText ctermfg=LightYellow

hi StatusLine    cterm=NONE    ctermbg=White   ctermfg=Black
hi StatusLineNC  cterm=NONE    ctermbg=Grey    ctermfg=Black
hi VertSplit     cterm=NONE    ctermbg=Grey

" Common groups that link to default highlighting.
" You can specify other highlighting easily.
hi link String	Constant
hi link Character	Constant
hi link Number	Constant
hi link Boolean	Constant
hi link Float		Number
hi link Conditional	Repeat
hi link Label		Statement
hi link Keyword	Statement
hi link Exception	Statement
hi link Include	PreProc
hi link Define	PreProc
hi link Macro		PreProc
hi link PreCondit	PreProc
hi link StorageClass	Type
hi link Structure	Type
hi link Typedef	Type
hi link Tag		Special
hi link SpecialChar	Special
hi link Delimiter	Special
hi link SpecialComment Special
hi link Debug		Special

" Make the cursor line grey rather than underline
hi CursorLine   cterm=NONE ctermbg=235 ctermfg=NONE
hi CursorLineNr term=bold cterm=bold ctermfg=11 gui=bold guifg=Yellow
hi CursorColumn cterm=NONE ctermbg=235 ctermfg=NONE

hi ColorColumn cterm=NONE ctermbg=235 ctermfg=NONE

hi DiffChange           ctermfg=Black         ctermbg=Yellow
hi DiffText   term=bold ctermfg=White         ctermbg=Magenta

hi GitGutterAdd    ctermfg=LightGreen
hi GitGutterChange ctermfg=Yellow
hi GitGutterDelete ctermfg=Magenta
