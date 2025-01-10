-- syntax on

vim.cmd("set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab")
vim.cmd("set clipboard+=unnamedplus")
vim.cmd("set colorcolumn=80")
vim.wo.relativenumber = true
vim.wo.number = true

vim.g.mapleader = " "

-- bootstrap lazy.nvim, LazyVim and your plugins
-- require("config.lazy")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "r", "python", "julia", "markdown", "rnoweb", "yaml" },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },
  -- R support
  {
    "R-nvim/R.nvim",
    config = function ()
      local opts = {
        R_args = {"--quiet", "--no-save"},
        hook = {
          after_config = function ()
            if vim.o.syntax ~= "rbrowser" then
              vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
              vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
            end
          end
        },
        min_editor_width = 72,
        rconsole_width = 78,
        disable_cmds = {
          "RClearConsole",
          "RCustomStart",
          "RSPlot",
          "RSaveClose",
        },
      }
      if vim.env.R_AUTO_START == "true" then
        opts.auto_start = 1
        opts.objbr_auto_start = true
      end
      require("r").setup(opts)
    end,
    lazy = false
  },
  "R-nvim/cmp-r",
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("cmp").setup({
        sources = {{ name = "cmp_r" }},
      })
      require("cmp_r").setup({})
    end,
  },
  -- Python and Julia support
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      -- Python
      lspconfig.pyright.setup({})
      -- Julia
      lspconfig.julials.setup({})
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = {
          { name = "nvim_lsp" },
        },
      })
    end,
  },
}

local opts = {}

-- Lazy
require("lazy").setup(plugins, opts)
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})

-- treesitter
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "r", "python", "julia", "markdown", "rnoweb", "yaml" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- catppuccin
require("catppuccin").setup()
vim.cmd.colorscheme("catppuccin")

-- Neotree
vim.keymap.set('n', '<leader>f', ':Neotree filesystem reveal left<CR>', {})

require("neo-tree").setup({
  event_handlers = {
    {
      event = "file_opened",
      handler = function(file_path)
        require("neo-tree.command").execute({ action = "close" })
      end
    },
  }
})

