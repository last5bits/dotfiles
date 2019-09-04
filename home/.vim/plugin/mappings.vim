" Toggle the asyncrun quickfix window
nmap <leader>f :call asyncrun#quickfix_toggle(8)<cr>

" Make the current file executable
nmap <leader>x :w<cr>:!chmod 755 %<cr>:e<cr>

" Repeat last macro if in a normal buffer.
nnoremap <expr> <CR> empty(&buftype) ? '@@' : '<CR>'

" Toggle whether autocmd events should be ignored
nnoremap <leader>e :call functions#toggle_eventignore()<CR>

" Close current buffer
nmap <leader>q :bp <BAR> bwipeout #<CR>
" Close all windows except the current one
noremap <silent><leader>o :W diffoff<CR>:syntax on<CR>:setl nocursorbind<CR>:only<CR>

" Switch to the file and load it into the current window
nmap <silent> <Leader>a :FSHere<cr>

" Tagbar.
nmap <leader>t :TagbarToggle<CR>
nmap <silent><leader>T :TagbarCurrentTag<CR>

" ctag
nnoremap g} :vsp<CR>:exec("tag ".expand("<cword>"))<CR>

" Open the fuzzy searcher through current bufs
nmap <leader>b :CtrlPBuffer<cr>

" Mappings for vim-mark.
nmap <leader>Mt <Plug>MarkToggle
" Supress startup warnings.
nmap <leader>Mn <Plug>MarkSearchNext
nmap <leader>Mc <Plug>MarkClear
nmap <leader>Mr <Plug>MarkRegex

" Search for visually selected text.
vnoremap * y/<C-R>"<CR>
