exe "setlocal textwidth=80"
if exists('+colorcolumn')
  setlocal colorcolumn=+1
endif

" Treat Doxygen comments as comments.
set comments^=:///

" Enable termdebug.
if v:version >=800
  packadd termdebug
endif

execute 'map <buffer> <C-K> :py3f ' . functions#get_clang_format_path() . '<CR>'
