vim.opt.rtp:prepend(vim.fn.expand("~/.config/nvim/plugins/conform/"))

require("conform").setup({
    formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
    },
})

