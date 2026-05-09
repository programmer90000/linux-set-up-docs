vim.opt.rtp:prepend("/home/abdul/.config/nvim/mason/")
vim.opt.rtp:prepend("/home/abdul/.config/nvim/lualine/")
vim.opt.rtp:prepend("/home/abdul/.config/nvim/nvim-surround")
vim.opt.rtp:prepend("/home/abdul/.config/nvim/nvim-treesitter")
vim.opt.rtp:prepend("/home/abdul/.config/nvim/plenary")
vim.opt.rtp:prepend("/home/abdul/.config/nvim/nui")
vim.opt.rtp:prepend("/home/abdul/.config/nvim/nvim-web-devicons")
vim.opt.rtp:prepend("/home/abdul/.config/nvim/neo-tree")

vim.autoindent = true
vim.autoread = true
vim.autowrite = false
vim.autowriteall = false
vim.backspace = "indent,eol,start"
vim.backup = false
vim.breakindent = true
vim.o.confirm = true
vim.o.copyindent = true
vim.o.equalalways = false
vim.o.errorbells = true
vim.opt.expandtab = true
vim.o.fileignorecase = true
vim.o.hlsearch = true
vim.o.infercase = false
vim.o.laststatus = 2
vim.o.mouse = "a"
vim.o.mousefocus = false
vim.o.mousehide = false
vim.o.mousemodel = "popup_setpos"
vim.opt.number = true
vim.o.preserveindent = true
vim.opt.relativenumber = false
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.o.mousescroll = "vert=3"
vim.o.mousetime = 500
vim.o.numberwidth = 1
vim.o.preserveindent = false
vim.o.pumblend = 30
vim.o.pumborder = true
vim.o.ruler = true
vim.o.rulerformat = "Line:%l  Col:%c  Virtual:%v  Char:0x%B  Pos:%o  %p%%  %L lines"

vim.cmd("colorscheme colour-scheme")

require("mason").setup()
require("lualine").setup()
require("nvim-surround").setup()
require("nvim-treesitter").setup()
require("neo-tree").setup {}
