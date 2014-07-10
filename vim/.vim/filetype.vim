if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  au! BufNewFile,BufRead /*apache*          setfiletype apache
  au! BufNewFile,BufRead /*lighttpd*.conf   setfiletype lighty
  au! BufNewFile,BufRead *.ejs              setfiletype jst.html
  au! BufNewFile,BufRead *.ce               setfiletype python
  au! BufNewFile,BufRead */diary/*.txt      setfiletype diary
  au! BufNewFile,BufRead *.ru               setfiletype ruby
  au! BufNewFile,BufRead *.md               setfiletype markdown
augroup END
