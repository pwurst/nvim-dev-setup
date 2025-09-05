# Neovim Config (Lazy-based, stable) — Noice removed

We remove **noice.nvim** to eliminate recurring runtime errors
(`noice/util/nui.lua: attempt to index local 'size' (a nil value)`) and
the notify backend warnings. The rest of the stack remains modern and
quiet: LSP (basedpyright + ruff_lsp), nvim-cmp, Treesitter (fixed
parser path), Conform (format), nvim-lint (shell diagnostics), Telescope,
Neo-tree.

## Install
```bash
mv ~/.config/nvim ~/.config/nvim.bak.$(date +%F-%H%M)
unzip nvim-stable-minimal-ui.zip -d ~/.config
mv ~/.config/nvim_stable_minimal_ui ~/.config/nvim
```

Then inside Neovim:
```
:Lazy sync
:checkhealth
:checkhealth nvim-treesitter
```

## Tree-sitter
Parsers install into:
```
:echo stdpath("data") .. "/treesitter-parsers"
```
If needed:
```
:TSInstall bash regex
:TSUpdate
```

## Formatting & Linting
- **conform.nvim**: on-save format (shfmt, ruff_format/black, stylua, etc.)
- **nvim-lint**: shellcheck for sh/bash/zsh

## Why remove Noice?
Noice replaces multiple UIs (cmdline/messages/popups) via nui.nvim and
optional notify backends. Small API/version drifts across dependencies
can surface as runtime errors. Removing it restores the native UI and
stability. You can re-add Noice later once upstream issues are resolved
or if you want specific UI features.