" Vim color file
" Maintainer: max@maxcantor.net
" Last Change: $Date$
" Version: $Id$

set background=dark
hi clear
if exists("syntax_on")
 syntax reset
endif

let g:colors_name = "hhdgray"

hi Normal gui=NONE guifg=lightgray guibg=black
hi Normal cterm=NONE ctermfg=lightgray ctermbg=NONE

hi NonText gui=UNDERLINE guifg=darkgray guibg=black
hi NonText cterm=UNDERLINE ctermfg=darkgray ctermbg=NONE
hi Folded gui=NONE guifg=darkgray guibg=black
hi Folded cterm=NONE ctermfg=darkgray ctermbg=NONE
hi FoldColumn gui=NONE guifg=darkgray guibg=black
hi FoldColumn cterm=NONE ctermfg=darkgray ctermbg=NONE
hi StatusLineNC gui=UNDERLINE guifg=black guibg=darkgray
hi StatusLineNC cterm=UNDERLINE ctermfg=black ctermbg=darkgray
hi LineNr gui=NONE guifg=black guibg=lightgray
hi LineNr cterm=NONE ctermfg=black ctermbg=lightgray
hi VertSplit gui=NONE guifg=darkgray guibg=darkgray
hi VertSplit cterm=NONE ctermfg=darkgray ctermbg=darkgray

hi Title gui=UNDERLINE guifg=lightgray guibg=darkgray
hi Title cterm=UNDERLINE ctermfg=lightgray ctermbg=darkgray

hi MoreMsg gui=UNDERLINE guifg=black guibg=darkgray
hi MoreMsg cterm=UNDERLINE ctermfg=black ctermbg=darkgray
hi Question gui=UNDERLINE guifg=black guibg=darkgray
hi Question cterm=UNDERLINE ctermfg=black ctermbg=darkgray

hi StatusLine gui=UNDERLINE guifg=black guibg=gray
hi StatusLine cterm=UNDERLINE ctermfg=black ctermbg=gray
hi WildMenu gui=UNDERLINE guifg=black guibg=green
hi WildMenu cterm=UNDERLINE ctermfg=black ctermbg=green
hi Cursor gui=UNDERLINE guifg=black guibg=green
hi Cursor cterm=UNDERLINE ctermfg=black ctermbg=green
hi IncSearch gui=UNDERLINE guifg=black guibg=green
hi IncSearch cterm=UNDERLINE ctermfg=black ctermbg=green
hi Search gui=UNDERLINE guifg=black guibg=yellow
hi Search cterm=UNDERLINE ctermfg=black ctermbg=yellow
hi Visual gui=UNDERLINE guifg=black guibg=gray
hi Visual cterm=UNDERLINE ctermfg=black ctermbg=gray

hi ErrorMsg gui=UNDERLINE guifg=black guibg=red
hi ErrorMsg cterm=UNDERLINE ctermfg=black ctermbg=red
hi WarningMsg gui=UNDERLINE guifg=black guibg=yellow
hi WarningMsg cterm=UNDERLINE ctermfg=black ctermbg=yellow
hi ModeMsg gui=UNDERLINE guifg=black guibg=green
hi ModeMsg cterm=UNDERLINE ctermfg=black ctermbg=green

hi Ignore gui=NONE guifg=black guibg=black
hi Ignore cterm=NONE ctermfg=darkgray ctermbg=black
hi Todo gui=UNDERLINE guifg=black guibg=red
hi Todo cterm=UNDERLINE ctermfg=black ctermbg=red
hi Error gui=UNDERLINE guifg=lightgray guibg=red
hi Error cterm=UNDERLINE ctermfg=lightgray ctermbg=red
hi Special gui=NONE guifg=lightcyan guibg=black
hi Special cterm=NONE ctermfg=lightcyan ctermbg=NONE
hi Identifier gui=NONE guifg=cyan guibg=black
hi Identifier cterm=NONE ctermfg=cyan ctermbg=NONE
hi Constant gui=NONE guifg=lightred guibg=black
hi Constant cterm=NONE ctermfg=lightred ctermbg=NONE
hi Statement gui=NONE guifg=lightyellow guibg=black
hi Statement cterm=NONE ctermfg=229 ctermbg=NONE
hi Comment gui=NONE guifg=lightblue guibg=black
hi Comment cterm=NONE ctermfg=lightblue ctermbg=NONE
hi Underlined gui=UNDERLINE guifg=lightblue guibg=black
hi Underlined cterm=UNDERLINE ctermfg=lightblue ctermbg=NONE
hi PreProc gui=NONE guifg=lightmagenta guibg=black
hi PreProc cterm=NONE ctermfg=lightmagenta ctermbg=NONE
hi Type gui=NONE guifg=lightgreen guibg=black
hi Type cterm=NONE ctermfg=lightgreen ctermbg=NONE

hi SpecialKey gui=NONE guifg=cyan guibg=black
hi SpecialKey cterm=NONE ctermfg=cyan ctermbg=NONE
hi Directory gui=NONE guifg=lightgreen guibg=black
hi Directory cterm=NONE ctermfg=lightgreen ctermbg=NONE
hi LineNr gui=UNDERLINE guifg=black guibg=darkgray
hi LineNr cterm=UNDERLINE ctermfg=black ctermbg=darkgray

hi NonText gui=NONE guifg=darkgray guibg=black
hi NonText cterm=NONE ctermfg=darkgray ctermbg=NONE

hi DiffText gui=UNDERLINE guifg=black guibg=red
hi DiffText cterm=UNDERLINE ctermfg=black ctermbg=red
hi DiffChange gui=UNDERLINE guifg=black guibg=lightgray
hi DiffChange cterm=UNDERLINE ctermfg=black ctermbg=lightgray
hi DiffDelete gui=NONE guifg=black guibg=blue
hi DiffDelete cterm=NONE ctermfg=black ctermbg=blue
hi DiffAdd gui=UNDERLINE guifg=black guibg=cyan
hi DiffAdd cterm=UNDERLINE ctermfg=black ctermbg=cyan

hi htmlLink guifg=lightblue guibg=black
hi htmlLink ctermfg=lightblue ctermbg=NONE

hi htmlBold gui=bold
hi htmlBold cterm=bold
hi htmlUnderline gui=underline
hi htmlUnderline cterm=underline
hi htmlBoldUnderline gui=bold,underline
hi htmlBoldUnderline cterm=bold,underline
hi htmlItalic gui=italic
hi htmlItalic cterm=italic
hi htmlBoldItalic gui=bold,italic
hi htmlBoldItalic cterm=bold,italic
hi htmlUnderlineItalic gui=underline,italic
hi htmlUnderlineItalic cterm=underline,italic
hi htmlBoldUnderlineItalic gui=bold,underline,italic
hi htmlBoldUnderlineItalic cterm=bold,underline,italic

hi Pmenu cterm=bold ctermbg=brown guibg=brown gui=bold
