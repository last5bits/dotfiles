return {
  {
    "wincent/ferret",
    config = function()
      vim.g["FerretAutojump"] = false
    end,
  },
  {
    "ibhagwan/fzf-lua",
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({
        "fzf-vim",
        winopts = {
          preview = {
            horizontal     = "right:50%",     -- right|left:size
            hidden = false,
          },
        },
      })
      vim.keymap.set("n", "<leader>t", fzf.files)
      vim.keymap.set("n", "<leader>b", fzf.buffers)
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
      vim.lsp.enable('clangd')
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
    "SirVer/ultisnips",
    config = function()
      vim.g["UltiSnipsExpandTrigger"] = '<tab>'
      vim.g["UltiSnipsEditSplit"] = 'vertical'
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    build = "make tiktoken",
    config = function(_, opts)
      require('fzf-lua').register_ui_select()
      vim.treesitter.language.register('markdown', 'copilot-chat')
      require('CopilotChat').setup(vim.tbl_extend('force', opts, {
        model = 'todo',
        providers = {
          copilot = { disabled = true },
          my_provider = {  
            get_url = function(opts) return "http://127.0.0.1:8080/v1/chat/completions" end,
            get_headers = function() return { ["Authorization"] = "Bearer no-key"} end,
            get_models = function(headers)
              local utils = require 'CopilotChat.utils'
              local response, err = utils.curl_get(
                'http://127.0.0.1:8080/v1/models',
                { headers = headers, json_response = true }
              )
              if err then error(err) end
              return vim.tbl_map(function(model) return { id = model.id, name = model.id } end, response.body.data)
            end,
            prepare_input = require('CopilotChat.config.providers').copilot.prepare_input,
            prepare_output = require('CopilotChat.config.providers').copilot.prepare_output,
          }  
        }  
     }))
     -- Normal: open CopilotChat
     vim.keymap.set('n', '<leader>i', '<cmd>CopilotChat<cr>', { noremap = true, silent = true })
     -- Visual: open CopilotChat and pass selected text as input
     vim.keymap.set('v', '<leader>i', function()
       -- yank selection into register z, then open CopilotChat with that text
       vim.cmd('norm! "zy')
       local sel = vim.fn.getreg('z')
       -- if your CopilotChat plugin exposes a function taking initial input:
       if pcall(require, 'copilot_chat') then
         local ok, cc = pcall(require, 'copilot_chat')
         if ok and type(cc.open) == 'function' then
           cc.open({ initial_prompt = sel })
           return
         end
       end
       -- fallback: open command and paste selection into prompt (works if CopilotChat reads from unnamed register)
       vim.fn.setreg('"', sel)
       vim.cmd('CopilotChat')
     end, { noremap = true, silent = true, desc = 'Open CopilotChat (use selection if any)' })
    end,
  },
}
