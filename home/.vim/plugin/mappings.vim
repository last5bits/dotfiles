" Highlight a word without moving the cursor
nnoremap * :keepjumps normal! mi*`i<CR>

nmap <leader>qf :call asyncrun#quickfix_toggle(8)<cr>

" Make the current file executable
nmap <leader>x :w<cr>:!chmod 755 %<cr>:e<cr>

" Repeat last macro if in a normal buffer.
nnoremap <expr> <CR> empty(&buftype) ? '@@' : '<CR>'

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
nmap <leader>q :bp <BAR> bd #<CR>
