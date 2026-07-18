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
					-- Python
					"ruff",         -- linter + formatter
					"docformatter", -- PEP 257 docstring formatting (pyupgrade lives in nvim venv)
					"debugpy",      -- debugger
					-- Lua
					"stylua",
					-- Markdown
					"markdownlint",
					-- JS/JSON/Markdown formatting (conform lists it; must be installed)
					"prettierd",
					-- LaTeX
					"latexindent",
					"bibtex-tidy", -- .bib formatter
				},
				auto_update = true,
				run_on_start = true,
			})

			-- 4. Define LSP Servers
			local servers = {
				basedpyright = {
					settings = {
						basedpyright = {
							analysis = {
								typeCheckingMode = "basic",      -- "off" | "basic" | "standard" | "strict"
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,   -- infer types from installed libs
								diagnosticMode = "openFilesOnly",
								-- Silence diagnostics ruff already covers (avoids duplicates)
								reportUnusedImport = "none",     -- ruff F401
								reportUnusedVariable = "none",   -- ruff F841
								reportUnusedCallResult = "none", -- noisy for argparse/side-effect calls
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
				texlab = {}, -- LaTeX LSP (completion, diagnostics, build)
			}

			-- 5. Register server configs via the native API (replaces the
			-- deprecated require("lspconfig")[name].setup() pattern;
			-- still extends nvim-lspconfig's lsp/*.lua defaults)
			for server, opts in pairs(servers) do
				opts.capabilities = capabilities
				vim.lsp.config(server, opts)
			end

			-- 6. Mason-LSPConfig v2 installs the servers and enables them
			-- (automatic_enable calls vim.lsp.enable() for each)
			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			-- 7. UI Polish
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
