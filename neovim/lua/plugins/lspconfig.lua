return {
  "neovim/nvim-lspconfig",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    -- List the exact server tokens managed by Mason
    local servers = { "pyright", "clangd", "ts_ls", "texlab", "bashls" }

    -- FIXED: Added 'in ipairs(servers)' here so Lua can iterate correctly
    for _, server_name in ipairs(servers) do
      -- 1. vim.lsp.config registers or extends static configurations
      -- Passing an empty table {} relies entirely on the defaults provided by nvim-lspconfig
      vim.lsp.config(server_name, {})

      -- 2. vim.lsp.enable automatically starts the LSP when matching files are opened
      vim.lsp.enable(server_name)
    end
  end,
}
