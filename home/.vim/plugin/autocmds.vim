if has('autocmd')
    augroup misc
        autocmd VimResized * execute "normal! \<c-w>="
        " Exclude private files from being saved in the undodir
        autocmd BufReadPre,FileReadPre $HOME/Private/* setlocal noundofile
        " Poor man vim-rooter, git only, using fugitive
        autocmd BufLeave * let b:last_cwd = getcwd()
        autocmd BufEnter * if exists('b:last_cwd')
                        \|   execute 'lcd' b:last_cwd
                        \| else
                        \|   silent! Glcd
                        \| endif
    augroup END

    augroup qf
        autocmd!
        " Exclude quickfix buffer from :bnext and :bprev
        autocmd FileType qf set nobuflisted
        " Open quick-fix window for vim-fugitive automatically
        autocmd QuickFixCmdPost *grep* cwindow
    augroup END

    augroup netrw-mappings
        autocmd!
        autocmd FileType netrw nmap <buffer> <silent> <C-r> <Plug>NetrwRefresh
        " Open the project root.
        autocmd FileType netrw nnoremap <buffer> g~ :Gedit :/<CR>
    augroup END

    augroup async-run
        autocmd!
        autocmd User AsyncRunStart call asyncrun#quickfix_toggle(0, 1)
    augroup END

    augroup project-specific
        autocmd!
        autocmd BufRead,BufNewFile */llvm-project/* 
                    \ call functions#add_to_filetype_for(".llvmorg", "cpp")
        autocmd BufRead,BufNewFile */llvm-8.0-mono/*
                    \ call functions#add_to_filetype_for(".llvmorg", "cpp")
        autocmd BufRead,BufNewFile */llvm-4.0.0/* 
                    \ call functions#add_to_filetype_for(".llvm4", "cpp")
    augroup END
endif
