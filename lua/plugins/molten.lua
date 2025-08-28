return {
  "benlubas/molten-nvim",
  dependencies = { "3rd/image.nvim" },
  build = ":UpdateRemotePlugins",
  ft = { "python", "r", "markdown", "quarto", "julia" },
  config = function()
    vim.g.molten_auto_open_output = true
    vim.g.molten_output_win_border = "rounded"
    vim.g.molten_image_provider = "image.nvim"
    vim.keymap.set("n", "<leader>mm", "<cmd>MoltenEvaluateLine<cr>", { desc = "Molten: run line" })
    vim.keymap.set("v", "<leader>mm", ":<C-u>MoltenEvaluateVisual<cr>", { desc = "Molten: run selection" })
    vim.keymap.set("n", "<leader>mc", "<cmd>MoltenReevaluateCell<cr>", { desc = "Molten: run cell" })
    vim.keymap.set("n", "<leader>mk", "<cmd>MoltenInit<cr>", { desc = "Molten: attach/start kernel" })
  end,
}
