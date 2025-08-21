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
                            reviews = "~/Documents/notes/0. Reviews/",
                            projects = "~/Documents/notes/1. Projects/",
                            areas = "~/Documents/notes/2. Areas/",
                            resources = "~/Documents/notes/3. Resources/",
                        },
                        default_workspace = "notes",
                    },

                },
                ["core.journal"] = {
                    config = {
                        journal_folder = "0.4. Daily",
                        strategy = "flat",
                        workspace = "reviews"
                    }
                }
            },
        }

        vim.wo.foldlevel = 99
        vim.wo.conceallevel = 2
    end,
}
