-- automatically inserts matching pairs of characters—such as brackets, parentheses, and quotes—while you type

return {
  "echasnovski/mini.pairs",
  event = "VeryLazy",
  config = function()
    require("mini.pairs").setup()
  end,
}
