# LazyVim Reviewer Setup Cheatsheet

A quick reference for your keyboard-only, diff-first LazyVim environment.

---
## 1. Core Concepts
- **Keyboard-first (mouse optional)**: Everything is mapped for keys, but the mouse is enabled when you want precision clicks.
- **Diff-first**: Diffview + Gitsigns power most review tasks.
- **Command palette**: Legendary.nvim provides a Cursor/VSCode-like palette.
- **Browser Markdown preview**: Instant doc previews without leaving Neovim.
- **Leader key = `<Space>`**: Any shortcut shown as `<leader>` starts with the space bar.
- **Reference any time**: `<leader>?` opens this cheatsheet in the current window. On a new machine, either keep this README alongside the config repo or set `vim.g.lazyvim_reviewer_cheatsheet` / `$LAZYVIM_REVIEWER_CHEATSHEET` to point at any custom path.

---
## 2. Explorer (VSCode-style Sidebar)
- Toggle the sidebar: `<leader>e` (Space → `e`).
- Focus the sidebar without closing it: `<leader>E`.
- Neo-tree mirrors VSCode behaviour: left aligned, follows your current file, and auto-refreshes on file changes.
- Sources available inside the sidebar: filesystem, open buffers, and git status (switch via `<tab>` inside the panel).

---
## 3. Git & Diff Flow
| Action | Shortcut |
| --- | --- |
| Open Diff vs HEAD | `<leader>gv` |
| Diff vs previous commit | `<leader>gV` |
| Diff vs `origin/main` | `<leader>gD` |
| File history (repo) | `<leader>gH` |
| File history (current file) | `<leader>gh` |
| Focus file panel | `<leader>gF` |
| Close Diffview | `<leader>gq` |
| Stage / reset hunk | `<leader>gs` / `<leader>gr` |
| Next / previous hunk | `]g` / `[g` |
| Line blame | `<leader>gb` |
| Fugitive status window | `<leader>gg` |
| Push / pull --rebase | `<leader>gp` / `<leader>gP` |

> Tip: Diff buffers use `linematch` + histogram algorithm for clearer hunks.

### Lazygit view (full Git UI)
- Press `<leader>lg` to pop open **LazyGit** inside a floating window for staging, interactive rebase, branch management, etc. `<Esc>` or `q` closes it.
- `<leader>lG` opens LazyGit in "filter" mode for quickly searching commits.
- Requires the `lazygit` CLI. Install via `brew install lazygit` (macOS) or follow https://github.com/jesseduffield/lazygit#installation.

---
## 4. Shortcut discovery
- `<leader>?` — open this cheatsheet (Lazy will look for `vim.g.lazyvim_reviewer_cheatsheet`, `$LAZYVIM_REVIEWER_CHEATSHEET`, this repo’s `README.md`, or `~/asgard/lazyvim-reviewer-setup.md`).
- `<leader>P` or `⌘⇧P` — Legendary command palette (search commands, keymaps, autocmds).
- Hold `<leader>` for a second — Which-key pops up grouped shortcuts.
- `:Legendary keymaps` — list all registered keymaps from every plugin.

---
## 5. Cursor/VSCode-style Shortcuts
| Action | Shortcut |
| --- | --- |
| Command palette (Legendary) | `⌘⇧P` ( `<D-S-p>` ) or `<leader>P` |
| Quick file open (Telescope) | `⌘P` / `Ctrl+P` |
| Switch buffers | `⌘B` |
| Toggle comments | `⌘/` (normal & visual) |
| Format current buffer | `<leader>lf` (Conform) |
| Go to definition / declaration | `gd` / `gD` |
| References / implementations | `gr` / `gi` |
| Rename / code action | `<leader>cr` / `<leader>ca` |
| Hover docs (manual) | `K` (also auto-pop on hover) |
| Telescope command list | `<leader>fp` |
| Telescope buffers list | `<leader>fb` |

Legendary auto-imports Lazy commands, keymaps, and Telescope pickers, so you can fuzzy-search any action.

