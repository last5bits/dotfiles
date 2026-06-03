vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.keymap.set('n', '<leader>q', ':bp <BAR> bwipeout #<CR>', { silent = true })
vim.keymap.set('n', '<leader>o', ':W diffoff<CR>:setl nocursorbind<CR>:only<CR>', { silent = true })
vim.keymap.set(
  'n',
  '<C-l>',
  ':nohlsearch<Bar>diffupdate<CR><C-l>',
  { silent = true, desc = 'Clear search highlight, update diff, redraw' }
)
vim.keymap.set('i', '<C-u>', '<C-g>u<C-u>', { desc = 'Delete to start of line (break undo)' })
vim.keymap.set('i', '<C-w>', '<C-g>u<C-w>', { desc = 'Delete word (break undo)' })
