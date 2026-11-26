vim.opt.cmdheight = 0
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.number = true
-- vim.opt.relativenumber = true

vim.opt.title = true
vim.opt.termguicolors = true

vim.opt.spell = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.mouse = 'a'                     -- enable mouse for all modes

vim.opt.wildmode = 'longest:full,full'  -- complete the longest common match, and allow tabbing the results to fully complete them

vim.opt.breakindent = true              -- maintain indent when wrapping indented lines
vim.opt.linebreak = true                -- wrap at word boundaries
vim.opt.list = true                     -- enable the below listchars
vim.opt.listchars = { tab = '▸ ', trail = '·', nbsp = '␣' }
vim.opt.fillchars:append({ eob = ' ' }) -- remove the ~ from end of buffer

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.scrolloff = 6
vim.opt.sidescrolloff = 6

vim.opt.clipboard = 'unnamedplus'      -- Use Linux system clipboard
vim.opt.confirm = true                 -- ask for confirmation instead of erroring
vim.opt.undofile = true                -- persistent undo