" Change your current directory to one you're working in
command! Cd cd %:p:h
command! Lcd lcd %:p:h

" Pretty JSON
command! PrettyJson %!python -m json.tool

" Opens help in the same buffer
command! -nargs=1 -complete=help H :enew | :set buftype=help | :h <args>

" Ignore specific regexps in vimdiff
function! IgnoreDiff(pattern)
    let opt = ""
    if &diffopt =~ "icase"
      let opt = opt . "-i "
    endif
    if &diffopt =~ "iwhite"
      let opt = opt . "-b "
    endif
    let cmd = "!diff -a --binary " . opt .
      \ " <(perl -pe 's/" . a:pattern .  "/\".\" x length($0)/gei' " .
      \ v:fname_in .
      \ ") <(perl -pe 's/" . a:pattern .  "/\".\" x length($0)/gei' " .
      \ v:fname_new .
      \ ") > " . v:fname_out
    echo cmd
    silent execute cmd
    redraw!
    return cmd
endfunction
command! IgnoreHexDiff set diffexpr=IgnoreDiff('0x[0-9a-fA-F]+') | diffupdate
command! IgnoreDecimalDiff set diffexpr=IgnoreDiff('\\.\\d+') | diffupdate
command! NormalDiff set diffexpr= | diffupdate

" Invoke cppman in a new tmux window
command! -nargs=+ Cppman silent! call system("tmux new-window cppman " . expand(<q-args>))
