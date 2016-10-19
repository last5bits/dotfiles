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
set hidden " Modified buffers are hidden automatically
set hlsearch " Search higlights matched string
set t_Co=256 " Airline forced me to do it
set number " Line numbers, please
set lazyredraw " Don't bother updating screen during macro playback

if has('folding')
  set foldmethod=indent    " not as cool as syntax, but faster
  set foldlevelstart=99    " start unfolded
endif

if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j    " remove comment leader when joining comment lines
endif

if has('linebreak')
    set linebreak   " wrap long lines at characters in 'breakat'
    set breakindent   " indent wrapped lines to match start
    if exists('&breakindentopt')
        set breakindentopt=shift:4  " emphasize broken lines by indenting them
    endif
    " ARROW POINTING DOWNWARDS THEN CURVING RIGHTWARDS (U+2937, UTF-8: E2 A4 B7)
    let &showbreak='⤷ '
endif

" Mouse in tmux
if &term =~ '^screen'
    set ttymouse=xterm2
endif

" File encryption
if v:version >= 704 && has('patch399')
    set cm=blowfish2 " Stronger
endif
autocmd BufReadPost * if &key != "" | set noswapfile nowritebackup noundofile viminfo= nobackup noshelltemp history=0 secure | endif

if has('virtualedit')
    set virtualedit=block
endif

let g:netrw_banner = 0 " Disable header in netrw
