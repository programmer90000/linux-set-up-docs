vim.opt.rtp:prepend(vim.fn.expand("~/.config/nvim/plugins/render-markdown/"))

require("render-markdown").setup {}
