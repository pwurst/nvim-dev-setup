return {
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "*", -- Uses pre-built binary (no rust compile needed usually)

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for tab-based completion (like VSCode)
			-- 'enter' for enter-based selection
			keymap = {
				preset = "super-tab",
				-- Tab immediately accepts the highlighted suggestion (or falls through to snippet jump / normal Tab)
				["<Tab>"] = { "accept", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
			},

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			-- Sources: LSP, Buffer, Path, Snippets (built-in)
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			-- Signature Help (Experimental but good)
			signature = { enabled = true },
		},
		opts_extend = { "sources.default" },
	},
}
