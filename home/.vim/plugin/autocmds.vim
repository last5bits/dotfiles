if has('autocmd')
    autocmd VimResized * execute "normal! \<c-w>="

    if v:version >= '704'
        augroup autoSaveAndRead
            autocmd!
            autocmd TextChanged,InsertLeave,FocusLost * silent! wall
            autocmd CursorHold * silent! checktime
        augroup END
    endif
endif
