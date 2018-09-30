if has('autocmd')
    autocmd VimResized * execute "normal! \<c-w>="

    if v:version >= '704'
        augroup autoSaveAndRead
            autocmd!
            autocmd TextChanged,InsertLeave,FocusLost * silent! wall
            autocmd CursorHold * silent! checktime
        augroup END
    endif

    " Use Shift-K to open cppman
    autocmd FileType cpp nnoremap <silent><buffer> K <Esc>:Cppman <cword><CR>

    " Exclude private files from being saved in the undodir
    augroup skipUndoFile
        autocmd BufReadPre,FileReadPre $HOME/Private/* setlocal noundofile
    augroup END

    augroup qf
        autocmd!
        " Exclude quickfix buffer from :bnext and :bprev
        autocmd FileType qf set nobuflisted

        " Open quick-fix window for vim-fugitive automatically
        autocmd QuickFixCmdPost *grep* cwindow
    augroup END
endif
