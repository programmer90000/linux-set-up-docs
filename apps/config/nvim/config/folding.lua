vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldminlines = 0

-- Automatically start Treesitter and set fold expression per buffer
vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
    group = vim.api.nvim_create_augroup("TreesitterFolding", { clear = true }),
    callback = function(args)
    pcall(vim.treesitter.start, args.buf)
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
})
