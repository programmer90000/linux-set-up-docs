vim.opt.rtp:prepend(vim.fn.expand("~/.config/nvim/plugins/nvim-treesitter/"))

require("nvim-treesitter").setup {}
