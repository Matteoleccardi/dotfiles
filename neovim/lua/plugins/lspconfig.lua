return {
  "neovim/nvim-lspconfig",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    local lspconfig = require("lspconfig")
    
    -- Tell Neovim how to activate each server once Mason installs it
    local servers = { "pyright", "clangd", "ts_ls", "texlab" }
    for _, server in ipairs(servers) do
      lspconfig[server].setup({})
    end
  end,
}
