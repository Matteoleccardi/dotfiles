-- ~/.config/nvim/lua/plugins/lsp.lua

return {
  -- We keep this as a dependency so Neovim has access to the community server templates
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- 1. Initialize Mason to download the binaries
    require("mason").setup()

    -- 2. Define your languages (including the web and SQL tools)
    local servers = { 
      "pyright", 
      "clangd", 
      "texlab", 
      "bashls",
      "html",    
      "cssls",   
      "ts_ls",   
      "sqls",    
    }

    -- 3. Ensure mason automatically keeps these binaries installed
    require("mason-lspconfig").setup({
      ensure_installed = servers,
    })

    -- 4. THE MODERN WAY: Register and auto-activate servers natively
    for _, server_name in ipairs(servers) do
      -- vim.lsp.config initializes or overrides the static configuration
      -- An empty table {} gracefully inherits the upstream defaults from nvim-lspconfig
      vim.lsp.config(server_name, {})
      
      -- vim.lsp.enable hooks into the FileType autocommands to start the server
      vim.lsp.enable(server_name)
    end

    -- 5. Bind interactive keys when any LSP attaches
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { buffer = args.buf }

        -- Manual override keys (Shift+K for documentation)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

        -- Note: Neovim 0.11 now provides built-in default bindings:
        -- 'grn' -> Rename variable (Replaces <leader>rn)
        -- 'grr' -> View references
        -- 'gra' -> Code actions
      end,
    })
  end,
}
