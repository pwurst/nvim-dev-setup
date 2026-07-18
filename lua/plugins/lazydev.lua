return {
	-- Neovim Lua API types + completion when editing config
	-- (real type definitions vs the lua_ls globals={"vim"} workaround)
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Only load luv types when vim.uv is referenced
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	-- Register lazydev as a high-priority blink.cmp source
	-- (sources.default merges with completion.lua via opts_extend)
	{
		"saghen/blink.cmp",
		opts = {
			sources = {
				default = { "lazydev" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100, -- rank above regular LSP results
					},
				},
			},
		},
	},
}
