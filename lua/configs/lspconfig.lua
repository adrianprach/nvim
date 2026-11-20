-- 1. Load NvChad defaults (Handles UI, statusline, and basic LSP hooks)
require("nvchad.configs.lspconfig").defaults()
local nvlsp = require "nvchad.configs.lspconfig"

-- Project roots for vim.lsp (uses |vim.fs.root()|). Do not use a sync `root_dir(fname)` here:
-- Neovim expects `root_dir(bufnr, on_dir)` and must call `on_dir()`, or no client ever starts.
local root_markers = {
  "compile_commands.json",
  "CMakeLists.txt",
  "meson.build",
  ".clangd",
  "package.json",
  "pyproject.toml",
  "uv.lock",
  ".git",
  ".venv",
  "requirements.txt",
}

-- Base configuration shared by all servers
local base_config = {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  root_markers = root_markers,
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

-- C/C++ (clangd): completion, clang-tidy diagnostics, includes — same role as Pyright+Ruff for Python.
vim.lsp.config("clangd", vim.tbl_deep_extend("force", base_config, {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
    "--cross-file-rename",
  },
  init_options = {
    clangdFileStatus = true,
  },
}))

vim.lsp.config(
  "pyright",
  vim.tbl_deep_extend("force", {
    root_markers = root_markers,
  }, {
    settings = {
      pyright = {
        -- Using Ruff's import organizer
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          -- Ignore all files for analysis to exclusively use Ruff for linting
          ignore = { "*" },
        },
      },
    },
  })
)

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

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_enable_inlay_hints", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil or client.name ~= "ts_ls" then
      return
    end

    if vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
  desc = "LSP: Enable TypeScript inlay hints",
})

-- Simple Web Servers
vim.lsp.config("html", base_config)
vim.lsp.config("cssls", base_config)
vim.lsp.config("jsonls", base_config)
vim.lsp.config("emmet_language_server", base_config)

-- React / React Native / Expo
vim.lsp.config("ts_ls", vim.tbl_deep_extend("force", base_config, {
  init_options = {
    hostInfo = "neovim",
    preferences = {
      includeCompletionsForModuleExports = true,
      includeCompletionsForImportStatements = true,
      includeCompletionsWithInsertText = true,
      includeCompletionsWithSnippetText = true,
      includeAutomaticOptionalChainCompletions = true,
      importModuleSpecifierPreference = "shortest",
      importModuleSpecifierEnding = "minimal",
    },
  },
  settings = {
    typescript = {
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        includeInlayParameterNameHints = "literals",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
    javascript = {
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        includeInlayParameterNameHints = "literals",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
  },
}))
vim.lsp.config("eslint", base_config)
vim.lsp.config("tailwindcss", base_config)

-- Enable once; filetype/root matching decides which clients actually start.
vim.lsp.enable {
  "html",
  "cssls",
  "jsonls",
  "emmet_language_server",
  "ts_ls",
  "eslint",
  "tailwindcss",
  "clangd",
  "ruff",
  "pyright",
}
