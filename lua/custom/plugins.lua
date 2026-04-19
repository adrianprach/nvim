-- Custom plugins for NvChad
-- Add any additional plugins here

return {
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
    end,
    config = function()
      local navic = require("nvim-navic")
      navic.setup({
        icons = {
          File = " ",
          Module = " ",
          Namespace = " ",
          Package = " ",
          Class = " ",
          Method = " ",
          Property = " ",
          Field = " ",
          Constructor = " ",
          Enum = " ",
          Interface = " ",
          Function = " ",
          Variable = " ",
          Constant = " ",
          String = " ",
          Number = " ",
          Boolean = " ",
          Array = " ",
          Object = " ",
          Key = " ",
          Null = " ",
          EnumMember = " ",
          Struct = " ",
          Event = " ",
          Operator = " ",
          TypeParameter = " ",
        },
        highlight = true,
        separator = " > ",
        depth_limit = 0,
        depth_limit_indicator = "..",
        safe_output = true,
        lazy_update_context = false,
        click = true,
        lsp = {
          auto_attach = true,
          preference = nil,
        },
      })
    end,
  },
}
