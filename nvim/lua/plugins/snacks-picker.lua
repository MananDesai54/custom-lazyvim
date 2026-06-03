return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        -- Include dotfiles but skip anything ignored by git/.gitignore so the
        -- pickers stay clean (still keep .git itself filtered out).
        hidden = true,
        ignored = false,
        exclude = { ".git" },
        sources = {
          files = { hidden = true, ignored = false },
          grep = { hidden = true, ignored = false },
          explorer = { hidden = true, ignored = false },
        },
      },
    },
  },
}
