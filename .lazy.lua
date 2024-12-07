-- Disable autoformat for conf files
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		vim.filetype.add({
			pattern = {
				[".*/kitty/.+%.conf"] = "conf",
			},
		})
	end,
})

return {}
