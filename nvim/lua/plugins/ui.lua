return {
  {
    "nvim-neo-tree/neo-tree.nvim",
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
