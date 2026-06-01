-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.o.updatetime = 300

local hover_group = vim.api.nvim_create_augroup("lazyvim_cursor_hover_docs", { clear = true })

local function buf_has_hover(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client.server_capabilities and client.server_capabilities.hoverProvider then
      return true
    end
  end
  return false
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = hover_group,
  callback = function(args)
    local buf = args.buf
    if vim.bo[buf].buftype ~= "" then
      return
    end

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = hover_group,
      buffer = buf,
      callback = function()
        if vim.g.disable_auto_hover or vim.b[buf].disable_auto_hover then
          return
        end

        if not buf_has_hover(buf) then
          return
        end

        vim.diagnostic.open_float(nil, {
          focusable = false,
          border = "rounded",
          scope = "cursor",
          source = "if_many",
        })

        vim.defer_fn(function()
          if vim.api.nvim_get_current_buf() == buf and vim.api.nvim_buf_is_valid(buf) then
            pcall(vim.lsp.buf.hover)
          end
        end, 60)
      end,
    })
  end,
})
