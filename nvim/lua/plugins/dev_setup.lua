return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- LSP servers
        "typescript-language-server",
        "eslint-lsp",
        "tailwindcss-language-server",
        "astro-language-server",
        "css-lsp",
        "html-lsp",
        "json-lsp",
        "yaml-language-server",
        "graphql-language-service-cli",
        "prisma-language-server",
        "bash-language-server",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "emmet-language-server",
        "marksman",
        "lua-language-server",
        -- Formatters & linters
        "prettierd",
        "eslint_d",
        "stylua",
        "shfmt",
      })
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "ts_ls",
        "eslint",
        "tailwindcss",
        "astro",
        "cssls",
        "html",
        "jsonls",
        "yamlls",
        "graphql",
        "prismals",
        "bashls",
        "dockerls",
        "docker_compose_language_service",
        "emmet_ls",
        "marksman",
        "lua_ls",
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local js_family = { "prettierd", "prettier", "biome" }
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        javascript = js_family,
        javascriptreact = js_family,
        typescript = js_family,
        typescriptreact = js_family,
        vue = js_family,
        svelte = js_family,
        json = js_family,
        jsonc = js_family,
        yaml = js_family,
        html = js_family,
        css = js_family,
        scss = js_family,
        less = js_family,
        astro = js_family,
        markdown = { "prettierd", "prettier" },
        graphql = { "prettierd", "prettier" },
        lua = { "stylua" },
        sh = { "shfmt" },
      })
      opts.format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 1000, lsp_fallback = true }
      end
    end,
  },

  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft or {}, {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        vue = { "eslint_d" },
        svelte = { "eslint_d" },
      })
      local eslint_configs = {
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc.mjs",
        ".eslintrc.json",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        "eslint.config.js",
        "eslint.config.mjs",
        "eslint.config.ts",
      }

      opts.linters = vim.tbl_deep_extend("force", opts.linters or {}, {
        eslint_d = {
          condition = function(ctx)
            local filename = ctx.filename
            if not filename or filename == "" then
              if ctx.buf and vim.api.nvim_buf_is_valid(ctx.buf) then
                filename = vim.api.nvim_buf_get_name(ctx.buf)
              end
            end
            if not filename or filename == "" then
              return false
            end
            local dir = vim.fn.fnamemodify(filename, ":p:h")
            return vim.fs.find(eslint_configs, { path = dir, upward = true })[1] ~= nil
          end,
        },
      })
    end,
  },
}
