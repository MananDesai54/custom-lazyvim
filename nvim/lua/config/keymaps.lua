-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

local function telescope_builtin(builtin, opts)
  return function()
    require("telescope.builtin")[builtin](opts or {})
  end
end

local function open_reviewer_cheatsheet()
  local candidates = {}
  local function add(path)
    if not path or path == "" then
      return
    end
    local expanded = vim.fn.expand(path)
    if expanded ~= "" then
      table.insert(candidates, expanded)
    end
  end

  add(vim.g.lazyvim_reviewer_cheatsheet)
  add(vim.env.LAZYVIM_REVIEWER_CHEATSHEET)
  add("~/asgard/lazyvim-reviewer-setup.md")
  add(vim.fn.stdpath("config") .. "/README.md")
  add(vim.fn.stdpath("config") .. "/../README.md")
  add(vim.loop.os_homedir() .. "/custom-lazyvim/README.md")

  for _, path in ipairs(candidates) do
    local realpath = path
    local ok, resolved = pcall(vim.loop.fs_realpath, path)
    if ok and resolved then
      realpath = resolved
    end
    if vim.fn.filereadable(realpath) == 1 then
      vim.cmd("edit " .. vim.fn.fnameescape(realpath))
      return
    end
  end

  vim.notify(
    "Reviewer cheatsheet not found. Set vim.g.lazyvim_reviewer_cheatsheet or $LAZYVIM_REVIEWER_CHEATSHEET.",
    vim.log.levels.WARN
  )
end

map("n", "<leader>gv", "<cmd>DiffviewOpen<cr>", { desc = "Diffview (HEAD)" })
map("n", "<leader>gV", "<cmd>DiffviewOpen HEAD~1<cr>", { desc = "Diffview vs HEAD~1" })
map("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Repo history" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Current file history" })
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
map("n", "<leader>gp", "<cmd>Git push<cr>", { desc = "Git push" })
map("n", "<leader>gP", "<cmd>Git pull --rebase<cr>", { desc = "Git pull --rebase" })
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Git blame line" })
map("n", "<leader>e", "<cmd>Neotree toggle left reveal_force_cwd<cr>", { desc = "Explorer" })
map("n", "<leader>E", "<cmd>Neotree focus<cr>", { desc = "Focus Explorer" })
map("n", "<leader>?", open_reviewer_cheatsheet, { desc = "Open Reviewer cheatsheet" })
map("n", "<leader>lf", function()
  require("conform").format({ lsp_fallback = true })
end, { desc = "Format buffer" })

-- LSP / code-intel shortcuts
map("n", "gd", function()
  vim.lsp.buf.definition()
end, { desc = "Goto Definition" })
map("n", "gD", function()
  vim.lsp.buf.declaration()
end, { desc = "Goto Declaration" })
map("n", "gi", function()
  vim.lsp.buf.implementation()
end, { desc = "Goto Implementation" })
map("n", "gr", function()
  vim.lsp.buf.references()
end, { desc = "Goto References" })
map({ "n", "v" }, "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "Code Action" })
map("n", "<leader>cr", function()
  vim.lsp.buf.rename()
end, { desc = "Rename Symbol" })
map("n", "K", function()
  vim.lsp.buf.hover()
end, { desc = "Hover" })

map("n", "]g", function()
  require("gitsigns").nav_hunk("next")
end, { desc = "Next git hunk" })
map("n", "[g", function()
  require("gitsigns").nav_hunk("prev")
end, { desc = "Prev git hunk" })

-- Cursor-like navigation shortcuts
map("n", "<C-p>", telescope_builtin("find_files", { hidden = true, previewer = false }), { desc = "Quick open file" })
map("n", "<D-p>", telescope_builtin("find_files", { hidden = true, previewer = false }), { desc = "Quick open file" })
map("n", "<D-b>", telescope_builtin("buffers", { sort_lastused = true }), { desc = "Switch buffer" })
map("n", "<D-S-p>", "<cmd>Legendary<cr>", { desc = "Command Palette" })
map("n", "<leader>fp", telescope_builtin("commands", {}), { desc = "Command Palette (Telescope)" })
map("n", "<leader>fb", telescope_builtin("buffers", { sort_lastused = true }), { desc = "Switch buffer" })

map("n", "<D-/>", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })
map("v", "<D-/>", function()
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment" })
