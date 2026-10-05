vim.opt.list = true
vim.opt.listchars = {
    tab = '» ',
    trail = '•',
    nbsp = '␣',
}

-- Highlight consecutive spaces (2 or more) and trailing whitespace
vim.api.nvim_create_autocmd({"BufEnter", "WinEnter"}, {
    pattern = "*",
    callback = function()
        -- Clear previous matches in the current window to prevent duplicates
        vim.fn.clearmatches()
        -- Highlight 2 or more consecutive spaces after non-whitespace text
        vim.fn.matchadd("ExtraWhitespace", "\\S\\zs \\{2,}")
      -- Highlight trailing whitespace on lines that contain text
      vim.fn.matchadd("ExtraWhitespace", "\\S.*\\s\\+$")
  end,
})

-- Set background/foreground color for the highlight
vim.api.nvim_set_hl(0, "ExtraWhitespace", {bg = "#e06c75", fg = "#ffffff"})
