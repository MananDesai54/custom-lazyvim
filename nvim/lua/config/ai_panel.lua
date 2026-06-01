local M = {}

local providers_defs = {
  { id = "claude", label = "Claude Code", key = "c", cmd = "claude" },
  { id = "opencode", label = "OpenCode", key = "o", cmd = "opencode" },
  { id = "codex", label = "Codex", key = "x", cmd = "codex" },
  { id = "pi", label = "Pi CLI", key = "p", cmd = "pi" },
  { id = "gemini", label = "Gemini CLI", key = "g", cmd = "gemini" },
}

local diff_actions = {
  { key = "d", label = "Open Diffview (visualize changes)", action = function()
      vim.cmd("DiffviewOpen")
    end },
  { key = "h", label = "Toggle inline git hunks", action = function()
      vim.cmd("Gitsigns toggle_current_line_blame")
    end },
}

local panel_state = {
  win = nil,
  buf = nil,
}

local function close_panel()
  if panel_state.win and vim.api.nvim_win_is_valid(panel_state.win) then
    vim.api.nvim_win_close(panel_state.win, true)
  end
  if panel_state.buf and vim.api.nvim_buf_is_valid(panel_state.buf) then
    vim.api.nvim_buf_delete(panel_state.buf, { force = true })
  end
  panel_state.win = nil
  panel_state.buf = nil
end

function M.toggle(id)
  local provider = M.providers and M.providers[id]
  if not provider or not provider.term then
    vim.notify("AI provider " .. (id or "") .. " missing", vim.log.levels.WARN)
    return
  end
  provider.term:toggle()
end

local function render_panel()
  vim.cmd("botright vsplit")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.34))

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true
  vim.bo[buf].filetype = "ai_panel"

  local lines = {
    " AI Studio",
    "────────────────────────────────",
    "Press a key to launch or toggle a CLI:",
    "",
  }

  for _, provider in ipairs(providers_defs) do
    lines[#lines + 1] = string.format(" %s  %s", provider.key, provider.label)
  end

  lines[#lines + 1] = ""
  lines[#lines + 1] = " Actions"
  lines[#lines + 1] = "────────────────────────────────"
  for _, action in ipairs(diff_actions) do
    lines[#lines + 1] = string.format(" %s  %s", action.key, action.label)
  end
  lines[#lines + 1] = ""
  lines[#lines + 1] = " q  Close panel"

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  for _, provider in ipairs(providers_defs) do
    vim.keymap.set("n", provider.key, function()
      M.toggle(provider.id)
    end, { buffer = buf, nowait = true })
  end

  for _, action in ipairs(diff_actions) do
    vim.keymap.set("n", action.key, function()
      action.action()
    end, { buffer = buf, nowait = true })
  end

  vim.keymap.set("n", "q", close_panel, { buffer = buf, nowait = true })

  panel_state.win = win
  panel_state.buf = buf
end

function M.open_panel()
  if panel_state.win and vim.api.nvim_win_is_valid(panel_state.win) then
    vim.api.nvim_set_current_win(panel_state.win)
    return
  end
  render_panel()
end

function M.setup()
  local ok, Terminal = pcall(require, "toggleterm.terminal")
  if not ok then
    return
  end

  M.providers = {}
  for _, def in ipairs(providers_defs) do
    local term = Terminal:new({
      cmd = def.cmd,
      close_on_exit = false,
      direction = "vertical",
      hidden = true,
      on_open = function(t)
        vim.api.nvim_buf_set_option(t.bufnr, "filetype", "terminal")
      end,
    })
    M.providers[def.id] = { def = def, term = term }
  end

  if vim.fn.has("nvim-0.10") == 1 then
    vim.filetype.add({ extension = { ["ai_panel"] = "ai-panel" } })
  end
end

return M