---
## 6. Code Intelligence & Hover Docs
- **Auto hover**: stop on a symbol in normal mode and, after ~300ms, a floating tooltip appears with LSP hover info plus diagnostics near the cursor (mirrors Cursor’s inline info). The popup only shows when the language server actually returns content, so empty symbols stay quiet. Use `:let g:disable_auto_hover = 1` to disable globally or set `vim.b.disable_auto_hover = true` per buffer.
- **Diagnostics**: the same hover delay pops a rounded diagnostic float (non-focusable) for the current cursor.

### Go to Definition & Find Usages (IDE-style)
Put the cursor on a symbol in normal mode:

| Action | Shortcut |
| --- | --- |
| Go to definition | `gd` |
| Go to declaration | `gD` |
| Go to implementation | `gi` |
| Go to type definition | `gy` |
| Find references / usages | `gr` |
| Hover docs | `K` |
| Rename symbol (all usages) | `<leader>cr` |
| Code action | `<leader>ca` |
| Document symbols (Telescope) | `<leader>ss` |

- **Jump back / forward**: `<C-o>` returns to where you jumped from, `<C-i>` goes forward again.
- **References** open in a Telescope/quickfix list — `j`/`k` to move, `<CR>` to jump, `<Esc>` to close.
- Needs an LSP attached for the filetype. Check with `:LspInfo`; if `gd`/`gr` do nothing, install the server via `:Mason`.

---
## 7. AI Studio Side Panel
- **Open the panel**: `<leader>ai` or run `:AIStudio`. A right-hand scratch buffer lists available AI CLIs and helper actions.
- **Launch/toggle providers** (pre-wired keys inside the panel or direct mappings):
  - `c` / `<leader>ac` — Claude Code (`claude` CLI)
  - `o` / `<leader>ao` — OpenCode CLI (`opencode`)
  - `x` / `<leader>ax` — Codex CLI
  - `p` / `<leader>ap` — Inflection Pi CLI (`pi`)
  - `g` / `<leader>ag` — Gemini CLI (`gemini`)
- Each line shows `[ready]` or `[install <binary>]`. Install the matching CLI (via Brew/NPM/etc.) or override `vim.g.ai_panel_providers` to point at your own command.
- These run in dedicated ToggleTerm vertical splits on the right. Replace or extend providers by editing `lua/config/ai_panel.lua` or setting `vim.g.ai_panel_providers` before Lazy loads.
- **Diff helpers from the same pane**: press `d` to open Diffview against HEAD or `h` to toggle inline gitsigns blame for quick visual context.
- Close the panel with `q`. Terminals stay around, so you can re-toggle them later.

---
## 8. Markdown Preview in Browser
1. Open a Markdown buffer.
2. Press `<leader>mp` to launch the preview (served from `127.0.0.1:8889`). Your default browser opens automatically.
3. `<leader>mt` toggles, `<leader>mP` stops the server.
4. The preview URL is echoed in Neovim if you want to copy/share.

Settings:
- Theme: dark
- Local-only (no network exposure)
- Combines preview + auto-refresh on save

---
## 9. Learn Vim (in-editor assistant)
- `VimBeGood` plugin is installed. Press `<leader>tv` or run `:VimBeGood` for movement/drill exercises inside Neovim.
- Your progress logs to `~/.local/share/nvim/vim-be-good.log` so you can track improvements.
- Combine drills with Legendary/Which-key popovers to reinforce muscle memory as you practice in real code.

---
## 10. Extras & Quality-of-Life
- **Git Conflict highlights**: Conflict hunks use `n`/`]x` default maps from `akinsho/git-conflict.nvim` with diagnostics muted.
- **Gitsigns inline blame**: Hover over any line and see commit info on the right.
- **Diffview merge tool layout**: `diff4_mixed` is ready if you open merge conflicts.
- **Legendary history**: Frequently used commands surface to the top automatically.

---
## 11. Daily Workflow Suggestion
1. `⌘⇧P` → "Diffview" to open whichever comparison you need.
2. Navigate files with the left panel (`<leader>gF`) or `Tab` cycling.
3. Stage/reset hunks (`<leader>gs`/`gr`) as you review.
4. Need context? `⌘P` to open related files or `<leader>gh` to inspect per-file history.
5. Document changes? Preview Markdown (`<leader>mp`) while editing release notes or docs.

Stay entirely on the keyboard while getting quick access to diffs, history, and docs.
