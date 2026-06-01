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
      }, opts.filesystem or {})

      opts.buffers = vim.tbl_deep_extend("force", {
        follow_current_file = { enabled = true }
      }, opts.buffers or {})

      opts.sources = opts.sources or { "filesystem", "buffers", "git_status" }
    end,
  },
}
