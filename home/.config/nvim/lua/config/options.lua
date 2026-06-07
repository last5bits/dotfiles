-- General editor settings
vim.opt.backspace = 'indent,eol,start'
vim.opt.complete:remove('i')
vim.opt.smarttab = true
vim.opt.nrformats:remove('octal')
vim.opt.formatoptions:append('j')
vim.opt.incsearch = true
vim.opt.laststatus = 2
vim.opt.ruler = true
vim.opt.wildmenu = true
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 2
vim.opt.display = 'lastline,truncate'
vim.opt.listchars = { tab = '> ', trail = '-', extends = '>', precedes = '<', nbsp = '+' }
vim.opt.autoread = true
vim.opt.history = 1000
vim.opt.tabpagemax = 50
vim.opt.sessionoptions:remove('options')
vim.opt.viewoptions:remove('options')
vim.opt.langremap = false
vim.g.is_posix = 1

vim.opt.showtabline = 1
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.mousehide = true
vim.opt.mouse = 'a'
vim.opt.swapfile = false
vim.opt.scrolloff = 3
vim.opt.hlsearch = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.wrapscan = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true
vim.opt.updatetime = 250
vim.opt.shortmess:append({ S = true })
vim.opt.autowrite = true
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true

-- Diff display settings
vim.opt.diffopt:append('linematch:60') -- smarter intra-line diffing (Neovim 0.9+)
vim.opt.diffopt:append('algorithm:histogram')

-- Diagnostics
vim.diagnostic.config({ virtual_text = true })

-- Colorscheme
vim.cmd('colorscheme slate')

-- LSP document highlight colours
vim.api.nvim_set_hl(0, 'LspReferenceRead', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'LspReferenceText', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { link = 'Visual' })

-- Backup configuration
vim.opt.backup = true
vim.opt.backupdir = vim.fn.expand('$HOME/.local/share/nvim/backup/')
-- Append timestamp to backup extensions
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('timestamp_backupext', { clear = true }),
  desc = 'Add timestamp to backup extension',
  pattern = '*',
  callback = function()
    vim.opt.backupext = '-' .. vim.fn.strftime('%Y%m%d%H%M')
  end,
})

-- Autocmds group
local augroup = vim.api.nvim_create_augroup('autocmds', { clear = true })

-- netrw filetype keymap
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  group = augroup,
  desc = 'Refresh the file system listing',
  callback = function()
    vim.keymap.set('n', '<C-r>', '<Plug>NetrwRefresh', {
      noremap = true,
      buffer = true,
      silent = true,
    })
  end,
})

-- Poor man's vim-rooter (git only) using fugitive
-- last_cwd stores the per-buffer working directory so it can be restored when
-- switching back to that buffer, rather than always resetting to git root.
local rooter_group = vim.api.nvim_create_augroup('vim_rooter', { clear = true })
vim.api.nvim_create_autocmd('BufLeave', {
  group = rooter_group,
  callback = function()
    vim.b.last_cwd = vim.fn.getcwd()
  end,
})
vim.api.nvim_create_autocmd('BufEnter', {
  group = rooter_group,
  callback = function()
    if vim.b.last_cwd then
      vim.cmd('lcd ' .. vim.b.last_cwd)
    else
      pcall(vim.cmd, 'Glcd')
    end
  end,
})
