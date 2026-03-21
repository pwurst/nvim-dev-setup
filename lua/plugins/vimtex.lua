return {
	"lervag/vimtex",
	ft = { "tex", "latex" },
	init = function()
		-- vimtex uses localleader (<space>) prefix — all mappings are <space>l* in .tex files
		-- e.g. <space>ll = compile, <space>lv = view PDF, <space>lc = clean

		-- PDF viewer (zathura recommended on Linux; change to "skim" on macOS)
		vim.g.vimtex_view_method = "zathura"

		-- Use latexmk compiler with lualatex engine
		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_compiler_latexmk = {
			options = {
				"-lualatex",
				"-interaction=nonstopmode",
				"-synctex=1",
			},
		}

		-- Cleaner concealment (math, bold, italic rendered in-buffer)
		vim.g.vimtex_syntax_conceal = {
			accents = 1,
			ligatures = 1,
			cites = 1,
			fancy = 1,
			greek = 1,
			math_bounds = 1,
			math_delimiters = 1,
			math_fracs = 1,
			math_super_sub = 1,
			math_symbols = 1,
			sections = 0,
			styles = 1,
		}
	end,
}
