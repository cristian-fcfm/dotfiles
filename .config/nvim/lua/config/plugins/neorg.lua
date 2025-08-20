return {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*", -- Pin Neorg to the latest stable release
    config = function()
        require("neorg").setup {
            load = {
                ["core.defaults"] = {
                    config = {
                        disable = {
                            "core.keybinds"
                        }
                    }
                },
                ["core.concealer"] = {},
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            notes = "~/Documents/notes/",
                        },
                        default_workspace = "notes",
                    },
                },
            },
        }

        vim.wo.foldlevel = 99
        vim.wo.conceallevel = 2
    end,
}
