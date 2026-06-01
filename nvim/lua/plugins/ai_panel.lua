return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>ai", function() require("config.ai_panel").open_panel() end, desc = "AI Studio" },
      { "<leader>ac", function() require("config.ai_panel").toggle("claude") end, desc = "Claude Code" },
      { "<leader>ao", function() require("config.ai_panel").toggle("opencode") end, desc = "OpenCode" },
      { "<leader>ax", function() require("config.ai_panel").toggle("codex") end, desc = "Codex" },
      { "<leader>ap", function() require("config.ai_panel").toggle("pi") end, desc = "Pi" },
      { "<leader>ag", function() require("config.ai_panel").toggle("gemini") end, desc = "Gemini CLI" },
    },
    opts = {
      shade_terminals = false,
      start_in_insert = true,
      persist_mode = false,
      direction = "vertical",
      size = function(term)
        if term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.38)
        else
          return 12
        end
      end,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      require("config.ai_panel").setup()
    end,
  },
}
