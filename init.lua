-- syntax on

vim.cmd("set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab")
vim.cmd("set clipboard+=unnamedplus")
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
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },
}
local opts = {}

-- Lazy
require("lazy").setup(plugins, opts)
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})

-- treesitter
local config = require("nvim-treesitter.configs")
config.setup({
  ensure_installed = {"lua", "r"},
  highlight = {enable = true},
  indent = {enable = true},
})

-- catpuccin
require("catppuccin").setup()
vim.cmd.colorscheme("catppuccin")

-- Neotree
vim.keymap.set('n', '<leader>n', ':Neotree filesystem reveal left<CR>', {})

-- Must be before creating other maps:
-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '


-- Set your global variables and options above this line --

