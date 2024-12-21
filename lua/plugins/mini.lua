return {
    {
        "echasnovski/mini.nvim",
        config = function()
            local status_line = require "mini.statusline"
            status_line.setup({use_icons = true})
        end
    }
}
