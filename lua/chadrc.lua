-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
        theme = "carbonfox",

        -- hl_override = {
        --     Comment = { italic = true },
        --     ["@comment"] = { italic = true },
        -- },
}

-- M.nvdash = { load_on_startup = true }

-- Add winbar configuration to show function context
M.ui = {
        statusline = {
                theme = "default", -- default/vscode/vscode_colored
                order = nil,
                modules = nil,
        },
        winbar = {
                enabled = true,
                file_path = function()
                        local navic = require("nvim-navic")
                        if navic.is_available() then
                                return navic.get_location()
                        end
                        return ""
                end,
        },
}

return M
