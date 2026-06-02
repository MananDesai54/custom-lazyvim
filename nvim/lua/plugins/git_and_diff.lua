return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview (HEAD)" },
      { "<leader>gD", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Diffview vs origin/main" },
      { "<leader>gF", "<cmd>DiffviewFocusFiles<cr>", desc = "Diffview focus files" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = {
          layout = "diff4_mixed",
          disable_diagnostics = true,
        },
      },
      file_panel = {
        win_config = { position = "left", width = 38 },
      },
      hooks = {
        diff_buf_read = function()
          vim.opt_local.wrap = false
          vim.opt_local.cursorline = true
        end,
      },
    },
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "GBrowse" },
    keys = {
      { "<leader>gg", "<cmd>Git<cr>", desc = "Fugitive status" },
      { "<leader>gB", "<cmd>GBrowse<cr>", desc = "Open in remote" },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      opts.current_line_blame = true
      opts.current_line_blame_opts = {
        delay = 80,
        ignore_whitespace = false,
        virt_text_pos = "right_align",
      }
      opts.current_line_blame_formatter = "  <author>, <author_time:%R> · <summary>"
      opts.signs = vim.tbl_deep_extend("force", opts.signs or {}, {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
      })
      opts.preview_config = {
        border = "rounded",
        style = "minimal",
      }
      opts.attach_to_untracked = true
      return opts
    end,
  },

  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "BufReadPre",
    opts = {
      default_mappings = true,
      disable_diagnostics = true,
      highlights = {
        current = "DiffText",
        incoming = "DiffAdd",
      },
    },
  },
}
