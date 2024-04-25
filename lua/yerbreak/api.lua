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
	set_status(not config.status)
	utils.open_float()
	print("Yerbreak is on :)")
end

M.stop = function()
	set_status(not config.status)
	utils.close_float()
end

return M
