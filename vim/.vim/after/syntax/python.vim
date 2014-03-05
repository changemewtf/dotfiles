unlet b:current_syntax
syn include $VIMRUNTIME/syntax/html.vim

unlet b:current_syntax
syn include @xmlTop $VIMRUNTIME/syntax/xml.vim

unlet b:current_syntax
syn include @sqlTop $VIMRUNTIME/syntax/sql.vim
syn cluster sqlTop remove=sqlString,sqlComment

let b:current_syntax = 'python'

syn region pythonString start=/html = \zs"""/ end=/"""/ contains=@htmlTop
syn region pythonString start=/xml = \zs"""/ end=/"""/ contains=@xmlTop
syn region pythonString start=/sql = \z('''\|"""\)/ end=/\z1/ contains=@sqlTop

" Clear sqloracle.vim's problematic 'syn sync ccomment' directive
syn sync clear

" Directly copied from vim73/syntax/python.vim; we just want to 'reinstate' it
syn sync match pythonSync grouphere NONE "^\s*\%(def\|class\)\s\+\h\w*\s*("
