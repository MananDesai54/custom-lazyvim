return {
  {
    "ThePrimeagen/vim-be-good",
    cmd = { "VimBeGood" },
    keys = {
      { "<leader>tv", "<cmd>VimBeGood<cr>", desc = "Vim practice drills" },
    },
    init = function()
      vim.g.vim_be_good_log_file = vim.fn.stdpath("data") .. "/vim-be-good.log"
    end,
  },
}
