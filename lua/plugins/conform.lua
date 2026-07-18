return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = false,
			format_on_save = {
				-- Python runs a 4-formatter chain; 500ms was too tight on larger files
				timeout_ms = 2000,
				lsp_format = "fallback", -- replaces deprecated lsp_fallback = true
			},
			formatters = {
				ruff_format = {
					-- 52 is intentional: half-screen split workflow
					prepend_args = { "--line-length", "52" },
				},
				ruff_fix = {
					-- COM812: auto-add trailing commas to multiline collections
					prepend_args = { "--extend-select", "COM812" },
				},
				pyupgrade = {
					-- Not in mason registry; installed in nvim venv
					command = vim.fn.stdpath("config") .. "/.pyenvs/nvim/bin/pyupgrade",
					-- PEP 585 generics (list[int] not List[int]), PEP 604 unions (X | Y not Union[X, Y]), f-strings, etc.
					prepend_args = { "--py311-plus" },
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				-- pyupgrade modernizes syntax, docformatter enforces PEP 257,
				-- ruff_fix (lint + trailing commas), ruff_format (final layout).
				python = { "pyupgrade", "docformatter", "ruff_fix", "ruff_format" },

				javascript = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "yamlfmt" },
				tex = { "latexindent" },
				bib = { "bibtex-tidy" },
			},
		},
	},
}
