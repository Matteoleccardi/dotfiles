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
      -- "sqls",  -- this need Go installed on the machine, so we use the Node.js version of this server
      "sqlls"
    }

    -- 2.1 setup LSP - autocompletion interface (see completions.lua)
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- 3. Ensure mason automatically keeps these binaries installed
    require("mason-lspconfig").setup({
      ensure_installed = servers,
    })


    -- THE MODERN 0.11 WAY (No deprecation warnings)
    for _, server_name in ipairs(servers) do
      vim.lsp.config(server_name, {
        capabilities = capabilities,
      })
      vim.lsp.enable(server_name)
    end 

    -- 5. Bind interactive keys when any LSP attaches
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { buffer = args.buf }

        -- Manual override keys (Shift+K for documentation)
        vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)


        -- Note: Neovim 0.11 now provides built-in default bindings:
        -- 'grn' -> Rename variable (Replaces <leader>rn)
        -- 'grr' -> View references
        -- 'gra' -> Code actions
      end,
    })
  end,
}
