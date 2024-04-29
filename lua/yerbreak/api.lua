local config = require("yerbreak.config")
local utils = require("yerbreak.utils")

local M = {}

M.get_status = function()
	return config.status
end

local float
M.start = function()
	float = utils.open_float(config.options)
	vim.notify(" Yerbreak time!", 2, { icon = "🧉", timeout = 500 })
end

M.stop = function()
	utils.close_float(float)
end

return M
