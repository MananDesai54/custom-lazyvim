return {
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitFilter" },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit (floating)" },
      { "<leader>lG", "<cmd>LazyGitFilter<cr>", desc = "LazyGit grep" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    init = function()
      vim.g.lazygit_floating_window_use_plenary = 1
      vim.g.lazygit_floating_window_winblend = 12
      vim.g.lazygit_use_neovim_remote = 1
    end,
  },
}
