syntax clear

syn match   taskComplete        /^COMPLETE$/
syn match   Comment             /^\/\/.*$/

" define task description color for this region; it's the best way to express
" 'everything except the taskNumber and taskBudget'. since the budget is
" optional, we can't use nextgroup, because taskDescription would always match
" first.
syn region  taskDefinitionLine  start=/^[0-9]\{4\}/ end=/$/ oneline contains=taskNumber,taskBudget,taskProject
syn match   taskNumber          /^[0-9]\{4\}/ contains=@taskNumberMod contained
syn match   taskBudget          /[0-9]\+\.[0-9]\{2\}/ contained
syn region  taskProject         start=/\[/hs=e+1 end=/\]/he=s-1 oneline contained

syn region  taskRemain          matchgroup=taskRemainHeader start=/^REMAIN/ end=/$/ oneline contains=taskRemainAmount,taskTotal
syn match   taskRemainAmount    /[0-9]\+\.[0-9]\{1,2\}/ contained

syn region  taskTotal           matchgroup=taskTotalHeader start=/TOTAL/ end=/$/ oneline contains=taskTotalAmount
syn match   taskTotalAmount     /[0-9]\+\.[0-9]\{1,2\}/ contained

syn region  sheetSettings       matchgroup=settingsHeader start=/^Settings/ matchgroup=NONE end=/$/ oneline contains=settingsHeader,settingPair
syn region  settingPair         matchgroup=settingKey start=/[a-zA-Z_]\+/ matchgroup=settingValue end=/[^, ]\+/ oneline contained

hi link taskNumber          Keyword
hi link taskDefinitionLine  Constant
hi link taskBudget          Identifier
hi taskProject              ctermfg=red

hi taskProjectHeader        ctermfg=red

hi link taskRemainHeader    Keyword
hi link taskRemainAmount    Directory
hi link taskTotalHeader     Keyword
hi link taskTotalAmount     Directory

hi link settingsHeader      Directory
hi link settingKey          Constant
hi link settingValue        Identifier

hi link taskComplete        Directory

syntax cluster taskNumberMod contains=taskBudgetExceeded,taskBudgetExhausted
hi link taskBudgetExceeded  ErrorMsg
hi link taskBudgetExhausted Ignore

let b:current_syntax = "tasksheet"
