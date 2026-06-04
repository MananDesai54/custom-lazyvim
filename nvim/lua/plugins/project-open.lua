-- Open an arbitrary folder as a project: save the current session, change to
-- the chosen directory, and restore that directory's session (or start fresh).
-- The dashboard "Projects" entry only lists already-opened folders, so this
-- adds a way to pick *any* directory from the filesystem (searched recursively).

-- Roots scanned for candidate directories. Override with vim.g.open_project_roots.
local function project_roots()
  if type(vim.g.open_project_roots) == "table" then
    return vim.g.open_project_roots
  end
  local home = vim.loop.os_homedir()
  return {
    home .. "/programming",
    home .. "/content",
    home .. "/work",
    home .. "/Work",
    home,
  }
end

local function open_project(dir)
  dir = vim.fn.fnamemodify(vim.fn.expand(dir), ":p")
  if vim.fn.isdirectory(dir) == 0 then
    vim.notify("Not a directory: " .. dir, vim.log.levels.WARN)
    return
  end

  -- Persist the session we are leaving so it can be restored later.
  local ok, persistence = pcall(require, "persistence")
  if ok then
    pcall(persistence.save)
  end

  -- Wipe current buffers so the new project opens clean, then switch cwd.
  vim.cmd("silent! %bdelete")
  vim.cmd("cd " .. vim.fn.fnameescape(dir))

  -- Restore the session only if one was saved for THIS exact directory
  -- (matched by persistence's cwd[+branch] key). current() must run after
  -- the cd above so it reflects the new cwd and its git branch. If no
  -- session file exists, open clean with the explorer at the project root.
  local restored = false
  if ok then
    local session = persistence.current()
    if session and vim.fn.filereadable(session) == 0 then
      -- No branch-specific session; fall back to the branch-less one.
      session = persistence.current({ branch = false })
    end
    if session and vim.fn.filereadable(session) == 1 then
      pcall(persistence.load)
      restored = true
    end
  end

  vim.schedule(function()
    if not restored or #vim.fn.getbufinfo({ buflisted = 1 }) == 0 then
      pcall(function()
        require("neo-tree.command").execute({
          action = "show",
          source = "filesystem",
          position = "left",
          dir = dir,
        })
      end)
    end
    vim.notify((restored and "Restored session: " or "Opened project: ") .. dir)
  end)
end

-- Build the `fd` command that lists directories recursively under the roots,
-- newest-friendly order, dotfolders included, noise excluded.
local function fd_dir_command()
  local fd = vim.fn.executable("fd") == 1 and "fd" or (vim.fn.executable("fdfind") == 1 and "fdfind" or nil)
  if not fd then
    return nil
  end
  local cmd = {
    fd,
    "--type", "d",
    "--hidden",
    "--follow",
    "--exclude", ".git",
    "--exclude", "node_modules",
    "--exclude", ".cache",
    "--max-depth", "4",
    ".",
  }
  for _, root in ipairs(project_roots()) do
    if vim.fn.isdirectory(vim.fn.expand(root)) == 1 then
      table.insert(cmd, vim.fn.expand(root))
    end
  end
  return cmd
end

local function pick_directory()
  local ok_tb, builtin = pcall(require, "telescope.builtin")
  local cmd = fd_dir_command()

  if ok_tb and cmd then
    local ok_pick = pcall(function()
      local actions = require("telescope.actions")
      local state = require("telescope.actions.state")
      builtin.find_files({
        prompt_title = "Open Project Folder",
        find_command = cmd,
        path_display = { "absolute" },
        attach_mappings = function(_, map)
          local function open(bufnr)
            local entry = state.get_selected_entry()
            actions.close(bufnr)
            if entry then
              open_project(entry.path or entry.value)
            end
          end
          map("i", "<CR>", open)
          map("n", "<CR>", open)
          return true
        end,
      })
    end)
    if ok_pick then
      return
    end
  end

  -- Fallback: plain input prompt with path completion.
  vim.ui.input({ prompt = "Open project folder: ", completion = "dir" }, function(input)
    if input and input ~= "" then
      open_project(input)
    end
  end)
end

vim.api.nvim_create_user_command("OpenProject", function(opts)
  if opts.args ~= "" then
    open_project(opts.args)
  else
    pick_directory()
  end
end, { nargs = "?", complete = "dir", desc = "Open a folder as a project (new session)" })

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>fo", "<cmd>OpenProject<cr>", desc = "Open project folder (new session)" },
    },
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.dashboard = opts.dashboard or {}
      opts.dashboard.preset = opts.dashboard.preset or {}
      local keys = opts.dashboard.preset.keys
      if type(keys) == "table" then
        table.insert(keys, 3, {
          icon = " ",
          key = "o",
          desc = "Open Folder",
          action = ":OpenProject",
        })
      end
    end,
  },
}
