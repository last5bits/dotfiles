" Change your current directory to one you're working in
command! Cd cd %:p:h
command! Lcd lcd %:p:h

" Pretty JSON
command! PrettyJson %!python -m json.tool

" Opens help in the same buffer
command! -nargs=1 -complete=help H :enew | :set buftype=help | :h <args>
