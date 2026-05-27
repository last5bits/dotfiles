vim.keymap.set('n', '<leader>q', '<C-^>', { buffer = true, silent = true })
vim.keymap.set('n', '<C-l>', function()
  vim.cmd('noh')
end, { buffer = true, silent = true })
