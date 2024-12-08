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
  "tpope/vim-fugitive",
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
      require('gitsigns').setup()
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
      vim.keymap.set("n", "<leader>f", ":call asyncrun#quickfix_toggle(0)<CR>", { silent = true })
    end,
  },
  {
    "igemnace/vim-makery",
    dependencies = { 'skywind3000/asyncrun.vim' },
    config = function()
      vim.api.nvim_create_user_command('Make', 'AsyncRun -program=make @ <args>', {})
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
}
