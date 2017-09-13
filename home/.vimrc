set nocompatible

let mapleader=' '

colorscheme elflady
" Use another scheme in vimdiff
if &diff
    colorscheme blue
endif

" Change the colorscheme in Gdiff
au FilterWritePre * if &diff | colorscheme blue | endif
noremap <leader>o :only<CR>:colorscheme elflady<CR>:redraw!<CR>

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

let g:tex_flavor='latex' " TeX instead of PlainTeX

let delimitMate_expand_cr = 1 " Turn on the expansion of <CR>

let g:livepreview_previewer = 'zathura' " Default PDF viewer for latex

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename

" Grepper settings
let g:grepper           = {}
let g:grepper.next_tool = '<tab>'

" Pathogen hacks
let g:pathogen_disabled = []
if v:version < '704'
    call add(g:pathogen_disabled, 'vim-gutentags')
    call add(g:pathogen_disabled, 'ultisnips')
endif
if !has('nvim')
    call add(g:pathogen_disabled, 'nvim-completion-manager')
    call add(g:pathogen_disabled, 'clang_complete')
endif
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
Helptags

" asyncrun + airline
let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
