# Neovim Configuration

A modern, modular Neovim setup built around Python development, LaTeX writing,
Jupyter notebooks, and AI-assisted coding. Managed by
[lazy.nvim](https://github.com/folke/lazy.nvim).

---

## Version Requirements

**Neovim >= 0.11 is required — this config will not work on older releases.**
Currently tested against v0.13.0-dev (nightly). The hard dependencies on 0.11+:

- `vim.lsp.config()` / `vim.lsp.enable()` — how all LSP servers are registered
  (`lua/plugins/lsp.lua`)
- `vim.diagnostic.jump()` — the `[d` / `]d` diagnostic keymaps
- mason-lspconfig v2 (`automatic_enable`) — drops support for < 0.11
- nvim-treesitter `main` branch — the rewritten API used here requires 0.11+,
  plus the `tree-sitter` CLI >= 0.25 and a C compiler to build parsers

If you must run an older Neovim, check out a commit before the
`vim.lsp.config` / treesitter-main migrations (July 2026).

---

## Requirements

| Tool | Purpose |
|------|---------|
| Neovim >= 0.11 | Core (see [Version Requirements](#version-requirements)) |
| Git | Plugin management |
| A [Nerd Font](https://www.nerdfonts.com/) | Icons (run `install_nerdfonts.sh`) |
| `tree-sitter` CLI >= 0.25 + C compiler | Building treesitter parsers (main branch) |
| `ripgrep` | Grep picker and grug-far search & replace |
| `fd` (`fdfind` on Debian) | venv-selector search, faster file pickers |
| `npm` / `npx` | Markdown browser preview build step |
| `zathura` | PDF viewer for LaTeX (`sudo apt install zathura`) |
| `lazygit` | Git UI via `<leader>gg` (optional) |
| Python + `pip` | Jupyter/molten support (see [Jupyter setup](#jupyter--molten)) |

---

## Installation

```bash
git clone <this-repo> ~/.config/nvim
nvim  # lazy.nvim bootstraps and installs all plugins automatically
```

After first launch, run `:UpdateRemotePlugins` and restart Neovim (required for
molten-nvim).

---

## File Structure

```
~/.config/nvim/
├── init.lua                  # Entry point: leader key, lazy bootstrap, config load
├── lua/
│   ├── config/
│   │   ├── options.lua       # Editor settings (tabs, width, undo, etc.)
│   │   ├── keymaps.lua       # Global keybindings
│   │   ├── autocmds.lua      # Auto-commands (yank flash, spell for docs, etc.)
│   │   └── providers.lua     # Python provider path, disable unused providers
│   ├── plugins/              # One file per plugin or related group
│   └── utils/
│       └── cheatsheet.lua    # <leader>? navigation cheatsheet
```

---

## Plugins

### Appearance

#### [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
Dark colorscheme (night variant). Loads first at highest priority.

#### [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
Statusline showing mode, git branch, diff stats, diagnostics, relative file
path, filetype, and cursor position.

#### [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
File type icons used throughout the UI (lualine, pickers, oil, etc.).

#### [snacks.nvim](https://github.com/folke/snacks.nvim) — UI modules
A suite of small UI enhancements loaded as a single plugin:

| Module | What it does |
|--------|-------------|
| `notifier` | Replaces `vim.notify` with styled floating notifications |
| `dashboard` | Startup screen |
| `indent` | Indent guide lines |
| `statuscolumn` | Enhanced sign/fold/number column |
| `words` | Highlights all occurrences of the word under the cursor |
| `scope` | Highlights the current code scope |
| `input` | Styled input dialogs |
| `quickfile` | Fast file opening before plugins finish loading |
| `terminal` | Terminal backend (used by Claude Code) |
| `picker` | Fuzzy picker (see [Navigation](#navigation)) |
| `explorer` | File explorer sidebar (`<leader>e`) |
| `image` | Inline image rendering (Kitty graphics protocol) |
| `lazygit` | Lazygit in a floating terminal (see [Git](#git)) |

```
<leader>un    Dismiss all notifications
```

---

### Navigation

#### [snacks.nvim — Picker](https://github.com/folke/snacks.nvim)
The fuzzy finder for everything: files, buffers, text, git, LSP symbols.
Also provides `vim.ui.select`, so plugin prompts (venv-selector, code
actions) use the same UI.

```
<leader><space>   Smart find files (recent + project files)
<leader>,         Switch open buffers
<leader>/         Live grep across project
<leader>:         Command history
<leader>e         Toggle file explorer
<leader>ff        Find files
<leader>fr        Recent files
<leader>gc        Git commits
<leader>gs        Git status
<leader>sr        Resume last search
<leader>st        Search TODOs (via todo-comments)
<leader>ss        LSP symbols in current buffer
<leader>sd        Diagnostics
<leader>su        Undo history
```

#### [harpoon](https://github.com/ThePrimeagen/harpoon) (v2)
Pin up to 4 files per project and jump to them instantly.

```
<leader>ha        Add current file to harpoon list
<C-e>             Open harpoon menu
<leader>1-4       Jump to harpoon file 1–4
<C-n> / <C-p>     Cycle next / prev harpoon file
```

#### [flash.nvim](https://github.com/folke/flash.nvim)
Jump anywhere on screen in 2 keystrokes. Type `s` then 1–2 characters of your
target — flash labels every match and jumps when you type the label.

```
s                 Jump to any location (normal, visual, operator-pending)
S                 Jump using treesitter syntax nodes
r                 Remote flash (operator-pending: act on distant text)
R                 Treesitter search (visual / operator-pending)
```

Example: `ysS"` surround the treesitter node you flash to with quotes.

#### [oil.nvim](https://github.com/stevearc/oil.nvim)
Edit the filesystem like a buffer — rename, move, and delete files by editing
text, then save with `:w`.

```
-                 Open parent directory in oil
<M-h>             Open file in horizontal split
```

---

### Editing

#### [nvim-surround](https://github.com/kylechui/nvim-surround)
Add, change, or delete surrounding characters (quotes, brackets, tags).

```
ysiw"             Surround word with "quotes"
yss(              Surround line with (parens)
cs"'              Change surrounding "quotes" to 'single'
ds"               Delete surrounding quotes
```

#### [nvim-autopairs](https://github.com/windwp/nvim-autopairs)
Automatically closes `()`, `[]`, `{}`, `""`, `''` as you type. Integrates with
blink.cmp so completion and bracket pairing don't conflict.

#### [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
Syntax-aware highlighting and indentation for all supported languages. Also
powers flash's treesitter jump and the textobjects below. Uses the rewritten
`main` branch (requires Neovim 0.11+ and the `tree-sitter` CLI): parsers are
installed explicitly and highlighting is enabled per-buffer via a FileType
autocmd — see `lua/plugins/treesitter.lua`.

**Textobjects** — select or operate on code structures:
```
vaf / vif         Select outer / inner function
vac / vic         Select outer / inner class
]m / [m           Jump to next / prev function
]] / [[           Jump to next / prev class
```

Example: `daf` deletes an entire function including its signature.

---

### LSP & Completion

#### [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason.nvim](https://github.com/williamboman/mason.nvim)
Language servers installed by Mason and registered through the native
`vim.lsp.config()` API (Neovim 0.11+):

| Server | Language |
|--------|---------|
| `basedpyright` | Python (type checking) |
| `ruff` | Python (linting, import sorting) |
| `lua_ls` | Lua |
| `bashls` | Bash |
| `jsonls` | JSON |
| `yamlls` | YAML |
| `marksman` | Markdown |
| `texlab` | LaTeX |

Standard LSP keybindings (built into Neovim):
```
gd                Go to definition
gr                Go to references
K                 Hover documentation
<leader>cd        Show line diagnostics (float)
[d / ]d           Prev / next diagnostic
```

#### [blink.cmp](https://github.com/saghen/blink.cmp)
Fast completion engine with LSP, buffer, path, and snippet sources. Signature
help shows function argument hints automatically while typing.

```
<Tab>             Accept highlighted completion item / jump to next snippet field
<S-Tab>           Jump to previous snippet field
<Esc>             Leave insert mode (menu closes automatically)
```

#### [lazydev.nvim](https://github.com/folke/lazydev.nvim)
Full Neovim Lua API type definitions and completion when editing this config.
Registered as a high-priority blink.cmp source for `.lua` files.

#### [conform.nvim](https://github.com/stevearc/conform.nvim)
Formats automatically on save using the right tool per filetype:

| Filetype | Formatter |
|----------|----------|
| Python | `pyupgrade` → `docformatter` → `ruff_fix` → `ruff_format` |
| Lua | `stylua` |
| JS / JSON / Markdown | `prettierd` (installed via Mason) |
| YAML | `yamlfmt` |
| LaTeX / BibTeX | `latexindent` / `bibtex-tidy` |

Python formatting automatically wraps long lines and adds parentheses for line
continuation — no manual action needed. Line length is 52 by design, sized for
a half-screen vertical split.

---

### Git

#### [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
Git diff signs in the gutter, hunk-level staging, and inline blame.

```
]h / [h           Next / prev hunk
<leader>ghp       Preview hunk diff inline
<leader>ghs       Stage hunk
<leader>ghr       Reset hunk to HEAD
<leader>ghS       Stage entire buffer
<leader>ghR       Reset entire buffer to HEAD
<leader>ghu       Undo last staged hunk
<leader>gb        Full git blame for current line
<leader>gd        Diff current file against HEAD
```

#### [diffview.nvim](https://github.com/sindrets/diffview.nvim)
Side-by-side diffs, file history, and a merge-conflict view — complements
gitsigns, which works at hunk level.

```
<leader>gv        Diffview: working tree vs HEAD
<leader>gf        File history for current file
<leader>gF        File history for whole repo
```

#### snacks.nvim — Lazygit
Opens [lazygit](https://github.com/jesseduffield/lazygit) in a floating
terminal (requires the `lazygit` binary).

```
<leader>gg        Open lazygit
```

---

### Python

#### [venv-selector.nvim](https://github.com/linux-cultist/venv-selector.nvim)
Fuzzy-pick a virtual environment. Automatically notifies basedpyright and ruff so
type checking and linting use the correct interpreter immediately.

```
<leader>vs        Search and select a venv
<leader>vc        Re-activate the last used venv (cached)
```

#### [neotest](https://github.com/nvim-neotest/neotest) + [neotest-python](https://github.com/nvim-neotest/neotest-python)
Run pytest tests without leaving Neovim. Pass/fail indicators appear in the
gutter; the output panel shows the full test log.

```
<leader>tr        Run nearest test (under cursor)
<leader>tf        Run all tests in current file
<leader>ta        Run entire test suite
<leader>ts        Toggle test summary panel
<leader>to        Toggle test output panel
<leader>tS        Stop running tests
]T / [T           Jump to next / prev failed test
```

---

### Jupyter / Molten

#### [molten-nvim](https://github.com/benlubas/molten-nvim) + [image.nvim](https://github.com/3rd/image.nvim)
Run Jupyter kernels directly in Neovim. Text outputs appear as virtual text
inline; plots and images render inline via the Kitty graphics protocol.
Image rendering requires Ghostty or another Kitty-protocol terminal — falls
back to plain text automatically on unsupported terminals.

**One-time setup:**
```bash
~/.config/nvim/.pyenvs/nvim/bin/pip install pynvim jupyter_client pillow cairosvg
# Then inside Neovim:
:UpdateRemotePlugins
# Restart Neovim
```

```
<leader>ji        Initialize / choose a Jupyter kernel
<leader>jr        Run cell (normal) / run selection (visual)
<leader>jl        Run current line
<leader>ja        Run all cells in file
<leader>jn / jp   Jump to next / prev cell
<leader>js        Show output window
<leader>jh        Hide output window
<leader>jd        Delete cell output
<leader>jR        Restart kernel
<leader>jk        Interrupt kernel
```

---

### Debugging

#### [nvim-dap](https://github.com/mfussenegger/nvim-dap) + [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) + [nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python)
Full debug adapter protocol support for Python. The UI panel opens
automatically when a debug session starts and closes on exit. `debugpy` is
installed via Mason.

#### [nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text)
Shows live variable values as virtual text next to each line while stepping
through code — no need to inspect the variables panel manually.

```
<F5>              Start / continue
<F10>             Step over
<F11>             Step into
<F12>             Step out
<leader>db        Toggle breakpoint
<leader>du        Toggle DAP UI manually
```

---

### LaTeX

#### [vimtex](https://github.com/lervag/vimtex)
Compilation, forward/inverse PDF sync, TOC navigation, and in-buffer syntax
concealment (math symbols, Greek letters, bold/italic). Uses `latexmk` with
`lualatex` and `zathura` for PDF viewing.

All vimtex mappings use `<localleader>l` (i.e. `<space>l`) and are only active
in `.tex` files:

```
<space>ll         Start / stop continuous compilation
<space>lv         Open PDF viewer / forward search to current line
<space>lc         Clean auxiliary files (.aux, .log, etc.)
<space>lt         Open table of contents panel
<space>le         Open error / warning list
<space>li         Show document info
```

Inverse search works automatically: click a line in zathura to jump to the
corresponding source line in Neovim.

#### [texlab](https://github.com/latex-lsp/texlab-vscode) (LSP via Mason)
Completion for `\commands`, `\ref{}`, `\cite{}`, hover docs, and diagnostics
in `.tex` files. Installed automatically by Mason on first launch.

---

### Markdown

#### [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
Renders markdown in-buffer: styled headers, formatted tables, syntax-
highlighted code blocks, and checkboxes — all without leaving Neovim.
Activates automatically when you open a `.md` file.

#### [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
Opens a live-updating browser preview of the current markdown file. The
preview syncs scroll position as you move through the buffer.

```
<leader>mp        Toggle browser preview (only in .md files)
```

---

### AI — Claude Code

#### [claudecode.nvim](https://github.com/coder/claudecode.nvim)
Integrates the Claude Code CLI into Neovim via a snacks terminal panel docked
on the right side. Supports sending selections and files as context, and
accepts or rejects AI-generated diffs without leaving the editor.

```
<C-,>             Focus / toggle Claude panel (any mode)
<leader>ac        Toggle Claude panel
<leader>af        Focus Claude panel
<leader>ar        Resume previous session  (--resume)
<leader>aC        Continue last conversation  (--continue)
<leader>am        Select Claude model
<leader>ab        Add current buffer to Claude context
<leader>as        Send visual selection to Claude
<leader>as        Add file from tree  (when in an oil buffer)
<leader>aa        Accept Claude-generated diff
<leader>ad        Deny Claude-generated diff
```

---

### Productivity

#### [persistence.nvim](https://github.com/folke/persistence.nvim)
Saves the session (buffers, splits, window layout) per directory and restores
it on demand — the dashboard's "Restore Session" entry uses it too.

```
<leader>qs        Restore session for current directory
<leader>ql        Restore last session
<leader>qd        Don't save the current session on exit
```

#### [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim)
Project-wide find & replace with live ripgrep-powered preview. Edit the
search/replace fields like a normal buffer, then apply all or per-file.

```
<leader>sR        Open search & replace (normal or visual mode)
```

#### [which-key.nvim](https://github.com/folke/which-key.nvim)
Shows a keybinding popup after a short pause when you press the leader key.
Uses the helix preset (compact, flat layout).

```
<leader>          Show all leader bindings
<leader>?         Show navigation cheatsheet
```

#### [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)
Highlights `TODO`, `FIXME`, `HACK`, `NOTE`, `WARN`, and `PERF` comments with
distinct colours and makes them searchable via the snacks grep picker.

```
]t / [t           Jump to next / prev TODO comment
<leader>st        Fuzzy search all TODOs in the project
```

Example:
```python
# TODO: refactor once the API stabilises
# FIXME: off-by-one error on edge case
# NOTE: zathura must be installed for PDF preview
```

#### [trouble.nvim](https://github.com/folke/trouble.nvim)
A clean panel for diagnostics, symbols, and quickfix lists — replaces the
default quickfix window with a navigable, readable list.

```
<leader>xx        Toggle project-wide diagnostics
<leader>xd        Toggle diagnostics for current buffer only
<leader>xs        Toggle symbol list (functions, classes, variables)
<leader>xq        Toggle quickfix list
<leader>xl        Toggle location list
```

---

## General Keybindings

### Windows & Buffers
```
<C-h/j/k/l>       Move between splits
<C-arrows>         Resize splits
<S-h> / <S-l>      Prev / next buffer
<leader>bd         Delete current buffer
```

### Editing
```
<A-j> / <A-k>      Move line or selection up / down
< / >              Indent / unindent (stays in visual mode)
j / k              Navigate wrapped lines naturally
<Esc>              Clear search highlights (normal) / leave insert mode
<Esc><Esc>         Terminal mode -> normal mode
```

### UI Toggles
```
<leader>us         Toggle spell check
<leader>uw         Toggle line wrap
<leader>un         Dismiss notifications
<leader>l          Open Lazy plugin manager
```

### Misc
```
q                  Close help / quickfix / lspinfo / notify windows
<leader>?          Navigation cheatsheet
```

---

## Autocmds

| Trigger | Behaviour |
|---------|----------|
| After yank | Brief highlight flash on yanked region |
| Terminal resize | Auto-equalise all splits |
| `.md` `.tex` `.txt` `gitcommit` | Spell check + line wrap enabled automatically |
| Help / lspinfo / qf / notify | `q` closes the window |
