# Neovim configuration (updated for **Ruff** native LSP)

This configuration uses **lazy.nvim** (stable) with one Lua file per plugin
under `lua/plugins/`. It targets Python, Markdown, LaTeX, and HTML.

**Update:** As of early 2025, `ruff-lsp` is deprecated in favor of the native
**Ruff Language Server** exposed by the `ruff` binary. This config uses
`lspconfig.ruff` and installs the `ruff` package via Mason.

- Line numbers, visible whitespace (including trailing spaces)
- Python debugging: `nvim-dap` + `debugpy` + `dap-ui` + virtual text
- Spellcheck on for Markdown/LaTeX; toggle with `<Space>us`
- Harpoon v2; Neo-tree on the left (`<Space>e`)
- which-key for leader hints; small motion cheat-sheet `<Space>?n`
- LSP via Mason: `pyright`, `ruff`, `lua_ls`, `texlab`, `html`, `cssls`, `marksman`
- Formatting via `conform.nvim`: Black (py), Stylua (lua), mdformat (md), yamlfmt (yaml)

### First-time setup
1. Unzip into `~/.config/nvim`.
2. Launch `nvim` to bootstrap **lazy** and install plugins.
3. `:Mason` to confirm tools. (`mason-tool-installer` ensures: ruff, black, stylua, mdformat, debugpy, yamlfmt.)

### Key bindings
- `<Space>e` — Neo-tree
- `<Space>ff` / `<Space>fg` — Telescope files / live grep
- `<Space>us` — toggle spell
- **Harpoon:** `<Space>ha` add; `<Space>hh` menu; `<Space>h1..h4` jump
- **DAP:** `<F9>` breakpoint; `<F5>` continue; `<F10>/<F11>/<F12>` step; `<Space>du` UI
- `<Space>wk` — which-key; `<Space>?n` — navigation cheat-sheet

### Notes
- We disable `hover` and `formatting` capabilities from Ruff LSP to let
  Pyright handle hover and `conform.nvim` handle formatting.
  Adjust in `lua/plugins/lsp.lua` if you want Ruff to format or show hovers.
