local M = {}

function M.show_navigation()
  local lines = {
    "Basic navigation (built-ins):",
    "  w / b / e         : next/prev word / end of word",
    "  { / }             : prev/next paragraph",
    "  gg / G            : start / end of document",
    "  0  / ^  / $       : start of line / first nonblank / end of line",
    "  Ctrl-d / Ctrl-u   : half-page down / up",
    "  Ctrl-f / Ctrl-b   : page down / up",
    "",
    "This is a reminder; motions are NOT remapped.",
  }
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local width = 56
  local height = #lines + 2
  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    border = "rounded",
  }
  vim.api.nvim_open_win(buf, true, opts)
end

return M
