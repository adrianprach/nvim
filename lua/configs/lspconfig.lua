-- 1. Load NvChad defaults (Handles UI, statusline, and basic LSP hooks)
require("nvchad.configs.lspconfig").defaults()
local nvlsp = require "nvchad.configs.lspconfig"

-- Robust root discovery function for macOS (finds uv, git, or cmake projects)
local function get_root(fname)
  local root_files = { '.git', 'pyproject.toml', 'uv.lock', 'CMakeLists.txt', '.venv', 'requirements.txt' }
  local found = vim.fs.find(root_files, { upward = true, path = fname })[1]
  return found and vim.fs.dirname(found) or vim.uv.cwd()
end

-- Base configuration shared by all servers
local base_config = {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  root_dir = get_root,
}

-- 2. FIX: Disable Ruff's empty hover so Pyright can show documentation
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client and client.name == 'ruff' then
--       client.server_capabilities.hoverProvider = false
--     end
--   end,
-- })

-- C++ (clangd)
vim.lsp.config("clangd", vim.tbl_deep_extend("force", base_config, {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
}))

vim.lsp.config("pyright", {
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { '*' },
      },
    },
  },
})

-- vim.lsp.config('ruff', {
--   init_options = {
--     settings = {
--     }
--   }
-- })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})

-- Simple Web Servers
vim.lsp.config("html", base_config)
vim.lsp.config("cssls", base_config)

-- 4. Enable All Servers
local servers = { "html", "cssls", "clangd", "ruff", "pyright" }
-- vim.lsp.enable(servers)

-- 5. Force-start LSPs when opening a file (Ensures attachment on macOS)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "cpp", "c", "html", "css", "py" },
  callback = function()
    vim.lsp.enable(servers)
  end,
})
