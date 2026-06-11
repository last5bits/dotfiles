local M = {}

-- Build the tabline string showing only filenames for all tabs
function M.render()
  local line = ''

  -- Loop through each tab page
  for i = 1, vim.fn.tabpagenr('$') do
    -- Get the buffer list for this tab and find the active window
    local buflist = vim.fn.tabpagebuflist(i)
    local winnr = vim.fn.tabpagewinnr(i)
    local bufnr = buflist[winnr]

    -- Extract just the filename (no path) from the buffer name
    local name = vim.fn.bufname(bufnr)
    local fname = name ~= '' and vim.fn.fnamemodify(name, ':t') or '[No Name]'

    -- Handle special buffers where :t returns empty (e.g. fugitive status)
    if fname == '' then
      if name:match('^fugitive://') then
        fname = 'fugitive'
      else
        fname = '[No Name]'
      end
    end

    -- Apply different highlight groups for active vs inactive tabs
    if i == vim.fn.tabpagenr() then
      line = line .. '%#TabLineSel#'
    else
      line = line .. '%#TabLine#'
    end

    -- Add click target and filename with padding
    line = line .. '%' .. i .. 'T'
    line = line .. ' ' .. fname .. ' '
  end

  -- Fill remaining space with TabLineFill and end click targets
  line = line .. '%#TabLineFill#%T'
  return line
end

return M
