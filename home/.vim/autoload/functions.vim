scriptencoding utf-8

let s:middot='·'
let s:raquo='»'
let s:small_l='ℓ'

" Override default `foldtext()`, which produces something like:
"
"   +---  2 lines: source $HOME/.vim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim--------------------------------
"
" Instead returning:
"
"   »··[2ℓ]··: source $HOME/.vim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim···································
"
function! functions#foldtext() abort
  let l:lines='[' . (v:foldend - v:foldstart + 1) . s:small_l . ']'
  let l:first=substitute(getline(v:foldstart), '\v *', '', '')
  let l:dashes=substitute(v:folddashes, '-', s:middot, 'g')
  return s:raquo . s:middot . s:middot . l:lines . l:dashes . ': ' . l:first
endfunction

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

function! functions#toggle_eventignore() abort
    if has('autocmd')
        if &eventignore == ""
            set eventignore=TextChanged,InsertLeave,FocusLost,CursorHold
        else
            set eventignore=
        endif
    else
        echoerr "No 'autocmd' functionality available"
    endif
endfunction
