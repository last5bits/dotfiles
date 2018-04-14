set showtabline=1 " Show me your tab line
set tabstop=4 " One tabulation equals four spaces
set expandtab " No tabs, only spaces
set softtabstop=4 " Moving text blocks four spaces by < and > in visual
set shiftwidth=4 " Same thing with << and >>
set mousehide " Hiding mouse cursor while typing
set mouse=a " Mouse support is on
set smartindent " Smart autoindenting when starting a new line
set noswapfile " Avoid creating a swapfile
set scrolloff=3 " Number of lines to keep above and below the cursor
set hlsearch " Search higlights matched string
set t_Co=256 " 256 colors
set number " Line numbers, please
set lazyredraw " Don't bother updating screen during macro playback
set cursorline " highlight current line
set nowrapscan " Do not continue the search from the top again
set autoread " Update an open buffer if it has been changed externally
set ignorecase
set infercase " This and the above for convenient search and completion

if has('folding')
  if has('windows')
    set fillchars+=fold:·             " MIDDLE DOT (U+00B7, UTF-8: C2 B7)
  endif
  set foldmethod=indent               " not as cool as syntax, but faster
  set foldlevelstart=99               " start unfolded
  set foldtext=functions#foldtext()
endif

if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j    " remove comment leader when joining comment lines
endif
let g:NERDSpaceDelims = 1  " Insert spaces when commenting

if has('linebreak')
    set linebreak   " wrap long lines at characters in 'breakat'

    try
        set breakindent   " indent wrapped lines to match start
      catch /E518:/
        " Unknown option: breakindent
    endtry

    if exists('&breakindentopt')
        set breakindentopt=shift:4  " emphasize broken lines by indenting them
    endif

    " ARROW POINTING DOWNWARDS THEN CURVING RIGHTWARDS (U+2937, UTF-8: E2 A4 B7)
    "let &showbreak='⤷ '

    " RIGHTWARDS ARROW WITH HOOK (U+21aa, 8618)
    " let &showbreak='↪ '

    " DOWNWARDS ARROW 8595 0x2193
    " let &showbreak='↓ '

    " SOUTH EAST ARROW 8600 0x2198
     let &showbreak='↘ '
endif

" Mouse in tmux
if &term =~ '^screen'
    set ttymouse=xterm2
endif

" File encryption
if !has('nvim')
    if (v:version >= 704 && has('patch399')) || v:version >=800
        set cm=blowfish2 " Stronger
    endif
    autocmd BufReadPost * if &key != "" | set noswapfile nowritebackup noundofile viminfo= nobackup noshelltemp history=0 secure | endif
endif

if has('virtualedit')
    set virtualedit=block
endif

let g:netrw_banner = 0 " Disable header in netrw

" Only allow errors reported by syntastic
let g:syntastic_quiet_messages = {
    \ "!level":  "errors"
    \ }

" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    "Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

" python-mode settings
let g:pymode_rope_complete_on_dot = 0
let g:pymode_lint_cwindow = 0
" Auto-hide preview window on completion
set completeopt=menu

" UltiSnips settings
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

" Gutentags settings
let g:gutentags_project_root = [".vimrc-local"]
let g:gutentags_ctags_tagfile = ".tags"

" FSwitch settings
au! BufEnter *.cpp,*.cc,*.c let b:fswitchdst = 'h,hpp'    | let b:fswitchlocs = 'reg:/src/include/,../include,./'
au! BufEnter *.h,*.hpp      let b:fswitchdst = 'cpp,cc,c' | let b:fswitchlocs = 'reg:/include/src/,../src,./'

" CtrlP settings
let g:ctrlp_extensions = ['tag']

" Grepper settings
let g:grepper           = {}
let g:grepper.next_tool = '<tab>'

" Airline settings
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename
let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])

" Latex
let g:tex_flavor='latex' " TeX instead of PlainTeX
let g:livepreview_previewer = 'zathura' " Default PDF viewer for latex

let delimitMate_expand_cr = 1 " Turn on the expansion of <CR>
