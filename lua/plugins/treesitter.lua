-- Migrated to the rewritten `main` branch (master is frozen/legacy).
-- The main branch has no configs.setup(); parsers are installed explicitly
-- and highlighting/indent are enabled per-buffer via core Neovim APIs.

local parsers = {
	"bash",
	"c",
	"diff",
	"css",
	"html",
	"javascript",
	"jsdoc",
	"json", -- also covers jsonc (no separate parser on main branch)
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"regex",
	"latex",
	"bibtex",
	"scss",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false, -- main branch does not support lazy-loading
		config = function()
			require("nvim-treesitter").install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
				callback = function(ev)
					-- pcall: parser may be missing for this filetype (or still installing)
					if pcall(vim.treesitter.start, ev.buf) then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		lazy = false,
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true }, -- jump forward to nearest textobj
				move = { set_jumps = true }, -- record movements in the jumplist
			})

			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")
			local function sel(obj)
				return function()
					select.select_textobject(obj, "textobjects")
				end
			end

			-- Same maps as before the migration: af/if/ac/ic, ]m ]] [m [[
			vim.keymap.set({ "x", "o" }, "af", sel("@function.outer"), { desc = "Function (outer)" })
			vim.keymap.set({ "x", "o" }, "if", sel("@function.inner"), { desc = "Function (inner)" })
			vim.keymap.set({ "x", "o" }, "ac", sel("@class.outer"), { desc = "Class (outer)" })
			vim.keymap.set({ "x", "o" }, "ic", sel("@class.inner"), { desc = "Class (inner)" })

			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				move.goto_next_start("@function.outer", "textobjects")
			end, { desc = "Next function" })
			vim.keymap.set({ "n", "x", "o" }, "]]", function()
				move.goto_next_start("@class.outer", "textobjects")
			end, { desc = "Next class" })
			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end, { desc = "Prev function" })
			vim.keymap.set({ "n", "x", "o" }, "[[", function()
				move.goto_previous_start("@class.outer", "textobjects")
			end, { desc = "Prev class" })
		end,
	},
}
