require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- LSP symbol pickers (Telescope; requires an active LSP for the buffer/filetype)
-- dynamic workspace symbols: fuzzy search symbols across the project (workspaceSymbol)
map(
  "n",
  "<leader>fs",
  "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
  { desc = "telescope LSP workspace symbols" }
)
-- document symbols: outline / symbols in this buffer (documentSymbol — same family as nvim-navic)
map(
  "n",
  "<leader>fS",
  "<cmd>Telescope lsp_document_symbols<CR>",
  { desc = "telescope LSP document symbols" }
)

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
