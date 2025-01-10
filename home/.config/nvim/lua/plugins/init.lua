return {
  {
    "wincent/ferret",
    config = function()
      vim.g["FerretAutojump"] = false
    end,
  },
  {
    "junegunn/fzf",
  },
  {
    "junegunn/fzf.vim",
    dependencies = { 'junegunn/fzf' },
    config = function()
      vim.keymap.set('n', '<leader>t', ':Files<CR>', { desc = 'fzf find files' })
      vim.keymap.set('n', '<leader>b', ':Buffers<CR>', { desc = 'fzf find buffers' })
    end,
  },
  "tpope/vim-eunuch",
  {
    "tpope/vim-fugitive",
    config = function()
      local augroup = vim.api.nvim_create_augroup('fugitive_autocmds', {clear = true})
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'netrw',
        group = augroup,
        desc = 'Open the project root',
        callback = function()
          vim.keymap.set("n", 'g~', ':Gedit :/<CR>',
            { noremap = true, buffer = true })
        end
      })
    end,
  },
  "tpope/vim-rsi",
  "tpope/vim-sensible",
  "tpope/vim-sleuth",
  "tpope/vim-vinegar",
  "tpope/vim-unimpaired",
  {
    "neovim/nvim-lspconfig",
    config = function()
      require'lspconfig'.clangd.setup{}
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { noremap = true, buffer = true, silent = true })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, buffer = true, silent = true })
      vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, { noremap = true, buffer = true, silent = true })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true, buffer = true, silent = true })
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { noremap = true, buffer = true, silent = true })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, buffer = true, silent = true })
      vim.keymap.set('n', '<leader>g', ':ClangdSwitchSourceHeader<CR>', { noremap = true, buffer = true, silent = true })
      vim.keymap.set('n', 'cx', vim.lsp.buf.code_action, { noremap = true, buffer = true, silent = true })
      vim.keymap.set('n', 'cr', vim.lsp.buf.rename, { noremap = true, buffer = true, silent = true })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup{
        on_attach = function(bufnr)
          local gitsigns = require('gitsigns')

          -- Navigation
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal({']c', bang = true})
            else
              gitsigns.nav_hunk('next')
            end
          end)

          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({'[c', bang = true})
            else
              gitsigns.nav_hunk('prev')
            end
          end)
        end
      }
    end,
  },
  {
    "azabiong/vim-highlighter",
    init = function()
      -- settings
    end,
  },
  {
    "skywind3000/asyncrun.vim",
    config = function()
      local augroup = vim.api.nvim_create_augroup('asyncrun_autocmds', {clear = true})
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
    "igemnace/vim-makery",
    dependencies = { 'skywind3000/asyncrun.vim' },
    config = function()
      vim.api.nvim_create_user_command('Make', 'AsyncRun -program=make @ <args>',
        { bang = true, nargs = '*', complete = 'file' })
    end,
  },
  {
    "preservim/nerdcommenter",
    dependencies = { 'rhysd/vim-llvm' },
    config = function()
      vim.g["NERDSpaceDelims"] = true
      vim.g["NERDDefaultAlign"] = "both"
      vim.g["NERDCustomDelimeters"] = {
        mlir = { left = '// ' },
        tablegen = { left = '// ' },
      }
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  {
    "rhysd/vim-llvm",
    init = function()
      vim.g["llvm_extends_official"] = false
    end,
  },
  {
    "AndrewRadev/linediff.vim",
    config = function()
      vim.api.nvim_create_user_command( 'Ld', 'Linediff',
        {desc = 'An alias for :Linediff.'})
    end,
  },
  {
    "roszcz/Vim-Star-Search",
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require'cmp'
      require('config.snippets').register_cmp_source()
      
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-CR>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
        }, {
          { name = 'buffer' },
        }, {
          { name = 'snp' },
        })
      })
    end,
  },
}
