if has('autocmd')
    autocmd VimResized * execute "normal! \<c-w>="

    augroup autoSaveAndRead
        autocmd!
        autocmd TextChanged,InsertLeave,FocusLost * silent! wall
        autocmd CursorHold * silent! checktime
    augroup END
endif
