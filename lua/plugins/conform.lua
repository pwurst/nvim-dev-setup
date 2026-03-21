return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = false,
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters = {
				ruff_format = {
					prepend_args = { "--line-length", "79" },
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				-- Use Ruff for everything. It handles imports (isort) and formatting (black)
				-- matching your 'hydrobridge' project config perfectly.
				python = { "ruff_fix", "ruff_format" },

				javascript = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "yamlfmt" },
			},
		},
	},
}
