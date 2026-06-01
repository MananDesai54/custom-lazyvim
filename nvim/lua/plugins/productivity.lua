return {
  -- Browser-based markdown preview
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "Markdown Preview" },
      { "<leader>mP", "<cmd>MarkdownPreviewStop<cr>", desc = "Stop Markdown Preview" },
      { "<leader>mt", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown Preview" },
    },
    init = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = "127.0.0.1"
      vim.g.mkdp_port = '8889'
      vim.g.mkdp_browser = ''
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_combine_preview = 1
      vim.g.mkdp_theme = 'dark'
    end,
  },

  -- VSCode/Cursor-style command palette
  {
    "mrjones2014/legendary.nvim",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      { "kkharji/sqlite.lua", enabled = function()
        return vim.fn.has("linux") == 1 or vim.fn.has("mac") == 1
      end },
    },
    cmd = "Legendary",
    keys = {
      { "<D-S-p>", "<cmd>Legendary<cr>", desc = "Command Palette" },
      { "<leader>P", "<cmd>Legendary<cr>", desc = "Command Palette" },
    },
    opts = {
      select_prompt = "Command Palette",
      most_recent_item_at_top = true,
      col_separator_char = "│",
      which_key = {
        auto_register = true,
      },
      extensions = {
        lazy_nvim = true,
        git = true,
      },
    },
  },
}
