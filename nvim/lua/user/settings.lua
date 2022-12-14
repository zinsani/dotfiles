vim.opt.encoding = "utf-8"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.title = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
-- buffer-scoped
vim.opt.autoindent = true
-- window-scoped
vim.opt.cursorline = true
-- global scope
vim.opt.autowrite = true
vim.opt.wildignore = '*/cache/*,*/tmp/*,*/node_modules/*'
vim.env.FZF_DEFAULT_OPTS = '--layout=reverse'
vim.opt.wildignore:append({ "*.so", "*.swp", "*.zip", "*.pyc", "**/.git/**" })
vim.opt.wildignore:append({ "**/node_modules/**" })
vim.opt.wildignore:append({ "**/elm-stuff/**", "**/.cache/**", "**/.parcel-cache/**" })
vim.opt.wildignore:append({ "*.o", "*.out", "*.obj", "*.so", "*.pyc" })
vim.opt.wildignore:append({ "*.zip", "*.tar.gz", "*.tar.bz2", "*.rar", "*.tar.xz" })
vim.opt.wildignore:append({ "*/.sass-cache/*" })
vim.opt.wildignore:append({ "*.swp", "*~", "._*" })
vim.opt.undodir = vim.fn.stdpath('config') .. "/undodir"
vim.opt.undofile = true
