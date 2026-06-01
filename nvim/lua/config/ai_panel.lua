local M = {}

local PANEL_WIDTH_RATIO = 0.34
local providers_defs = {
  { id = "claude", label = "Claude Code", key = "c", cmd = "claude" },
  { id = "opencode", label = "OpenCode", key = "o", cmd = "opencode" },
  { id = "codex", label = "Codex", key = "x", cmd = "codex" },
  { id = "pi", label = "Pi CLI", key = "p", cmd = "pi" },
  { id = "gemini", label = "Gemini CLI", key = "g", cmd = "gemini" },
}

local diff_actions = {
  {
    key = "d",
    label = "Open Diffview (visualize changes)",
    action = function()
      vim.cmd("DiffviewOpen")
    end,
  },
  {
    key = "h",
    label = "Toggle inline git hunks",
    action = function()
      vim.cmd("Gitsigns toggle_current_line_blame")
    end,
  },
}

local panel_state = { win = nil, buf = nil }
local TerminalClass
local initialized = false
local command_registered = false

local function get_provider_defs()
  if type(vim.g.ai_panel_providers) == "table" then
    return vim.g.ai_panel_providers
  end
  return providers_defs
end

local function get_binary_from_cmd(cmd)
  if not cmd or cmd == "" then
    return nil
  end
  local parts = vim.split(cmd, "%s+", { trimempty = true })
  return parts[1]
end

local function build_provider_table()
  M.providers = {}
  for _, def in ipairs(get_provider_defs()) do
    local bin = def.bin or get_binary_from_cmd(def.cmd)
    local available = bin and vim.fn.executable(bin) == 1
    local term

    if TerminalClass and available then
      term = TerminalClass:new({
        cmd = def.cmd,
        close_on_exit = false,
        direction = "vertical",
        hidden = true,
        on_open = function(t)
          vim.api.nvim_buf_set_option(t.bufnr, "filetype", "terminal")
        end,
      })
    end

    M.providers[def.id] = {
      def = def,
      term = term,
      available = available,
      bin = bin,
    }
  end
end

local function ensure_command()
  if command_registered then
    return
  end
  vim.api.nvim_create_user_command("AIStudio", function()
    require("config.ai_panel").open_panel()
  end, { desc = "Open the AI Studio side panel" })
  command_registered = true
end

local function ensure_filetype()
  if vim.fn.has("nvim-0.10") == 1 then
    vim.filetype.add({ extension = { ["ai_panel"] = "ai-panel" } })
  end
end

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

function M.ensure_setup()
  if initialized then
    return true
  end

  local ok, toggleterm_terminal = pcall(require, "toggleterm.terminal")
  if not ok then
    vim.notify("toggleterm.terminal missing", vim.log.levels.ERROR)
    return false
  end

  TerminalClass = toggleterm_terminal.Terminal or toggleterm_terminal
  if not TerminalClass then
    vim.notify("toggleterm Terminal class missing", vim.log.levels.ERROR)
    return false
  end

  build_provider_table()
  ensure_filetype()
  ensure_command()
  initialized = true
  return true
end

local function render_panel()
  if not M.ensure_setup() then
    return
  end

  vim.cmd("botright vsplit")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * PANEL_WIDTH_RATIO))

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

  for _, provider in ipairs(get_provider_defs()) do
    local status
    local stored = M.providers[provider.id]
    if stored and stored.available then
      status = "[ready]"
    else
      local bin = stored and stored.bin or get_binary_from_cmd(provider.cmd)
      status = string.format("[install %s]", bin or provider.cmd)
    end
    lines[#lines + 1] = string.format(" %s  %s  %s", provider.key, provider.label, status)
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

  for _, provider in ipairs(get_provider_defs()) do
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

function M.toggle(id)
  if not M.ensure_setup() then
    return
  end

  local provider = M.providers and M.providers[id]
  if not provider then
    vim.notify("AI provider " .. (id or "") .. " missing", vim.log.levels.WARN)
    return
  end
  if not provider.available then
    local label = provider.def and provider.def.label or id
    local bin = provider.bin or provider.def.cmd
    vim.notify(
      string.format("%s CLI not found (expected `%s`). Install it or override `vim.g.ai_panel_providers`.", label, bin),
      vim.log.levels.WARN
    )
    return
  end

  provider.term:toggle()
end

function M.open_panel()
  if panel_state.win and vim.api.nvim_win_is_valid(panel_state.win) then
    vim.api.nvim_set_current_win(panel_state.win)
    return
  end
  render_panel()
end

function M.setup(force_refresh)
  initialized = false
  if force_refresh then
    close_panel()
  end
  M.ensure_setup()
end

return M
