-- A set of programming language parsers, so that nvim can understands your code text as a tree of 
-- programming language-specific constructs (field, method, function, keyword ...), so it can use 
-- those information to do folding, highlighting, text-object manipulating 
-- (delete a function's content, change a class' content, ...), and much more.
-- Before treesitter, your code text are just ... text, nvim relies on a bunch of regexes to 
-- heuristically highlight your tokens.
-- Think of it as better code highlighting

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- CHANGED: 'config' instead of 'configs' to match modern nvim-treesitter
    require("nvim-treesitter.config").setup({
      ensure_installed = { "python", "cpp", "javascript", "typescript", "markdown", "latex", "lua", "bash" },
      highlight = {
        enable = true,              -- False will disable the whole extension
        additional_vim_regex_highlighting = false,
      },
    })
  end,
}
