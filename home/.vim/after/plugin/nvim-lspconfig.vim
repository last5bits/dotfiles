if !has('nvim')
  finish
endif

lua << END
  require'lspconfig'.clangd.setup{}
END

function! s:ConfigureBuffer()
    nnoremap <buffer> <silent> <leader><CR> <cmd>lua vim.lsp.buf.code_action()<CR>
    nnoremap <buffer> <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <buffer> <silent> <leader>g :ClangdSwitchSourceHeader<CR>
endfunction

if has('autocmd')
    autocmd FileType cpp call s:ConfigureBuffer()
endif
