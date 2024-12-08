local utils = {}

function utils.set_plain_text()
  vim.opt_local.spell = true
  vim.opt_local.spelllang = 'en_ca'
  vim.opt_local.complete:append('kspell')
  vim.opt_local.textwidth = 0
  vim.opt_local.wrap = true
  vim.opt_local.wrapmargin = 0
  vim.keymap.set('n', 'j', 'gj', { noremap = true, buffer = true, })
  vim.keymap.set('n', 'k', 'gk', { noremap = true, buffer = true, })
end

function utils.set_llvm()
  vim.opt_local.iskeyword:append('.%-')
end

function utils.get_clang_format_path()
  return '/usr/share/clang/clang-format.py'
end

function utils.map_clang_format()
  local clang_format_path = require('config.utils').get_clang_format_path()
  vim.cmd('map <silent> <buffer> gq :py3f ' .. clang_format_path .. '<CR>')
end

return utils
