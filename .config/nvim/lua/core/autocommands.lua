-- [[ Basic Autocommands ]]
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Same autocommand written with a Lua function instead
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.c", "*.h"},
  callback = function() print("Entering a C or C++ file") end,
})

-- User event triggered by MyPlugin
vim.api.nvim_create_autocmd("User", {
  pattern = "MyPlugin",
  callback = function() print("My Plugin Works!") end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function(args)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
  end
})

-- set autocommand for current buffer
vim.api.nvim_create_autocmd("CursorHold", {
  buffer = 0,
  callback = function() print("hold") end,
})

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
-- vim.opt.clipboard = "unnamedplus"
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.opt.clipboard = 'unnamedplus'
  end,
})

