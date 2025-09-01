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
                            reviews = "~/Documents/notes/0.reviews/",
                            projects = "~/Documents/notes/1.projects/",
                            areas = "~/Documents/notes/2.areas/",
                            resources = "~/Documents/notes/3.resources/",
                            moc = "~/Documents/notes/3.resources/3.2.MOC/"
                        },
                        default_workspace = "notes",
                    },

                },
                ["core.journal"] = {
                    config = {
                        journal_folder = "0.4.daily",
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
