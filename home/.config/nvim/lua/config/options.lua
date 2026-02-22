-- General editor settings
vim.opt.showtabline = 1
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.mousehide = true
vim.opt.mouse = 'a'
vim.opt.swapfile = false
vim.opt.scrolloff = 3
vim.opt.hlsearch = true
vim.opt.number = true
vim.opt.lazyredraw = true
vim.opt.cursorline = true
vim.opt.wrapscan = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true
vim.opt.updatetime = 9
vim.opt.shortmess:append({ S = true })
vim.opt.autowrite = true
vim.opt.signcolumn = 'yes'

-- Diagnostics
vim.diagnostic.config({ virtual_text = true })

-- Colorscheme
vim.cmd('colorscheme slate')

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
vim.cmd([[augroup misc
  autocmd BufLeave * let b:last_cwd = getcwd()
  autocmd BufEnter * if exists('b:last_cwd')
                  \|   execute 'lcd' b:last_cwd
                  \| else
                  \|   silent! Glcd
                  \| endif
augroup END]])
