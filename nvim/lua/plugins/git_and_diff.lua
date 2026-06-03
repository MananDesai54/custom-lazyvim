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
        delay = 100,
        ignore_whitespace = false,
        virt_text_pos = "eol",
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
    init = function()
      -- git-conflict.nvim (commit 4bbfdd9, 2024) still calls the positional
      -- vim.diagnostic.disable(bufnr) / enable(bufnr) API that was removed in
      -- Neovim 0.12, which throws inside its autocmd. Shim the old signatures
      -- onto the new ones so disable_diagnostics keeps working without crashing.
      if vim.fn.has("nvim-0.12") == 1 then
        local d = vim.diagnostic
        local orig_enable = d.enable
        -- Force the old positional signatures onto the new API. On 0.12 the
        -- legacy disable(bufnr) stub runs vim.validate and throws, so we
        -- replace it outright rather than only when it is missing.
        d.disable = function(bufnr)
          orig_enable(false, { bufnr = bufnr })
        end
        d.enable = function(arg, opts)
          if type(arg) == "number" then
            return orig_enable(true, { bufnr = arg })
          end
          return orig_enable(arg, opts)
        end
      end
    end,
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
