return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.config").setup({
      ensure_installed = { 
        "lua", 
        "javascript", 
        "python", 
        "json", 
        "bash" 
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}

-- return {
--   "nvim-treesitter/nvim-treesitter",
--   build = ":TSUpdate",
--   event = { "BufReadPost", "BufNewFile" },
--   config = function()
--     local ok, configs = pcall(require, "nvim-treesitter.configs")
--     if not ok then
--       return
--     end
--
--     configs.setup({
--       ensure_installed = {
--         "lua",
--         "javascript",
--         "typescript",
--         "python",
--         "json",
--         "bash",
--       },
--       highlight = { enable = true },
--       indent = { enable = true },
--     })
--   end
-- }
