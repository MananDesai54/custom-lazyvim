return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        -- Include dotfiles and gitignored files in file/grep pickers
        -- (<leader><leader>, <leader>ff, <leader>/, etc.), but keep the
        -- noisy .git directory out.
        hidden = true,
        ignored = true,
        exclude = { ".git" },
        sources = {
          files = { hidden = true, ignored = true },
          grep = { hidden = true, ignored = true },
          explorer = { hidden = true, ignored = true },
        },
      },
    },
  },
}
