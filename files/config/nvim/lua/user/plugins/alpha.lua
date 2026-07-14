-- Start screen / dashboard

return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')

    -- "milon.im" banner
    dashboard.section.header.val = {
      	[[                                                                       ]],
        [[                                                                     ]],
        [[       ████ ██████           █████      ██                     ]],
        [[      ███████████             █████                             ]],
        [[      █████████ ███████████████████ ███   ███████████   ]],
        [[     █████████  ███    █████████████ █████ ██████████████   ]],
        [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
        [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
        [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
        [[                                                                       ]],
    }

    dashboard.section.buttons.val = {
      dashboard.button('f', '  Find file',    ':Telescope find_files<CR>'),
      dashboard.button('r', '  Recent files', ':Telescope oldfiles<CR>'),
      dashboard.button('g', '  Grep project', ':Telescope live_grep<CR>'),
      dashboard.button('c', '  Config',       ':e $MYVIMRC<CR>'),
      dashboard.button('l', '  Lazy',         ':Lazy<CR>'),
      dashboard.button('q', '  Quit',         ':qa<CR>'),
    }

    dashboard.section.header.opts.hl = 'Include'
    dashboard.section.buttons.opts.hl = 'Keyword'

    alpha.setup(dashboard.config)
  end,
}
