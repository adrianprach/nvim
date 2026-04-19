-- Custom configuration for NvChad
-- This file is loaded automatically by NvChad

local M = {}

-- Function to get navic context for winbar
function M.navic_txt()
  local navic_available, navic = pcall(require, "nvim-navic")
  if navic_available and navic.is_available() then
    return navic.get_location()
  end
  return ""
end

return M
