return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    init = function()
      local function open_neo_tree()
        if package.loaded["neo-tree.command"] then
          require("neo-tree.command").execute({
            action = "show",
            source = "filesystem",
            position = "left",
          })
        else
          vim.schedule(function()
            pcall(require, "neo-tree.command")
            if package.loaded["neo-tree.command"] then
              require("neo-tree.command").execute({
                action = "show",
                source = "filesystem",
                position = "left",
              })
            end
          end)
        end
      end

      local function open_if_applicable()
        if vim.bo.filetype == "neo-tree" then
          return
        end
        open_neo_tree()
      end

      local argc = vim.fn.argc()
      if argc == 0 then
        vim.api.nvim_create_autocmd("User", {
          pattern = "VeryLazy",
          once = true,
          callback = open_if_applicable,
        })
      else
        local argv = vim.fn.argv()
        local has_directory = false
        for _, arg in ipairs(argv) do
          if vim.fn.isdirectory(arg) == 1 then
            has_directory = true
            break
          end
        end
        if has_directory then
          vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            once = true,
            callback = open_if_applicable,
          })
        end
      end
    end,
    opts = function(_, opts)
      opts.window = opts.window or {}
      opts.window.position = "left"
      opts.window.width = 32
      opts.window.popup = { size = { height = '80%', width = 80 } }

      opts.filesystem = vim.tbl_deep_extend("force", {
        follow_current_file = { enabled = true, leave_dirs_open = false },
        group_empty_dirs = true,
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true, -- show filtered items (dotfiles) dimmed instead of hidden
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      }, opts.filesystem or {})

      opts.buffers = vim.tbl_deep_extend("force", {
        follow_current_file = { enabled = true }
      }, opts.buffers or {})

      opts.sources = opts.sources or { "filesystem", "buffers", "git_status" }
    end,
  },

  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.presets = opts.presets or {}
      opts.presets.long_message_to_split = true
      opts.cmdline = opts.cmdline or {}
      opts.cmdline.view = "cmdline_popup" -- floating command line instead of bottom row
      opts.notify = opts.notify or {}
      opts.notify.view = "notify"
      opts.notify.replace = false
    end,
  },
}
