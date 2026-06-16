-- Mason manages backend tools that power your Neovim configuration. It primarily focuses on:
-- - LSP servers: Provide advanced code completion, error checking, and navigation 
--   (e.g., for Python, TypeScript, or Go).
-- - Linters: Scan your code for bugs and bad practices.
-- - Formatters: Automatically clean up and format your code.
-- - DAP servers: Tools for debugging your code step-by-step.

return {
  "williamboman/mason.nvim",
  dependencies = { "williamboman/mason-lspconfig.nvim" },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      -- Auto-downloads language servers for Python, C++, JS/TS, and LaTeX
      ensure_installed = { "pyright", "clangd", "ts_ls", "texlab", "bashls" },
    })
  end,
}
