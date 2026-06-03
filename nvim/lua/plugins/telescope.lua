return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.defaults = opts.defaults or {}

      -- Make ripgrep (live_grep / grep_string) search hidden files but respect
      -- .gitignore (keeps results focused) while still skipping the noisy .git directory.
      opts.defaults.vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!**/.git/*",
      }

      opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
        find_files = {
          hidden = true,
          no_ignore = false,
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--glob=!**/.git/*",
          },
        },
        live_grep = {
          additional_args = { "--hidden", "--glob=!**/.git/*" },
        },
        grep_string = {
          additional_args = { "--hidden", "--glob=!**/.git/*" },
        },
      })
    end,
  },
}
