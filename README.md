
# Neovim setup (modern stable, Lazy layout)

This bundle updates your previous config to a stable, minimal, and fast layout:
- **Plugin manager**: lazy.nvim (stable branch)
- **LSP**: nvim-lspconfig + mason(-lspconfig)
- **Completion**: nvim-cmp + LuaSnip
- **Formatting**: conform.nvim (on save, with LSP fallback)
- **Linting**: nvim-lint (ruff, shellcheck, etc.)
- **UI**: tokyonight, lualine, noice, devicons, ibl
- **Files**: telescope, oil.nvim
- **Python**: basedpyright + ruff LSP; venv selector optional
- **Jupyter/Quarto**: molten.nvim, jupytext, quarto.nvim (kept)

## Install

1. Back up your current `~/.config/nvim` folder.
2. Extract this archive into `~/.config/nvim` (or copy files over).
3. Launch Neovim and run `:Lazy sync`.
4. Once plugins are installed, run `:Mason` to verify tools.

### Suggested external tools (install via pipx/apt/homebrew)

- `basedpyright`, `ruff`, `black`, `isort`, `shellcheck`, `shfmt`, `stylua`, `markdownlint`.

On Debian (with `pipx`):
```bash
pipx install basedpyright ruff black isort
sudo apt-get install -y shellcheck shfmt
```

## Notes

- `conform.nvim` formats on save. Toggle per-buffer with:
  ```vim
  :let b:disable_format_on_save = 1
  ```
- `nvim-lint` runs after save/insert-leave.
- Python LSP: we prefer **basedpyright**; fallback to pyright if not present.
- Ruff runs both as **LSP** (`ruff`) and CLI linter (`nvim-lint`) to catch quick
  issues and organize imports/format when configured.
