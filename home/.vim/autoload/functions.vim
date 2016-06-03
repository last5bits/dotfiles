" Switch to plaintext mode with: call functions#plaintext()
function! functions#plaintext() abort
    setlocal spell
    setlocal spell spelllang=en_us
    setlocal complete+=kspell
    setlocal textwidth=0
    setlocal wrap
    setlocal wrapmargin=0

    nnoremap <buffer> j gj
    nnoremap <buffer> k gk
endfunction
