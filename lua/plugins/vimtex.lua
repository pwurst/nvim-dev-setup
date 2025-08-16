return {
  {
    "lervag/vimtex",
    ft = { "tex", "plaintex", "latex" },
    init = function()
      vim.g.vimtex_view_method = (vim.fn.executable("zathura") == 1) and "zathura"
                              or (vim.fn.has("macunix") == 1 and "skim" or "general")
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_quickfix_mode = 0
    end,
  },
}