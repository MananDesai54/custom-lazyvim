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

-- Returns true if a hover result actually carries content. Empty results are
-- what produce the "No information available" notify spam, so we filter them
-- out and only open the float when there is something to show.
local function hover_has_content(result)
  if not result or not result.contents then
    return false
  end
  local c = result.contents
  if type(c) == "string" then
    return c ~= ""
  end
  if type(c) == "table" then
    if c.value ~= nil then
      return c.value ~= ""
    end
    return #c > 0
  end
  return false
end

-- IDE-style hover: request docs/signature under the cursor and pop a float only
-- when the language server returns content. Never notifies on empty.
local function cursor_hover(bufnr)
  local params = vim.lsp.util.make_position_params(0, "utf-16")
  vim.lsp.buf_request(bufnr, "textDocument/hover", params, function(_, result, ctx)
    if not vim.api.nvim_buf_is_valid(bufnr) or vim.api.nvim_get_current_buf() ~= bufnr then
      return
    end
    if not hover_has_content(result) then
      return
    end
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local markdown = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    if vim.tbl_isempty(markdown) then
      return
    end
    vim.lsp.util.open_floating_preview(markdown, "markdown", {
      border = "rounded",
      focusable = false,
      focus = false,
      close_events = { "CursorMoved", "CursorMovedI", "InsertCharPre" },
    })
  end)
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

        vim.diagnostic.open_float(nil, {
          focusable = false,
          border = "rounded",
          scope = "cursor",
          source = "if_many",
        })

        cursor_hover(buf)
      end,
    })
  end,
})
