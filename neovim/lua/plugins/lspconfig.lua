-- ~/.config/nvim/lua/plugins/lsp.lua

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- 1. Initialize Mason to handle downloads
    require("mason").setup()

    -- 2. Define the expanded list of servers including your web and SQL tools
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

    -- 4. Correctly boot and apply default profiles via lspconfig hook
    local lspconfig = require("lspconfig")
    for _, server_name in ipairs(servers) do
      -- .setup() automatically grabs correct default cmds, filetypes, and root markers
      lspconfig[server_name].setup({})
    end

    -- 5. Bind interactive keys the second any LSP hooks up to a file
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { buffer = args.buf }

        -- Press 'K' (Shift+k) in normal mode to see documentation popups
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        -- Press 'gd' to jump straight to where a function/variable is defined
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

        -- Press '<leader>rn' (Space + r + n) to rename a variable across the whole project
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      end,
    })
  end,
}
