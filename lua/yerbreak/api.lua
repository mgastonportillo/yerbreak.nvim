local config = require("yerbreak.config")
local utils = require("yerbreak.utils")

local M = {}

local set_status = function(new_status)
	config.status = new_status
end

M.get_status = function()
	return config.status
end

local float
M.start = function()
	set_status(true)
	float = utils.open_float(config.options)
	vim.notify(" Yerbreak time!", 2, { icon = "🧉", timeout = 500 })
end

M.stop = function()
	set_status(false)
	utils.close_float(float)
end

return M
