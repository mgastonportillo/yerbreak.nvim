local onepiece = require("yerbreak.ascii.onepiece")
local mate = require("yerbreak.ascii.mate")

vim.print(onepiece)

local content = mate ~= nil and mate or onepiece
