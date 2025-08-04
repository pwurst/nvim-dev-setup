---

### Install nvim — **No sudo** (user‑local build)

Everything is compiled and installed into `$HOME/.local`, so it will not
touch system packages.

````bash
# 1 │ Clone Neovim source (nightly = master) ────────────────────────────────
mkdir -p ~/dev && cd ~/dev
git clone https://github.com/neovim/neovim.git
cd neovim
git checkout stable   # ← uncomment for latest stable tag

# 2 │ Compile + install *locally* ───────────────────────────────────────────
make CMAKE_BUILD_TYPE=RelWithDebInfo \
     CMAKE_INSTALL_PREFIX=$HOME/.local \
     CMAKE_INSTALL_DATADIR=$HOME/.local/share
make install

# 3 │ Add ~/.local/bin to PATH if not already ──────────────────────────────
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 4 | Verify ───────────────────────────────────────────────────────────────
nvim --version    # should show v0.11.x-dev and "Compiled by <user>"

## Python virtual‑environment
#### Plugins ####
Molten, nvim‑dap‑python, Ruff‑LSP, and Neovim’s own “remote plugin”
interface all run through the **same** interpreter referenced by
`vim.g.python3_host_prog`.
**Create a fresh venv (e.g. `~/.config/nvim/.pyenvs/nvim`) and install:**

