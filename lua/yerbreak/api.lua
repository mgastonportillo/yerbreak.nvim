local config = require("yerbreak.config")
local utils = require("yerbreak.utils")

local M = {}

local set_status = function(new_status)
	config.status = new_status
end

M.get_status = function()
	return config.status
end

M.start = function()
	set_status(true)
	utils.open_float(config.options)
	print("Yerbreak time! :)")
end

M.stop = function()
	set_status(false)
	utils.close_float()
end

return M
