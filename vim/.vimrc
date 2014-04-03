" vim: fdm=marker foldenable
" Max Cantor's .vimrc File
" "zo" to open folds, "zc" to close, "zn" to disable.

" Basic Settings {{{

call pathogen#infect()

set modelines=2

" For clever completion with the :find command
set path+=**

" Always use bash syntax for sh filetype
let g:is_bash=1

" Activate auto filetype detection
filetype plugin indent on

" Search
set ignorecase smartcase
set grepprg=grep\ -IrsnH

" Window display
set showcmd ruler laststatus=2

" Splits
set splitright

" Buffers
set history=500
set hidden
if exists("&undofile")
    set undofile
endif

" Spelling
set dictionary+=/usr/share/dict/words thesaurus+=$HOME/.thesaurus

" Text display
set listchars=trail:.,tab:>-,extends:>,precedes:<,nbsp:¬
set list

" Typing behavior
set backspace=indent,eol,start
set showmatch
set wildmode=full
set wildmenu
set complete-=i

" Formatting
set nowrap
set tabstop=4 shiftwidth=4 softtabstop=4

" Status line
set statusline=%F%(\ %h%1*%m%*%r%w%)\ (%{&ff}%(\/%Y%))\ [\%03.3b]\ [0x\%02.2B]%=%-14.(%l,%c%V%)\ %P/%L

" Make the modification indicator [+] white on red background
au ColorScheme * hi User1 gui=bold term=bold cterm=bold guifg=white guibg=red ctermfg=white ctermbg=red

" Tweak the color of the fold display column
au ColorScheme * hi FoldColumn cterm=bold ctermbg=233 ctermfg=146

set background=dark
color hhdgray

syntax enable

if has('mac')
    autocmd BufEnter *.md exe 'noremap <F5> :!open -a "Google Chrome" %:p<CR>'
    autocmd BufEnter *.md exe 'noremap <F6> :!open -a "Mou" %:p<CR>'
endif

