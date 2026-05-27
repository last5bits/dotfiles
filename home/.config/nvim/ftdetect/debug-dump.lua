vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.debug',
  callback = function()
    vim.bo.filetype = 'debug-dump'
  end,
})
