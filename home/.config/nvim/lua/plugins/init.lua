return {
  {
    'wincent/ferret',
    config = function()
      vim.g.FerretAutojump = false
    end,
  },
  {
    'ibhagwan/fzf-lua',
    config = function()
      local fzf = require('fzf-lua')
      fzf.setup({
        'fzf-vim',
        winopts = {
          preview = {
            horizontal = 'right:50%', -- right|left:size
            hidden = false,
          },
        },
      })
      vim.keymap.set('n', '<leader>t', fzf.files)
      vim.keymap.set('n', '<leader>b', fzf.buffers)
    end,
  },
  'tpope/vim-eunuch',
  {
    'tpope/vim-fugitive',
    config = function()
      local augroup = vim.api.nvim_create_augroup('fugitive_autocmds', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'netrw',
        group = augroup,
        desc = 'Open the project root',
        callback = function()
          vim.keymap.set('n', 'g~', ':Gedit :/<CR>', { noremap = true, buffer = true })
        end,
      })
    end,
  },
  'tpope/vim-rsi',
  'tpope/vim-sleuth',
  'tpope/vim-vinegar',
  'tpope/vim-unimpaired',
  {
    'neovim/nvim-lspconfig',
    config = function()
      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature help' })
        vim.keymap.set('n', 'cx', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'cr', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>lc', vim.lsp.buf.incoming_calls, { buffer = bufnr, desc = 'Incoming calls' })
        vim.keymap.set('n', '<leader>lo', vim.lsp.buf.outgoing_calls, { buffer = bufnr, desc = 'Outgoing calls' })

        vim.api.nvim_create_autocmd('CursorHold', {
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd('CursorMoved', {
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        })
      end

      vim.lsp.config('pyright', {
        on_attach = on_attach,
        root_markers = { 'pyrightconfig.json' },
      })
      vim.lsp.enable('pyright')

      vim.lsp.config('clangd', {
        on_attach = on_attach,
      })
      vim.lsp.enable('clangd')
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        on_attach = function(bufnr)
          local gitsigns = require('gitsigns')

          -- Navigation
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal({ ']c', bang = true })
            else
              gitsigns.nav_hunk('next')
            end
          end, { buffer = bufnr })

          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({ '[c', bang = true })
            else
              gitsigns.nav_hunk('prev')
            end
          end, { buffer = bufnr })
        end,
      })
    end,
  },
  {
    'azabiong/vim-highlighter',
    init = function()
      -- settings
    end,
  },
  {
    'skywind3000/asyncrun.vim',
    config = function()
      local augroup = vim.api.nvim_create_augroup('asyncrun_autocmds', { clear = true })
      vim.keymap.set('n', '<leader>f', ':call asyncrun#quickfix_toggle(0)<CR>', { silent = true })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'AsyncRunStart',
        group = augroup,
        desc = 'Bring up the quickfix window on each AsyncRun command invocation',
        command = 'call asyncrun#quickfix_toggle(0, 1)',
      })
    end,
  },
  {
    'igemnace/vim-makery',
    dependencies = { 'skywind3000/asyncrun.vim' },
    config = function()
      vim.api.nvim_create_user_command(
        'Make',
        'AsyncRun -program=make @ <args>',
        { bang = true, nargs = '*', complete = 'file' }
      )
    end,
  },
  {
    'preservim/nerdcommenter',
    dependencies = { 'rhysd/vim-llvm' },
    config = function()
      vim.g['NERDSpaceDelims'] = true
      vim.g['NERDDefaultAlign'] = 'both'
      vim.g['NERDCustomDelimeters'] = {
        mlir = { left = '// ' },
        tablegen = { left = '// ' },
      }
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  {
    'rhysd/vim-llvm',
    init = function()
      vim.g['llvm_extends_official'] = false
    end,
  },
  {
    'AndrewRadev/linediff.vim',
    config = function()
      vim.api.nvim_create_user_command('Ld', 'Linediff', { desc = 'An alias for :Linediff.' })
    end,
  },
  {
    'roszcz/Vim-Star-Search',
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    opts = {
      keymap = {
        preset = 'default',
        ['<C-n>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
  },
  {
    'stevearc/conform.nvim',
    config = function()
      local conform = require('conform')
      conform.setup({
        formatters_by_ft = {
          c = { 'clang_format' },
          cpp = { 'clang_format' },
          python = { 'ruff_format' },
          lua = { 'stylua' },
          markdown = { 'rumdl' },
        },
      })
      vim.keymap.set({ 'n', 'v' }, '<leader>gq', function()
        conform.format({ async = true })
      end)
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local ok, configs = pcall(require, 'nvim-treesitter.configs')
      if ok then
        configs.setup({
          highlight = { enable = true },
          indent = { enable = true },
        })
      end
    end,
  },
}
