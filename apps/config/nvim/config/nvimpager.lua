vim.opt.rtp:prepend(vim.fn.expand("~/.config/nvim/plugins/nvimpager/"))

require("nvimpager").setup {}
