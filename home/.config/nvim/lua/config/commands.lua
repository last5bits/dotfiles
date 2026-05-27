vim.api.nvim_create_user_command('W', function(opts)
  if opts.args == '' then
    return
  end
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd('windo ' .. opts.args)
  vim.api.nvim_set_current_win(cur_win)
end, { nargs = '?', desc = 'Just like windo, but restore the current window when done.' })

vim.api.nvim_create_user_command('L', 'Lazy', { desc = 'Alias for :Lazy' })
