-- Custom non-jumping * and # with fugitive patch-search support.

local M = {}

-- Escape text for a literal search pattern.
local function escape_pattern(text)
  return '\\V' .. vim.fn.escape(text, '\\'):gsub('\n', '\\n'):gsub('\r', '\\r')
end

-- Get the current visual selection without touching registers.
-- Works in nomodifiable buffers (unlike normal! gv"sy).
local function get_visual_text()
  local start_pos = vim.fn.getpos('v')
  local end_pos = vim.fn.getpos('.')
  local mode = vim.fn.mode()

  -- Exit visual mode so '< and '> are updated.
  vim.cmd('noautocmd normal! <Esc>')

  local ok, region = pcall(vim.fn.getregion, start_pos, end_pos, { type = mode })
  if ok and region then
    local text = table.concat(region, '\n')
    if mode == 'V' then
      text = text .. '\n'
    end
    return text
  end

  -- Fallback for older Neovim versions.
  local s_line, s_col = vim.fn.line("'<"), vim.fn.col("'<")
  local e_line, e_col = vim.fn.line("'>"), vim.fn.col("'>")

  if mode == 'V' then
    local lines = vim.api.nvim_buf_get_lines(0, s_line - 1, e_line, false)
    return table.concat(lines, '\n') .. '\n'
  end

  if s_line == e_line then
    local line = vim.api.nvim_buf_get_lines(0, s_line - 1, s_line, false)[1] or ''
    return line:sub(s_col, e_col)
  end

  local lines = {}
  local first = vim.api.nvim_buf_get_lines(0, s_line - 1, s_line, false)[1] or ''
  table.insert(lines, first:sub(s_col))

  for l = s_line + 1, e_line - 1 do
    table.insert(lines, vim.api.nvim_buf_get_lines(0, l - 1, l, false)[1] or '')
  end

  local last = vim.api.nvim_buf_get_lines(0, e_line - 1, e_line, false)[1] or ''
  table.insert(lines, last:sub(1, e_col))

  return table.concat(lines, '\n')
end

-- Search for the word under the cursor (forward or backward).
function M.search_cword(direction)
  local word = vim.fn.expand('<cword>')
  if #word == 0 then
    vim.notify('E348: No string under cursor', vim.log.levels.ERROR)
    return
  end

  local first = word:sub(1, 1)
  local pattern
  if vim.fn.match(first, '\\k') >= 0 then
    pattern = '\\<' .. vim.fn.escape(word, '\\') .. '\\>'
  else
    pattern = vim.fn.escape(word, '\\')
  end

  vim.fn.setreg('/', pattern)
  vim.v.searchforward = direction == 1 and 1 or 0
  vim.opt.hlsearch = true
end

-- Search for the current visual selection (forward or backward).
function M.search_visual(direction)
  local text = get_visual_text()
  if #text == 0 then
    vim.notify('starsearch: No selected string', vim.log.levels.ERROR)
    return
  end

  vim.fn.setreg('/', escape_pattern(text))
  vim.v.searchforward = direction == 1 and 1 or 0
  vim.opt.hlsearch = true
end

-- Fugitive patch search: jump between matching + / - lines.
local function fugitive_patch_search(direction)
  local line = vim.fn.getline('.')
  local pattern

  if line:match('^[+-]... ') then
    local name = vim.fn.escape(vim.fn.strpart(line, 4), '^$.*[]~\\')
    name = vim.fn.substitute(name, '^\\w/', '\\w/', '')
    pattern = '^[+-]... ' .. name .. '$'
  else
    local text = vim.fn.substitute(vim.fn.strpart(line, 1), '^\\s*\\|\\s*$', '', '')
    pattern = '^[+-]\\s*' .. vim.fn.escape(text, '^$.*[]~\\') .. '\\s*$'
  end

  local cmd = direction == 1 and '/' or '?'
  vim.fn.feedkeys(cmd .. vim.fn.escape(pattern, '/?') .. '\n', 'n')
end

-- Check if the cursor is on a fugitive diff line where patch search applies.
local function is_fugitive_patch_line()
  local ft_type = vim.fn.getbufvar(vim.fn.bufnr(), 'fugitive_type', '')
  if ft_type == '' or ft_type == 'blob' or vim.bo.modifiable then
    return false
  end
  return vim.fn.col('.') == 1 and vim.fn.getline('.'):match('^[+-]')
end

-- Normal mode * (forward)
function M.star_forward()
  if is_fugitive_patch_line() then
    fugitive_patch_search(1)
  else
    M.search_cword(1)
  end
end

-- Normal mode # (backward)
function M.star_backward()
  if is_fugitive_patch_line() then
    fugitive_patch_search(0)
  else
    M.search_cword(0)
  end
end

-- Keymaps (global)
vim.keymap.set('n', '*', M.star_forward, { silent = true, desc = 'Search word under cursor (forward)' })
vim.keymap.set('n', '#', M.star_backward, { silent = true, desc = 'Search word under cursor (backward)' })
vim.keymap.set('x', '*', function()
  M.search_visual(1)
end, { silent = true, desc = 'Search visual selection (forward)' })
vim.keymap.set('x', '#', function()
  M.search_visual(0)
end, { silent = true, desc = 'Search visual selection (backward)' })

-- Buffer-local override for vim-fugitive.
-- fugitive sets buffer-local * / # in non-modifiable buffers via MapJumps().
-- BufEnter fires after fugitive has finished, so our buffer-local maps win.
local augroup = vim.api.nvim_create_augroup('starsearch_fugitive', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = augroup,
  pattern = '*',
  callback = function()
    if vim.bo.modifiable then
      return
    end
    local ft_type = vim.fn.getbufvar(vim.fn.bufnr(), 'fugitive_type', '')
    if ft_type ~= '' and ft_type ~= 'blob' then
      vim.keymap.set('n', '*', M.star_forward, { buffer = true, silent = true })
      vim.keymap.set('n', '#', M.star_backward, { buffer = true, silent = true })
    end
  end,
})

return M
