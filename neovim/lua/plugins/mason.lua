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
