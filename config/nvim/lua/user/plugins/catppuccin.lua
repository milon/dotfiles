-- Catpucchin theme

return {
  "catppuccin/nvim",

  name = "catppuccin",

  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      }
    })

    vim.cmd.colorscheme("catppuccin")
  end,
}