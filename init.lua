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
vim.opt.showmode = false -- disable -- INSERT -- label
vim.opt.incsearch = true -- show matches while typing search pattern
vim.opt.magic = true -- enable RegExp in search pattern
vim.opt.wildmenu = true -- show commands completion in bottom menu
vim.opt.undofile = true -- save undo history
vim.opt.signcolumn = "yes" -- keep signcolumn on by default
vim.opt.inccommand = "split" -- preview substitutions live, as you type
vim.opt.hlsearch = true

vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom

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

	{ -- Syntax highlight
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			-- HACK: Important to install via git, regular versions are outdated
			require("nvim-treesitter.install").prefer_git = true
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"css",
					"csv",
					"diff",
					"dockerfile",
					"go",
					"html",
					"javascript",
					"jsdoc",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"python",
					"rust",
					"sql",
					"svelte",
					"toml",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
					"yaml",
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	{ -- Collection of colorschemes
		"RRethy/base16-nvim",
		config = function()
			require("base16-colorscheme").setup({
				base00 = "#000000",
				base01 = "#282a2e",
				base02 = "#373b41",
				base03 = "#969896",
				base04 = "#b4b7b4",
				base05 = "#c5c8c6",
				base06 = "#e0e0e0",
				base07 = "#ffffff",
				base08 = "#cc6666",
				base09 = "#de935f",
				base0A = "#f0c674",
				base0B = "#b5bd68",
				base0C = "#8abeb7",
				base0D = "#81a2be",
				base0E = "#b294bb",
				base0F = "#a3685a",
			})
		end,
	},

	{
		-- Highlight #rgba colors
		"NvChad/nvim-colorizer.lua",
		opts = {},
	},

	{ -- Rainbow brackets
		"HiPhish/rainbow-delimiters.nvim",
	},

	{
		-- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{ -- Buffer git integration
		"lewis6991/gitsigns.nvim",
		opts = {},
	},

	{ -- Comments engine
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},

	{ -- File explorer
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		opts = {
			disable_netrw = true,
			update_focused_file = {
				enable = true,
			},
			renderer = {
				highlight_git = "icon",
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

			-- Open
			vim.keymap.set("n", "<leader>e", api.tree.toggle)

			-- Add to git
			local git_add = function()
				local node = api.tree.get_node_under_cursor()
				local gs = node.git_status.file

				-- If the current node is a directory get children status
				if gs == nil then
					gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1])
						or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
				end

				-- If the file is untracked, unstaged or partially staged, we stage it
				if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
					vim.cmd("silent !git add " .. node.absolute_path)

				-- If the file is staged, we unstage
				elseif gs == "M " or gs == "A " then
					vim.cmd("silent !git restore --staged " .. node.absolute_path)
				end

				api.tree.reload()
			end
			vim.keymap.set("n", "ga", git_add, { desc = "[G]it [A]dd" })
			-- TODO: reset file
		end,
	},

	{ -- Better statusline
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				theme = "base16",
				section_separators = "",
				component_separators = "",
				globalstatus = true,
			},
			sections = {
				lualine_c = {
					{
						"filename",
						symbols = {
							modified = "",
							readonly = "",
							unnamed = "󰡯",
							newfile = "󰝒",
						},
					},
				},

				lualine_x = { "fileformat", "filetype" },
				lualine_y = {},
			},
		},
	},

	-- TODO: use folke/noice.nvim

	{ -- Quick search/actions
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		opts = {
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		},
		init = function()
			-- To get fzf loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("fzf")
			local telescope = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", telescope.find_files, {})
			vim.keymap.set("n", "<leader>fg", telescope.live_grep, {})
			vim.keymap.set("n", "<leader>fb", telescope.buffers, {})
			vim.keymap.set("n", "<leader>fh", telescope.help_tags, {})
		end,
	},

	{ -- Formaters
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "shfmt" },
				zsh = { "shfmt" },
				typescript = { "biome", "eslint", "prettier" },
				typescriptreact = { "biome", "eslint", "prettier" },
				javascript = { "biome", "eslint", "prettier" },
				javascriptreact = { "biome", "eslint", "prettier" },
			},
			format_on_save = {
				async = false,
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},

	{ -- Linters integration
		"mfussenegger/nvim-lint",
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				dockerfile = { "hadolint" },
				sh = { "shellcheck" },
				zsh = { "shellcheck" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	-- LSP setup
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		config = function()
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()
			lsp_zero.set_sign_icons({
				error = "",
				warn = "",
				hint = "",
				info = "",
			})
			lsp_zero.on_attach(function(_, bufnr)
				lsp_zero.default_keymaps({ buffer = bufnr })
				local telescope = require("telescope.builtin")
				vim.keymap.set("n", "gr", telescope.lsp_references, { buffer = bufnr })
				vim.keymap.set("n", "gi", telescope.lsp_implementations, { buffer = bufnr })
				vim.keymap.set("n", "go", telescope.lsp_type_definitions, { buffer = bufnr })
			end)
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			local lsp_config = require("lspconfig")

			local lsp_zero = require("lsp-zero")
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						lsp_config[server_name].setup({})
					end,
					-- Override lua_ls, add typings for 'vim' global variable
					lua_ls = function()
						local lua_opts = lsp_zero.nvim_lua_ls()
						lsp_config.lua_ls.setup(lua_opts)
					end,
				},
			})
		end,
	},
	{ "neovim/nvim-lspconfig" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/nvim-cmp" },
	{ "L3MON4D3/LuaSnip" },
})
-- vim: ts=2 sts=2 sw=2 et
