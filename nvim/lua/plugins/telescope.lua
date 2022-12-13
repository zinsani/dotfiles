local status, telescope = pcall(require, "telescope")
if (not status) then return end

-- You don't need to set any of these options.
-- IMPORTANT!: this is only a showcase of how you can set default options!
telescope.setup {
	extensions = {
		file_browser = {
			theme = "ivy",
			-- disables netrw and use telescope-file-browser in its place
			hijack_netrw = true
		},
	},
}

-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
telescope.load_extension "file_browser"
