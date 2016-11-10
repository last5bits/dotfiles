set nocompatible

let mapleader=' '

colorscheme elflady
" Use another scheme in vimdiff
if &diff
    colorscheme blue
endif

" Syntastic
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
nmap <leader>s :SyntasticCheck<CR>

" File encoding menu
nmap <leader>e :emenu Encoding.<TAB>
set wcm=<Tab>
menu Encoding.utf-8 :e ++enc=utf8 <CR>
menu Encoding.windows-1251 :e ++enc=cp1251<CR>
menu Encoding.koi8-r :e ++enc=koi8-r<CR>
menu Encoding.cp866 :e ++enc=cp866<CR>

let g:startify_custom_header = [] " Disable cowsay for startify

let g:tex_flavor='latex' " TeX instead of PlainTeX

let delimitMate_expand_cr = 1 " Turn on the expansion of <CR>

let g:livepreview_previewer = 'zathura' " Default PDF viewer for latex

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
