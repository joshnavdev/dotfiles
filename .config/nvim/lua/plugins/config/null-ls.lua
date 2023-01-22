local status, null_ls = pcall(require, "null-ls")
if (not status) then return end

null_ls.setup({
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_command [[augroup Format]]
      vim.api.nvim_command [[autocmd! * <buffer>]]
      vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
      vim.api.nvim_command [[augroup END]]
    end

    if client.server_capabilities.documentRangeFormattingProvider then
      vim.cmd("xnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.range_formatting({})<CR>")
    end
  end,
  debug = false,
  sources = {
    null_ls.builtins.diagnostics.eslint_d.with({
      diagnostics_format = "[#{c}] #{m} (#{s})"
    }),
    null_ls.builtins.diagnostics.jsonlint,
    null_ls.builtins.diagnostics.stylelint,
    null_ls.builtins.formatting.stylelint,
    null_ls.builtins.formatting.prettierd,
  }
})
