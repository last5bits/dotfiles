set nocompatible " Vim is on Vi
syntax on
set showtabline=1 " Show me your tab line
set tabstop=4 " One tabulation equals four spaces
set expandtab " No tabs, only spaces
set softtabstop=4 " Moving text blocks four spaces by < and > in visual
set shiftwidth=4 " Same thing with << and >>
set backspace=2 " Backspace is no use without this
set number " Line numeration
set mousehide " Hiding mouse cursor while typing
set mouse=a " Mouse support is on
set smartindent " Smart autoindenting when starting a new line
set linebreak
set noswapfile
set encoding=utf-8 " Default file encoding
set scrolloff=3
set hidden " Modified buffers are hidden automatically
set incsearch " Incremental search
set hlsearch " Search higlights matched string
set t_Co=256

let g:tex_flavor='latex' " TeX вместо PlainTeX
let mapleader=','

filetype plugin on
filetype indent on

" Pathogen hacks
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Change your current directory to one you're working in
command! CD cd %:p:h
command! LCD lcd %:p:h
" Pretty JSON
command! PrettyJson %!python -m json.tool

" Make the current file executable
nmap ,x :w<cr>:!chmod 755 %<cr>:e<cr>

" Insert new line
nnoremap <C-J> a<CR><Esc>k$

" This one doesn't work, whatever
vmap <C-C> "+y
imap <C-V> <C-o>"+p

" Make < and > shifts keep selection
vnoremap < <gv
vnoremap > >gv

"" Status line
"fun! <SID>SetStatusLine()
    "let l:s1="%-3.3n\\ %f\\ %h%m%r%w"
    "let l:s2="[%{strlen(&filetype)?&filetype:'?'},%{&encoding},%{&fileformat}]"
    "let l:s3="%=\\ 0x%-8B\\ \\ %-14.(%l,%c%V%)\\ %<%P"
    "execute "set statusline=" . l:s1 . l:s2 . l:s3
"endfun
"set laststatus=2
"call <SID>SetStatusLine()
set laststatus=2
let g:airline_powerline_fonts = 1

nmap <F2> :w<CR>
" Changing encoding menu {
set wildmenu
set wcm=<Tab>
menu Encoding.utf-8 :e ++enc=utf8 <CR>
menu Encoding.windows-1251 :e ++enc=cp1251<CR>
menu Encoding.koi8-r :e ++enc=koi8-r<CR>
menu Encoding.cp866 :e ++enc=cp866<CR>
" }
map <F3> :emenu Encoding.<TAB>
nmap <F10> :qa<CR>
imap <F10> <ESC>:qa<CR>
vmap <F10> <ESC><ESC>:qa<CR>

imap <C-b> <left>
imap <C-f> <right>

" Disable arrow keys
"map <up> <nop>
"map <down> <nop>
"map <left> <nop>
"map <right> <nop>
"imap <up> <nop>
"imap <down> <nop>
"imap <left> <nop>
"imap <right> <nop> 

" Walking around your windows
" Move the cursor to the window left of the current one
noremap  ,h :wincmd h<CR>
" Move the cursor to the window below the current one
noremap  ,j :wincmd j<CR>
" Move the cursor to the window above the current one
noremap  ,k :wincmd k<CR>
" Move the cursor to the window right of the current one
noremap  ,l :wincmd l<CR>
" Close the window below this one
noremap  ,cj :wincmd j<CR>:close<CR>
" Close the window above this one
noremap  ,ck :wincmd k<CR>:close<CR>
" Close the window to the left of this one
noremap  ,ch :wincmd h<CR>:close<CR>
" Close the window to the right of this one
noremap  ,cl :wincmd l<CR>:close<CR>
" Close the current window
noremap  ,wc :close<CR>
" Move the current window to the right of the main Vim window
"noremap  ,ml L<CR>
" Move the current window to the top of the main Vim window
"noremap  ,mk K<CR>
" Move the current window to the left of the main Vim window
"noremap  ,mh H<CR>
" Move the current window to the bottom of the main Vim window
"noremap  ,mj J<CR>
" Next tab
nmap ,n :tabn<CR>
" Previous tab
nmap ,p :tabp<CR>
" New tab
nmap ,t :tabnew<CR>

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
