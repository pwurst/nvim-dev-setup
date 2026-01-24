return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim", -- ⚡ MOVED HERE
			"saghen/blink.cmp",
		},
		config = function()
			-- 1. Setup Mason
			require("mason").setup({ ui = { border = "rounded" } })

			-- 2. Capabilities
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- 3. Install Non-LSP Tools (Formatters, Linters, Debuggers)
			require("mason-tool-installer").setup({
				ensure_installed = {
					"ruff", -- Python Linter/Formatter
					"stylua", -- Lua Formatter
					"debugpy", -- Python Debugger
					"markdownlint",
				},
				auto_update = true,
				run_on_start = true,
			})

			-- 4. Define LSP Servers
			local servers = {
				pyright = {
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
								autoSearchPaths = true,
							},
						},
					},
				},
				ruff = {
					init_options = {
						settings = {},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
							diagnostics = { globals = { "vim" } },
						},
					},
				},
				bashls = {},
				jsonls = {},
				yamlls = {},
				marksman = {},
			}

			-- 5. Setup Mason-LSPConfig
			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
				automatic_installation = false,
				handlers = {
					function(server_name)
						local opts = servers[server_name] or {}
						opts.capabilities = capabilities
						require("lspconfig")[server_name].setup(opts)
					end,
				},
			})

			-- 6. UI Polish
			vim.diagnostic.config({
				float = { border = "rounded" },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✘",
						[vim.diagnostic.severity.WARN] = "▲",
						[vim.diagnostic.severity.HINT] = "⚑",
						[vim.diagnostic.severity.INFO] = "»",
					},
				},
			})
		end,
	},
}
