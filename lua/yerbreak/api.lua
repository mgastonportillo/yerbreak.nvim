local config = require("yerbreak.config")
local utils = require("yerbreak.utils")

local M = {}

local set_status = function()
	config.status = not config.status
end

M.get_status = function()
	return config.status
end

M.start = function()
	set_status()
	utils.open_float()
	print("Yerbreak is on :)")
end

M.stop = function()
	set_status()
	utils.close_float()
end

return M
