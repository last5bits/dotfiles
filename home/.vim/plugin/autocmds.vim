if has('autocmd')
    if v:version >= '704'
        augroup autoSaveAndRead
            autocmd!
            autocmd TextChanged,InsertLeave,FocusLost * silent! wall
            autocmd CursorHold * silent! checktime
        augroup END
    endif

    augroup misc
        autocmd VimResized * execute "normal! \<c-w>="
        " Exclude private files from being saved in the undodir
        autocmd BufReadPre,FileReadPre $HOME/Private/* setlocal noundofile
        " Open the project root.
        autocmd FileType netrw nnoremap <buffer> g~ :Gedit :/<CR>
        " Use Shift-K to open cppman
        autocmd FileType cpp nnoremap <silent><buffer> K <Esc>:Cppman <cword><CR>
        " Poor man vim-rooter, git only, using fugitive
        autocmd BufLeave * let b:last_cwd = getcwd()
        autocmd BufEnter * if exists('b:last_cwd')
                        \|   execute 'lcd' b:last_cwd
                        \| else
                        \|   silent! Glcd
                        \| endif
    augroup END

    augroup diffing
        autocmd!
        " Disable syntax when diffing
        au FilterWritePost * if &diff | silent setlocal syntax=OFF |endif
        au BufEnter * if !&diff | silent setlocal syntax=ON |endif
    augroup END

    augroup qf
        autocmd!
        " Exclude quickfix buffer from :bnext and :bprev
        autocmd FileType qf set nobuflisted
        " Open quick-fix window for vim-fugitive automatically
        autocmd QuickFixCmdPost *grep* cwindow
    augroup END

    augroup netrw-sensible
        autocmd!
        autocmd FileType netrw nmap <buffer> <silent> <C-l> <Plug>NetrwRefresh
    augroup END
endif
