vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.keymap.set('n', '<leader>q', ':bp <BAR> bwipeout #<CR>', { silent = true })
vim.keymap.set('n', '<leader>o', ':W diffoff<CR>:setl nocursorbind<CR>:only<CR>', { silent = true })
