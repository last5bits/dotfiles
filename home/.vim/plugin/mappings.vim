" Highlight a word without moving the cursor
nnoremap * :keepjumps normal! mi*`i<CR>

" Toggle the asyncrun quickfix window
nmap <leader>f :call asyncrun#quickfix_toggle(8)<cr>

" Grepper mappings
nnoremap <leader>ga :Grepper <cr>
nnoremap <leader>gs :Grepper -side<cr>
nnoremap <leader>*  :Grepper -cword -noprompt<cr>

" Make the current file executable
nmap <leader>x :w<cr>:!chmod 755 %<cr>:e<cr>

" Repeat last macro if in a normal buffer.
nnoremap <expr> <CR> empty(&buftype) ? '@@' : '<CR>'

" Toggle whether autocmd events should be ignored
nnoremap <leader>e :call functions#toggle_eventignore()<CR>

" Walking around your windows
" Move the cursor to the window left of the current one
noremap  <leader>h :wincmd h<CR>
" Move the cursor to the window below the current one
noremap  <leader>j :wincmd j<CR>
" Move the cursor to the window above the current one
noremap  <leader>k :wincmd k<CR>
" Move the cursor to the window right of the current one
noremap  <leader>l :wincmd l<CR>
" Close the window below this one
noremap  <leader>cj :wincmd j<CR>:close<CR>
" Close the window above this one
noremap  <leader>ck :wincmd k<CR>:close<CR>
" Close the window to the left of this one
noremap  <leader>ch :wincmd h<CR>:close<CR>
" Close the window to the right of this one
noremap  <leader>cl :wincmd l<CR>:close<CR>
" Next buffer
nmap <leader>n :bnext<CR>
" Previous buffer
nmap <leader>p :bprev<CR>
" New empty buffer
nmap <leader>t :enew<CR>
" Close current buffer
nmap <leader>q :bp <BAR> bwipeout #<CR>
" Close all windows except the current one
noremap <leader>o :windo diffoff<CR>:only<CR>

" Switch to the file and load it into the current window
nmap <silent> <Leader>a :FSHere<cr>

" Open the tag bar
nmap <F8> :TagbarToggle<CR>

" Open the fuzzy searcher through current bufs
nmap <leader>b :CtrlPBuffer<cr>

" Mappings for vim-mark.
nmap <leader>Mt <Plug>MarkToggle
" Supress startup warnings.
nmap <leader>Mn <Plug>MarkSearchNext
nmap <leader>Mc <Plug>MarkClear
nmap <leader>Mcn <Plug>MarkSearchCurrentNext
