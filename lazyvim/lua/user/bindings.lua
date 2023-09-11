vim.g.mapleader = ' '
vim.keymap.set({ 'n', 'x' }, 'x', '"_x')
vim.keymap.set('n', 'Y', 'y$', {})
vim.keymap.set('v', '/', '/\v', {})
vim.keymap.set('n', '<', 'CR> :nohlsearch<CR>', {})
vim.keymap.set('n', '<', 'leader><ESC> :nohlsearch<CR>', {})
vim.keymap.set('i', 'jj', '<ESC>', {})

-- Select next item on popup
vim.keymap.set('i', '<Tab>', function()
	return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true })


-- Fugitives
local opt = { noremap = true }
vim.keymap.set('n', '<leader>gs', ":Git <CR>", opt)
vim.keymap.set('n', '<leader>gh', ":diffget //2<CR>", opt)
vim.keymap.set('n', '<leader>gl', ":diffget //3<CR>", opt)
vim.keymap.set('n', '<leader>gg', ":G log <CR>", opt)
vim.keymap.set('n', '<leader>gp', ":G push <CR>", opt)
vim.keymap.set('n', '<leader>gu', ":G pull <CR>", { noremap = true, silent = true })
