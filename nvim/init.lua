

-- Addition of lazy vim to manage plugins
vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")

-- Loading of plugins from lua/plugins/init.lua
require("lazy").setup(require("plugins"))

require("config.options")
