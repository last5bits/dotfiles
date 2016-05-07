set nocompatible " Vim is not Vi
set showtabline=1 " Show me your tab line
set tabstop=4 " One tabulation equals four spaces
set expandtab " No tabs, only spaces
set softtabstop=4 " Moving text blocks four spaces by < and > in visual
set shiftwidth=4 " Same thing with << and >>
set mousehide " Hiding mouse cursor while typing
set mouse=a " Mouse support is on
set smartindent " Smart autoindenting when starting a new line
set linebreak
set noswapfile
set scrolloff=3
set hidden " Modified buffers are hidden automatically
set hlsearch " Search higlights matched string
set t_Co=256 " Airline forced me to do it
set number " Line numbers, please
set foldmethod=indent " Let's try folding out
set foldlevelstart=1

colorscheme elflord

" Highlight a word without moving the cursor
nnoremap * :keepjumps normal! mi*`i<CR>

" File encoding menu {
nmap <leader>e :emenu Encoding.<TAB>
set wcm=<Tab>
menu Encoding.utf-8 :e ++enc=utf8 <CR>
menu Encoding.windows-1251 :e ++enc=cp1251<CR>
menu Encoding.koi8-r :e ++enc=koi8-r<CR>
menu Encoding.cp866 :e ++enc=cp866<CR>
" }

let g:startify_custom_header = [] " Disable cowsay for startify
let g:tex_flavor='latex' " TeX instead of PlainTeX
let delimitMate_expand_cr = 1
let g:livepreview_previewer = 'zathura'
let mapleader=' '

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename

" ack.vim: if you see silver_searcher -- use it ffs
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" Pathogen hacks
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Change your current directory to one you're working in
command! CD cd %:p:h
command! LCD lcd %:p:h

" Pretty JSON
command! PrettyJson %!python -m json.tool

" Opens help in the same buffer
command! -nargs=1 -complete=help H :enew | :set buftype=help | :h <args>

" Make the current file executable
nmap <leader>x :w<cr>:!chmod 755 %<cr>:e<cr>

" Elevate your privileges
cnoremap sudow w !sudo tee % >/dev/null

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
" Close the current window
noremap  <leader>wc :close<CR>
" Next buffer
nmap <leader>n :bnext<CR>
" Previous buffer
nmap <leader>p :bprev<CR>
" New empty buffer
nmap <leader>t :enew<CR>
" Close current buffer
nmap <leader>q :bp <BAR> bd #<CR>

" Move the current window to the right of the main Vim window
"noremap  <leader>ml L<CR>
" Move the current window to the top of the main Vim window
"noremap  <leader>mk K<CR>
" Move the current window to the left of the main Vim window
"noremap  <leader>mh H<CR>
" Move the current window to the bottom of the main Vim window
"noremap  <leader>mj J<CR>
" Next tab
"nmap <leader>n :tabn<CR>
" Previous tab
"nmap <leader>p :tabp<CR>
" New tab
"nmap <leader>t :tabnew<CR>

" Русская раскладка клавиатуры
  map ё `
  map й q
  map ц w
  map у e
  map к r
  map е t
  map н y
  map г u
  map ш i
  map щ o
  map з p
  map х [
  map ъ ]
  map ф a
  map ы s
  map в d
  map а f
  map п g
  map р h
  map о j
  map л k
  map д l
  map ж ;
  map э '
  map я z
  map ч x
  map с c
  map м v
  map и b
  map т n
  map ь m
  map б ,
  map ю .
  map Ё ~
  map Й Q
  map Ц W
  map У E
  map К R
  map Е T
  map Н Y
  map Г U
  map Ш I
  map Щ O
  map З P
  map Х {
  map Ъ }
  map Ф A
  map Ы S
  map В D
  map А F
  map П G
  map Р H
  map О J
  map Л K
  map Д L
  map Ж :
  map Э "
  map Я Z
  map Ч X
  map С C
  map М V
  map И B
  map Т N
  map Ь M
  map Б <
  map Ю >
  nmap пп gg
  nmap ЯЯ ZZ
