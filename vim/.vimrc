" vim: fdm=marker foldenable
" Max Cantor's .vimrc File
" "zo" to open folds, "zc" to close, "zn" to disable.

" Basic Settings {{{

set background=dark
color hhdgray
set modeline

" Activate auto filetype detection
filetype plugin indent on
syntax enable

" Search
set ignorecase smartcase
set grepprg=vimsgrep\ $*

" Window display
set showcmd ruler laststatus=2

" Splits
set splitright

" Buffers
set hidden
if exists("&undofile")
    set undofile
endif

" Spelling
set dictionary+=/usr/share/dict/words thesaurus+=$HOME/.thesaurus

" Text display
set listchars=trail:.,tab:>-,extends:>,precedes:<

" Typing behavior
set backspace=indent,eol,start
set showmatch

" Formatting
set textwidth=80
set nowrap

" Status line
set statusline=%F%(\ %h%1*%m%*%r%w%)\ (%{&ff}%(\/%Y%))\ [\%03.3b]\ [0x\%02.2B]%=%-14.(%l,%c%V%)\ %P/%L

hi User1 term=bold cterm=bold ctermfg=white ctermbg=red

autocmd BufNewFile,BufRead /*apache* setfiletype apache
autocmd BufNewFile,BufRead /*lighttpd*.conf setfiletype lighty

autocmd FileType python,pyfusion let b:python_highlight_all=1
autocmd FileType python,pyfusion,ruby,html setl list fdm=indent foldenable sts=4 sw=4 et

autocmd FileType rst setl sw=3 sts=3

" }}}

" Backups & .vimrc Editing {{{

" TODO Just use $VIMRUNTIME for this
if has('win32')
    " Windows filesystem
    set directory=C:\VimBackups
    set backupdir=C:\VimBackups
    if exists("&undodir")
        set undodir=C:\VimBackups
    endif
    " TODO who cares about pre-vim 7...
    if($MYVIMRC == "")  " Pre-Vim 7
        let $MYVIMRC = $VIM."\_vimrc"
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

" Yank all top-level Python methods into register m
nnoremap ,m let @m="" \| g/def /exe "normal 0f l\"Myt(" \| let @m.=","

" Select the stuff I just pasted
nnoremap gV `[V`]

" Easy saving
inoremap <C-u> <ESC>:w<CR>

" Create a new HTML document.
nnoremap ,html :set ft=html<CR>i<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"><CR><html lang="en"><CR><head><CR><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><CR><title></title><CR><link rel="stylesheet" type="text/css" href="style.css"><CR><script type="text/javascript" src="script.js"></script><CR></head><CR><body><CR></body><CR></html><ESC>?title<CR>2hi

" Bind for easy pasting
set pastetoggle=<F12>

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

" Quick file documentation stub in Python
nnoremap <silent> ,t ggO"""Author: Max Cantor <mcantor@ag.com>Date: =strftime("%B %e, %Y <%m/%d/%Y>")"""__id__ = "$Id"ggoGOAL: 

" RST headers
nnoremap <silent> <C-_> :let chr=nr2char(getchar()) \| call RSTHeader(chr)<CR>
inoremap <silent> <C-_>1 <ESC>:call RSTHeader("=")<CR>o
inoremap <silent> <C-_>2 <ESC>:call RSTHeader("-")<CR>o
inoremap <silent> <C-_>3 <ESC>:call RSTHeader("^")<CR>o

" }}}

" Custom Functions {{{

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
        setlocal lbr ai
        setlocal tw=80
        setlocal fo-=cq fo+=tan1
        echo "Word processing mode enabled."
    else
        let b:wordprocessing = 'false'
        setlocal nolbr noai
        setlocal fo+=cq fo-=tan1
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
" }}}

" Local Settings {{{

if filereadable($HOME."/.local/vim/.vimrc")
    source $HOME/.local/vim/.vimrc
endif

" }}}