au! BufNewFile,BufRead /*apache* set ft=apache
au! BufNewFile,BufRead /*lighttpd*.conf set ft=lighty
au! BufNewFile,BufRead *.ejs set ft=jst.html
au! BufNewFile,BufRead *.ce set ft=python
au! BufNewFile,BufRead */diary/*.txt set ft=diary

" create two empty side buffers to make the diary text width more readable,
" without actually setting a hard textwidth which requires inserting CR's
au! VimEnter */diary/*.txt vsplit | vsplit | enew | vertical resize 50 | wincmd t | enew | vertical resize 50 | wincmd l

" Flowork
au! BufNewFile,BufRead $HOME/src/flowork/Flowork/floworktg/floworktg/public/*.js setl sw=3 sts=3 fdm=indent et
au! BufNewFile,BufRead $HOME/src/flowork/* set path+=floworktg/floworktg/public includeexpr=substitute(v:fname,'\/*','','')

" Task update
au! BufNewFile,BufRead tasksheet_* set ft=tasksheet | call UpdateTaskDisplay()
au! BufWritePost * call UpdateTaskDisplay()

" Spaces Only
au! FileType markdown,cpp,hpp,vim,sh,html,eruby,htmldjango,css,javascript,python,ruby,sass,scss setl expandtab list

" Tabs Only
au! FileType c,h setl foldmethod=syntax noexpandtab nolist
au! FileType gitconfig setl noexpandtab nolist

" Folding
au! FileType html,eruby,htmldjango,css,javascript setl foldmethod=indent foldenable
au! FileType python,ruby setl foldmethod=indent foldenable

" Tabstop/Shiftwidth
au! FileType rst setl softtabstop=3 shiftwidth=3
au! FileType sass,scss setl softtabstop=2 shiftwidth=2

" Other
au! FileType python let b:python_highlight_all=1
au! FileType sass,scss setl iskeyword+=-
au! FileType diary setl wrap linebreak nolist

" }}}

" Backups & .vimrc Editing {{{

" TODO Just use $VIMRUNTIME for this
if has('win32')
    " Windows filesystem
    set directory=$HOME\VimBackups\swaps,$HOME\VimBackups,C:\VimBackups,.
    set backupdir=$HOME\VimBackups\backups,$HOME\VimBackups,C:\VimBackups,.
    if exists("&undodir")
        set undodir=$HOME\VimBackups\undofiles,$HOME\VimBackups,C:\VimBackups,.
    endif
    " TODO who cares about pre-vim 7...
    if($MYVIMRC == "")  " Pre-Vim 7
        let $MYVIMRC = $VIM."\_vimrc"
    endif
    if has("gui_running")
      set guifont=Inconsolata:h12:cANSI
    endif
else
    " Linux filesystem
    " set directory=$HOME/$STY/.backups//
    " set backupdir=$HOME/$STY/.backups//
    set directory=$HOME/.backups/swaps,$HOME/.backups,$HOME/tmp,.
    set backupdir=$HOME/.backups/backups,$HOME/.backups,$HOME/tmp,.
    if exists("&undodir")
        set undodir=$HOME/.backups/undofiles,$HOME/.backups,$HOME/tmp,.
    endif
    if($MYVIMRC == "")  " Pre-Vim 7
        let $MYVIMRC = $HOME."/.vimrc"
    endif
endif

" }}}

" Key Mappings {{{

" Easy quickfix navigation
nnoremap <C-n> :cn<CR>
nnoremap <C-p> :cp<CR>

" Easy header/source swap
nnoremap [f :call SourceHeaderSwap()<CR>

" Usual ^^ behavior re-adds to the buffer list; this leaves it hidden
nnoremap <C-^> :b#<CR>

" Yank all top-level Python methods into register m
nnoremap ,m let @m="" \| g/def /exe "normal 0f l\"Myt(" \| let @m.=","

" Select the stuff I just pasted
nnoremap gV `[V`]

" Easy saving
inoremap <C-u> <ESC>:w<CR>

" Create a new HTML document.
nnoremap ,html :set ft=html<CR>i<!doctype html><CR><html><CR><head><CR><title></title><CR><link rel="stylesheet" type="text/css" href="style.css"><CR><script type="text/javascript" src="script.js"></script><CR></head><CR><body><CR></body><CR></html><ESC>?title<CR>2hi

" Bind for easy pasting
set pastetoggle=<F12>

" De-fuckify whitespace
nnoremap <F4> :retab<CR>:%s/\s\+$//e<CR><C-o>

" De-fuckify syntax hilighting
nnoremap <F3> :syn sync fromstart<CR>

" Editing vimrc
nnoremap ,v :source $MYVIMRC<CR>
nnoremap ,e :edit $MYVIMRC<CR>

" Quickly change search hilighting
nnoremap <silent> ; :set invhlsearch<CR>

" Change indent continuously
vmap < <gv
vmap > >gv

" Tabs
if exists( '*tabpagenr' ) && tabpagenr('$') != 1
    nnoremap ,V :tabdo source $MYVIMRC<CR>
else
    nnoremap ,V :bufdo source $MYVIMRC<CR>
endif

" camelCase => camel_case
vnoremap ,case :s/\v\C(([a-z]+)([A-Z]))/\2_\l\3/g<CR>

" Session mappings
nnoremap ,s :mksession! Session.vim<CR>

" Instant Python constructors
nnoremap ,c 0f(3wyt)o<ESC>pV:s/\([a-z_]\+\),\?/self.\1 = \1<C-v><CR>/g<CR>ddV?def<CR>j

" Diff Mode
nnoremap <silent> ,j :if &diff \| exec 'normal ]czz' \| endif<CR>
nnoremap <silent> ,k :if &diff \| exec 'normal [czz' \| endif<CR>
nnoremap <silent> ,p :if &diff \| exec 'normal dp' \| endif<CR>
nnoremap <silent> ,o :if &diff \| exec 'normal do' \| endif<CR>
nnoremap <silent> ZD :if &diff \| exec ':qall' \| endif<CR>

" Clean up Sass source
vnoremap ,S :call CleanupSassSource()<CR>

" Movement between tabs OR buffers
nnoremap <silent> L :call MyNext()<CR>
nnoremap <silent> H :call MyPrev()<CR>

" Resizing split windows
nnoremap ,w :call SwapSplitResizeShortcuts()<CR>

" Easy changing for scrolloff
nnoremap ,b :call SwapBrowseMode()<CR>

" Wraps visual selection in an HTML tag
vnoremap ,w <ESC>:call VisualHTMLTagWrap()<CR>

" Word processing
nnoremap ,N :call WordProcessingToggle()<CR>

" For Notepad-like handling of wrapped lines
nnoremap ,n :call NotepadLineToggle()<CR>

" Quick function prototype
nnoremap ,f :call QuickFunctionPrototype()<CR>

" Syntax group introspection
nnoremap g<C-h> :echo GetSynInfo()<CR>

" Yank current visual selection into screen paste buffer
vnoremap \y "zy:call ScreenGet($SCREENSWAP, @z)<CR>

" Yank current full filename into screen paste buffer
nnoremap \f :call ScreenGet($SCREENFILE, expand('%:p'))<CR>

" Directory of current file (not pwd)
cnoremap %% <C-R>=expand('%:h').'/'<CR>

" Redo last Ex command with bang
nnoremap ,! q:k0ea!<ESC>

" Swap order of Python function arguments
nnoremap <silent> ,- :%s/\(self\.\)\?<C-R><C-W>(\(self, \)\?\([a-zA-Z]\+\), \?\([a-zA-Z]\+\))/\1<C-R><C-W>(\2\4, \3)/g<CR>

" RST headers
nnoremap <silent> <C-_> :let chr=nr2char(getchar()) \| call RSTHeader(chr)<CR>
inoremap <silent> <C-_>1 <ESC>:call RSTHeader("=")<CR>o
inoremap <silent> <C-_>2 <ESC>:call RSTHeader("-")<CR>o
inoremap <silent> <C-_>3 <ESC>:call RSTHeader("^")<CR>o

" Swap tab/space mode
nnoremap ,<TAB> :set et! list!<CR>

" }}}

" Custom Functions {{{

" CleanupSassSource() {{{

function! CleanupSassSource()
  " All comma delimiters should have a following space
  silent '<,'>s/,\([^\s]\)/, \1/ge
  " All comma delimiters should have 1 and only 1 space
  silent '<,'>s/,\s\{2,\}/, /ge
endfunction

" }}}

" Miscellaneous {{{
function! RSTHeader(chr)
    " inserts an RST header without clobbering any registers
    put =substitute(getline('.'), '.', a:chr, 'g')
endfunction

function! CurrLineLength()
    return len(getline(line(".")))
endfunction

function! LineLength(row)
    return len(getline(a:row))
endfunction
" }}}

" Source/Header Swap {{{
function! SourceHeaderSwap()
    if expand('%:h') == 'content/ui'
        execute ":edit mods/base/ui/".expand('%:t:r').".py"
    elseif expand('%:h') == 'mods/base/ui'
        execute ":edit content/ui/".expand('%:t:r').".html"
    elseif expand('%:e') == 'h'
        if filereadable(expand('%:r').".c")
            execute ":edit ".expand('%:r').".c"
        else
            execute ":edit ".expand('%:r').".cpp"
        endif
    else
        edit %<.h
    endif
endfunction
" }}}

" Syntax Info {{{
function! GetSynInfo()
    let stack = synstack(line("."), col("."))

    let info = ""

    for synid in reverse(stack)
        if strlen(info)
            let info .= " < "
        endif

        let syn = GetSynDict(synid)
        let info .= GetSynInfoString(syn)
    endfor

    return info
endfunction

function! GetSynInfoString(syndict)
    if a:syndict["syn"] != a:syndict["hi"]
        let add_hi = a:syndict["hi"]." "
    else
        let add_hi = ""
    endif

    return a:syndict["syn"]." (".add_hi."fg=".a:syndict["fg"]." bg=".a:syndict["bg"].")"
endfunction

function! GetHereSynId(trans)
    return synID(line("."), col("."), a:trans)
endfunction

function! GetSynDict(synid)
    let hiid = synIDtrans(a:synid)

    let syn = synIDattr(a:synid, "name")
    let hi = synIDattr(hiid, "name")
    let fg = synIDattr(hiid, "fg")
    let bg = synIDattr(hiid, "bg")

    return {"syn":syn, "hi":hi, "fg":fg, "bg":bg}
endfunction
" }}}

" Screen Functions {{{
let $SCREENSWAP = $HOME."/.screenquickswap"
let $SCREENFILE = $HOME."/.screenquickfile"

function! ScreenGet(targetpath, contents)
    " XXX TODO follow symlinks on contents for files
    call WriteTo(a:targetpath, a:contents)
    call StripEmptyLines(a:targetpath) " this is necessary because the redir in WriteTo ALWAYS inserts a newline
    call StripSubversionBupkus(a:targetpath) " this is necessary because the redir in WriteTo ALWAYS inserts a newline
    call ScreenYank(a:targetpath)
    redraw!
endfunction

function! WriteTo(targetpath, contents)
    silent exec "redir! > ".a:targetpath."\|silent echo \"".escape(a:contents,'"')."\"\|redir END"
endfunction

function! StripEmptyLines(filepath)
    " XXX TODO modify this to only strip the FIRST newline
    silent exec "!sed -i '/^$/d' ".a:filepath
endfunction

function! StripSubversionBupkus(filepath)
    silent exec "!sed -ri 's_(\.svn/text-base/|\.svn-base$)__g' ".a:filepath
endfunction

function! ScreenYank(filepath)
    silent exec "!screen -S $STY -X readbuf '".a:filepath."'"
endfunction
" }}}

" MyNext() and MyPrev(): Movement between tabs OR buffers {{{
function! MyNext()
    if exists( '*tabpagenr' ) && tabpagenr('$') != 1
        " Tab support && tabs open
        normal gt
    else
        " No tab support, or no tabs open
        execute ":bnext"
    endif
endfunction
function! MyPrev()
    if exists( '*tabpagenr' ) && tabpagenr('$') != '1'
        " Tab support && tabs open
        normal gT
    else
        " No tab support, or no tabs open
        execute ":bprev"
    endif
endfunction
" }}}

" SwapSplitResizeShortcuts(): Resizing split windows {{{
if !exists( 'g:resizeshortcuts' )
    let g:resizeshortcuts = 'horizontal'
    nnoremap _ <C-w>-
    nnoremap + <C-w>+
endif

function! SwapSplitResizeShortcuts()
    if g:resizeshortcuts == 'horizontal'
        let g:resizeshortcuts = 'vertical'
        nnoremap _ <C-w><
        nnoremap + <C-w>>
        echo "Vertical split-resizing shortcut mode."
    else
        let g:resizeshortcuts = 'horizontal'
        nnoremap _ <C-w>-
        nnoremap + <C-w>+
        echo "Horizontal split-resizing shortcut mode."
    endif
endfunction
" }}}

" SwapBrowseMode(): Easy changing for scrolloff {{{
if !exists( 'g:browsemode' )
    let g:browsemode = 'nobrowse'
    set sidescrolloff=0
    set scrolloff=0
endif

function! SwapBrowseMode()
    if g:browsemode == 'nobrowse'
        let g:browsemode = 'browse'
        set sidescrolloff=999
        set scrolloff=999
        echo "Browse mode enabled."
    else
        let g:browsemode = 'nobrowse'
        set sidescrolloff=0
        set scrolloff=0
        echo "Browse mode disabled."
    endif
endfunction
" }}}

" VisualHTMLTagWrap(): Wraps visual selection in an HTML tag {{{
function! VisualHTMLTagWrap()
    let html_tag = input( "html_tag to wrap block: ")
    let jumpright = 2 + strlen( html_tag )
    normal `<
    let init_line = line( "." )
    exe "normal i<".html_tag.">"
    normal `>
    let end_line = line( "." )
    " Don't jump if we're on a new line
    if( init_line == end_line )
        " Jump right to compensate for the characters we've added
        exe "normal ".jumpright."l"
    endif
    exe "normal a</".html_tag.">"
endfunction
" }}}

" QuickFunctionPrototype(): Quickly generate a function prototype. {{{
function! QuickFunctionPrototype()
    let function_name = input( "function name: ")
    if &ft == "php"
        " The extra a\<BS> startinsert! is because this function drops
        " out of insert mode when it finishes running, and startinsert
        " ignores auto-indenting.
        exe "normal ofunction ".function_name."(){\<CR>}\<ESC>Oa\<BS>"
        startinsert!
    else
        echo "Filetype not supported."
    endif
endfunction
" }}}

" WordProcessingToggle() {{{
function! WordProcessingToggle()
    if !exists('b:wordprocessing') || b:wordprocessing
        let b:wordprocessing = 'true'
        setlocal wrap linebreak nolist
        setlocal textwidth=0
        echo "Word processing mode enabled."
    else
        let b:wordprocessing = 'false'
        setlocal nowrap nolinebreak list
        setlocal textwidth=80
        echo "Word processing mode disabled."
    endif
endfunction
" }}}

" NotepadLineToggle(): For Notepad-like handling of wrapped lines {{{
function! NotepadLineToggle()
    if !exists('b:notepadlines') || b:notepadlines
        nnoremap <buffer> j gj
        nnoremap <buffer> k gk
        let b:notepadlines = 'true'
        setlocal wrap
        echo "Notepad wrapped lines enabled."
    else
        unmap <buffer> j
        unmap <buffer> k
        let b:notepadlines = 'false'
        setlocal nowrap
        echo "Notepad wrapped lines disabled."
    endif
endfunction
" }}}

" Tasksheets {{{

function! UpdateTaskRemain(line_no, remain, hours_worked)
    let l:check_line = a:line_no
    let l:last_line = line('$')
    let l:already_has_summary = 0

    " echo "update " . a:line_no . " remaining: " . string(a:remain) . " with worked: " . string(a:hours_worked)

    while l:check_line <= l:last_line
        if getline(l:check_line + 1) == ""
            " last line before empty (end of task clause)
            break
        endif
        let l:check_line += 1
    endwhile

    let l:line = getline(l:check_line)

    if l:line =~ "^REMAIN" || l:line =~ "^TOTAL"
        let l:already_has_summary = 1
    endif

    let l:total = "TOTAL: " . string(a:hours_worked)

    if a:remain > 0.0
        let l:new_summary = "REMAIN: " . string(a:remain) . " (" . l:total . ")"
    else
        let l:new_summary = l:total
    endif

    if l:already_has_summary
        call setline(l:check_line, l:new_summary)
    else
        call append(l:check_line, l:new_summary)
    endif
endfunction

function! UpdateTaskDisplay()
    if &ft != 'tasksheet' | return | endif
    let l:default_project = substitute(system("python custom_calc_timesheet.py " . expand("%") . " default_project"), '\n', '', '')
    let l:tasks = split(system("python custom_calc_timesheet.py " . expand("%") . " exhaust"), '\n')

    exe "normal mz"

    syn clear taskBudgetExceeded
    syn clear taskBudgetExhausted

    for l:task in l:tasks
        let [l:task_id, l:project, l:remain, l:hours_worked] = split(l:task, " ")

        if str2float(l:remain) < 0.0
            exe "syn match taskBudgetExceeded /" . l:task_id . "/ contained"
        elseif str2float(l:remain) == 0.0
            exe "syn match taskBudgetExhausted /" . l:task_id . "/ contained"
        endif

        if l:project == l:default_project
            let l:default_project_pattern = "\\[" . l:project . "\\]"
            let l:anything_else_pattern = "[^\\[]"
            let l:project_pattern = "\\(" . l:default_project_pattern . "\\|" . l:anything_else_pattern . "\\)"
        else
            let l:project_pattern = "\\[" . l:project . "\\]"
        endif

        exe "g/^" . l:task_id . " " . l:project_pattern . "/call UpdateTaskRemain(line('.'), " . l:remain . ", " . l:hours_worked . ")"
    endfor

    exe "normal `z"
endfunction

" do this so it's called after everything is cleared by `syntax enable` when
" re-sourcing .vimrc
call UpdateTaskDisplay()

" }}}

" }}}

" Local Settings {{{
if filereadable($HOME."/.local/vim/.vimrc")
    source $HOME/.local/vim/.vimrc
endif
" }}}
