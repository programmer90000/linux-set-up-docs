vim.opt.rtp:append(vim.fn.stdpath("config") .. "/plugins/nvim-dap")
vim.opt.rtp:append(vim.fn.stdpath("config") .. "/plugins/nvim-dap-ui")
vim.opt.rtp:append(vim.fn.stdpath("config") .. "/plugins/nvim-nio")

require("dap").adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "node",
        args = {
            vim.fn.stdpath("config") .. "/plugins/vscode-js-debug/dist/src/dapDebugServer.js",
            "${port}",
        },
    },
}

require("dap").configurations.javascript = {
    {
        type = "pwa-node",
        request = "launch",
        name = "Launch current file",
        program = "${file}",
        cwd = "${workspaceFolder}",
    },
}

local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

-- Automatically open/close dapui on debug events
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