```bash
pip install -U \
  pynvim           # required for any Python provider
  debugpy          # nvim-dap‑python (debug adapter)
  jupyter-client   # molten‑nvim (Jupyter kernel bridge)
  ipykernel        # “python3” kernel for Molten
  ruff-lsp         # Ruff language‑server (lint / fix)
  black            # formatter (optional, used via none‑ls/conform)
  isort            # import sorter (optional, used via none‑ls/conform)

````

## Bootstrap & maintenance commands for **Lazy.nvim**

| Purpose                                       | One‑shot CLI (good for scripts) | In‑Neovim command                 | When to use it                                               |
| --------------------------------------------- | ------------------------------- | --------------------------------- | ------------------------------------------------------------ |
| **Install all plugins**                       | `nvim "+Lazy sync" +qa`         | `:Lazy sync`                      | Immediately after cloning the repo on a fresh machine        |
| **Interactive update / review**               | —                               | `:Lazy` <br>then press **u**      | Periodic manual updates, cherry‑pick what to upgrade         |
| **Update everything to latest commit**        | —                               | `:Lazy update`                    | Keep plugins current (honours _lazy‑lock.json_ if present)   |
| **Remove plugins no longer in `plugins.lua`** | —                               | `:Lazy clean`                     | After you delete or rename plugins in the spec               |
| **Restore exact locked versions**             | —                               | `:Lazy restore`                   | CI builds or when an upstream commit breaks your setup       |
| **Profile startup time**                      | —                               | `:Lazy profile`                   | Diagnose slow startup (press **q** to exit the profile view) |
| **Run all plugin health‑checks**              | —                               | `:Lazy health`  or `:checkhealth` | Verify Python provider, Molten, DAP, etc.                    |

## Plugin catalogue

| Category                          | Plugin                                                                                                  | Why it’s included                                           |
| --------------------------------- | ------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| **Core / utility**                | [echasnovski/mini.nvim](https://github.com/echasnovski/mini.nvim)                                       | Lua helper modules; we use **mini.icons** & co.             |
|                                   | [3rd/image.nvim](https://github.com/3rd/image.nvim)                                                     | Inline image display in Kitty / WezTerm & completion menus. |
|                                   | [benlubas/molten‑nvim](https://github.com/benlubas/molten-nvim)                                         | Run Jupyter kernels directly in Neovim.                     |
| **File explorer**                 | [nvim‑neo‑tree/neo‑tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)                           | Async tree with git & diagnostics.                          |
| **Syntax / Treesitter**           | [nvim‑treesitter/nvim‑treesitter](https://github.com/nvim-treesitter/nvim-treesitter)                   | Incremental parsing, highlighting, folds.                   |
| **Debugging (DAP)**               | [mfussenegger/nvim‑dap](https://github.com/mfussenegger/nvim-dap)                                       | Core Debug Adapter Protocol engine.                         |
|                                   | [mfussenegger/nvim‑dap‑python](https://github.com/mfussenegger/nvim-dap-python)                         | Debugpy integration plus helpers.                           |
|                                   | [rcarriga/nvim‑dap‑ui](https://github.com/rcarriga/nvim-dap-ui)                                         | Side panels (scopes, console, REPL).                        |
|                                   | [jay‑babu/mason‑nvim‑dap.nvim](https://github.com/jay-babu/mason-nvim-dap.nvim)                         | Installs DAP adapters via Mason.                            |
| **LSP / completion / formatting** | [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)                                   | Binary package manager (LSP/DAP/linters).                   |
|                                   | [williamboman/mason‑lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)               | Bridges Mason packages to lspconfig.                        |
|                                   | [neovim/nvim‑lspconfig](https://github.com/neovim/nvim-lspconfig)                                       | Declarative LSP client setup.                               |
|                                   | [hrsh7th/nvim‑cmp](https://github.com/hrsh7th/nvim-cmp)                                                 | Completion engine (LSP, snippets, buffer, path).            |
|                                   | [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)                                                 | Fast snippet engine used by nvim‑cmp.                       |
|                                   | [windwp/nvim‑autopairs](https://github.com/windwp/nvim-autopairs)                                       | Automatic pairing with cmp integration.                     |
|                                   | [nvimtools/none‑ls.nvim](https://github.com/nvimtools/none-ls.nvim)                                     | External formatters / linters (Null‑LS fork).               |
|                                   | [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim)                                       | Async formatter on save.                                    |
| **Fuzzy search**                  | [nvim‑telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)                       | Highly extendable fuzzy‑finder.                             |
|                                   | [nvim‑telescope/telescope‑fzf‑native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | Native FZF sorter (C extension).                            |
| **Git**                           | [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)                                   | Git hunks & blame in the signcolumn.                        |
| **UI / theming**                  | [catppuccin/nvim](https://github.com/catppuccin/nvim)                                                   | “Mocha” colour scheme with extras.                          |
|                                   | [nvim‑lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                               | Fast statusline.                                            |
|                                   | [lukas‑reineke/indent‑blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)           | Indent guides & scope lines.                                |
|                                   | [SmiteshP/nvim‑navic](https://github.com/SmiteshP/nvim-navic)                                           | LSP breadcrumbs (winbar).                                   |
|                                   | [utilyre/barbecue.nvim](https://github.com/utilyre/barbecue.nvim)                                       | Themed breadcrumb bar.                                      |
|                                   | [kevinhwang91/nvim‑ufo](https://github.com/kevinhwang91/nvim-ufo)                                       | Modern async folding provider.                              |
|                                   | [NvChad/nvim‑colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)                               | #RRGGBB colour preview.                                     |
|                                   | [folke/twilight.nvim](https://github.com/folke/twilight.nvim)                                           | Dim inactive code for focus mode.                           |
| **Navigation helpers**            | [ThePrimeagen/harpoon](https://github.com/ThePrimeagen/harpoon)                                         | Quick‑mark & jump list (v2).                                |
|                                   | [stevearc/oil.nvim](https://github.com/stevearc/oil.nvim)                                               | Directory‑as‑buffer file manager.                           |
| **Authoring**                     | [lervag/vimtex](https://github.com/lervag/vimtex)                                                       | Full LaTeX workflow.                                        |
|                                   | [plasticboy/vim‑markdown](https://github.com/plasticboy/vim-markdown)                                   | Extra Markdown motions & folding.                           |
|                                   | [iamcco/markdown‑preview.nvim](https://github.com/iamcco/markdown-preview.nvim)                         | Live Markdown preview in browser.                           |
|                                   | [mattn/emmet‑vim](https://github.com/mattn/emmet-vim)                                                   | Emmet expansions for HTML/CSS.                              |
|                                   | [windwp/nvim‑ts‑autotag](https://github.com/windwp/nvim-ts-autotag)                                     | Auto‑close & rename HTML/JSX tags.                          |
| **Productivity & testing**        | [akinsho/toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)                                   | Embedded terminals in splits/floats.                        |
|                                   | [ahmedkhalf/project.nvim](https://github.com/ahmedkhalf/project.nvim)                                   | Auto‑detect project roots + Telescope.                      |
|                                   | [nvim‑neotest/neotest](https://github.com/nvim-neotest/neotest)                                         | Adapter‑driven test runner UI.                              |
|                                   | [nvim‑neotest/neotest‑python](https://github.com/nvim-neotest/neotest-python)                           | Python adapter for Neotest.                                 |
| **Outline / navigation**          | [simrat39/symbols‑outline.nvim](https://github.com/simrat39/symbols-outline.nvim)                       | File‑scope symbol tree.                                     |
|                                   | [SmiteshP/nvim‑navbuddy](https://github.com/SmiteshP/nvim-navbuddy)                                     | Breadcrumb & code‑context pop‑up.                           |
| **Quality‑of‑life**               | [folke/which‑key.nvim](https://github.com/folke/which-key.nvim)                                         | Popup for available mappings.                               |
|                                   | [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim)                                       | Context‑aware commenting.                                   |
|                                   | [folke/trouble.nvim](https://github.com/folke/trouble.nvim)                                             | Diagnostics / quickfix list sidebar.                        |
|                                   | [folke/todo‑comments.nvim](https://github.com/folke/todo-comments.nvim)                                 | Highlights & lists TODO / FIXME tags.                       |

> **Total:** ≈ 55 plugins managed via **Lazy.nvim**.  
> Heavy binaries (LSPs, DAP adapters) install on‑demand through **Mason**,
> so the dotfiles repo stays lightweight.

## Key commands & shortcuts

| Feature                                        | How to open / trigger                                                                                             | What it does                                                                  |
| ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| **File explorer** (**neo‑tree**)               | `<leader>e` — filesystem pane<br>`<leader>g` — git status pane<br>`<leader>d` — diagnostics pane                  | Toggles a sidebar on the **left** with files, git changes or LSP diagnostics. |
| **Directory‑as‑buffer** (**oil.nvim**)         | `-` (normal mode)                                                                                                 | Opens the current directory in a floating window; edit filenames like text.   |
| **Quick‑mark & jump list** (**harpoon v2**)    | `<leader>ha` — add file<br>`<leader>hh` — menu<br>`<leader>1` – `<leader>3` — jump to file 1‑3                    | Rapidly switch among up‑to‑three marked files.                                |
| **Fuzzy finder** (**Telescope**)               | `:Telescope find_files` – files<br>`:Telescope live_grep` – ripgrep search<br>`:Telescope buffers` – open buffers | Interactive search pop‑ups (no default keybinds—add if desired).              |
| **Terminal toggle** (**toggleterm**)           | `:ToggleTerm` (or map to a key)                                                                                   | Opens a 15‑line split with your shell; repeat to hide.                        |
| **Diagnostics list** (**trouble.nvim**)        | `:Trouble`                                                                                                        | Lists LSP errors, warnings, TODOs etc. in a side window.                      |
| **Comment toggle** (**Comment.nvim**)          | `<leader>/` (normal ⬌ visual)                                                                                     | Toggles line‑wise comments respecting filetype.                               |
| **Git signs** (**gitsigns.nvim**)              | `]c / [c` – next/prev hunk<br>`:Gitsigns preview_hunk`                                                            | Navigate & preview changes inline.                                            |
| **Outline / symbols**                          | `:SymbolsOutline` – file scope tree<br>`:Navbuddy` – breadcrumb pop‑up                                            | Quick navigation around functions, classes, headings.                         |
| **DAP (Python)**                               | `<F5>` start/continue<br>`<F10>/<F11>/<F12>` step<br>`<F9>` toggle breakpoint<br>`<F7>` toggle DAP UI             | Full debug workflow with **dap‑ui** panels.                                   |
| **Interactive Jupyter cell** (**molten‑nvim**) | `:MoltenInit python` – start kernel<br>`<leader>m` mappings (Molten defaults)                                     | Run notebook‑style code blocks inside Neovim.                                 |
| **Project root switcher** (**project.nvim**)   | Automatically sets `cwd` based on `.git`, `Makefile`, `pyproject.toml`                                            | No manual command—kicks in when you open a buffer.                            |
| **Run code / scripts** (**Code Runner**)       | `<leader>Rf` – run file<br>`<leader>Rv` – run visual selection<br>`<leader>Rp` – run project                      | Executes with output in a split.                                              |
| **Update fold tree once**                      | `<leader>uf` or `:UpdateFolds`                                                                                    | Recomputes folds, then freezes them (no auto‑collapse on _Esc_).              |
| **Health & plugin panel** (**Lazy.nvim**)      | `:Lazy` – open UI<br>`u` inside UI – update<br>`x` – clean unused                                                 | Manage plugins interactively.                                                 |

**TIP**
If you forget a keybinding, hit <space> (your leader), wait a second
and which‑key will pop up a hint menu listing everything under the
current prefix.
