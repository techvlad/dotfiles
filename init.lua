-- "super" key for vim
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- disable netrw (replaced by plugin)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true
vim.opt.showmatch = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.showmode = false          -- disable -- INSERT -- label
vim.opt.incsearch = true          -- show matches while typing search pattern
vim.opt.magic = true              -- enable RegExp in search pattern
vim.opt.wildmenu = true           -- show commands completion in bottom menu
vim.opt.undofile = true           -- save undo history
vim.opt.signcolumn = "yes"        -- keep signcolumn on by default
vim.opt.inccommand = "split"      -- preview substitutions live, as you type
vim.opt.hlsearch = true

-- basic mapping
-- navigation between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window", silent = true })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window", silent = true })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window", silent = true })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window", silent = true })

-- better way to exit from terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- setup plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- load plugins
require("lazy").setup({

  { -- syntax highlight
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "dockerfile",
        "yaml",
        "rust",
        "html",
        "css",
        "javascript",
        "typescript",
        "svelte",
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  { -- collection of colorschemes
    "RRethy/base16-nvim",
    config = function()
      require('base16-colorscheme').setup({
        base00 = '#000000',
        base01 = '#282a2e',
        base02 = '#373b41',
        base03 = '#969896',
        base04 = '#b4b7b4',
        base05 = '#c5c8c6',
        base06 = '#e0e0e0',
        base07 = '#ffffff',
        base08 = '#cc6666',
        base09 = '#de935f',
        base0A = '#f0c674',
        base0B = '#b5bd68',
        base0C = '#8abeb7',
        base0D = '#81a2be',
        base0E = '#b294bb',
        base0F = '#a3685a'
      })
    end
  },

  { -- rainbow brackets
    "HiPhish/rainbow-delimiters.nvim",
  },

  {
    -- highlight todo, notes, etc in comments
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

	{ -- file explorer
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		opts = {
			disable_netrw = true,
			renderer = {
        highlight_git = 'icon',
        -- highlight_opened_files = 'icon',
				icons = {
					show = {
            git = false,
						folder_arrow = false,
					},
				},
			},
		},
		init = function()
			local api = require("nvim-tree.api")
			vim.keymap.set("n", "<leader>e", api.tree.toggle)
		end,
	},

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },

  { -- quick search/actions
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        }
      }
    },
		init = function()
      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require('telescope').load_extension('fzf')
			local telescope = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", telescope.find_files, {})
			vim.keymap.set("n", "<leader>fg", telescope.live_grep, {})
			vim.keymap.set("n", "<leader>fb", telescope.buffers, {})
			vim.keymap.set("n", "<leader>fh", telescope.help_tags, {})
		end,
  },

  -- LSP setup
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()
      -- TODO: better icons
      lsp_zero.set_sign_icons({
        error = '✖',
        warn = '',
        hint = '',
        info = '󰋼'
      })
      lsp_zero.on_attach(function(_, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
        local telescope = require("telescope.builtin")
        vim.keymap.set('n', 'gr', telescope.lsp_references, {buffer = bufnr})
      end)
    end
  },
  {
    'williamboman/mason.nvim',
    opts = {}
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local lsp_config = require('lspconfig')
      local lsp_zero = require('lsp-zero')
      require('mason-lspconfig').setup({
        ensure_installed = { "tsserver" },
        handlers = {
          function(server_name)
            lsp_config[server_name].setup({})
          end,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            lsp_config.lua_ls.setup(lua_opts)
          end,
        }
      })
    end
  },
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/nvim-cmp' },
  { 'L3MON4D3/LuaSnip' },
})
-- vim: ts=2 sts=2 sw=2 et
