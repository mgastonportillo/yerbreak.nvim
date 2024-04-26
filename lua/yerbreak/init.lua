local M = {}

local api = require("yerbreak.api")
local config = require("yerbreak.config")
local cmd = vim.api.nvim_create_user_command

local create_cmds = function()
	cmd("Yerbreak", function()
		if api.get_status() == false then
			api.start()
		else
			api.stop()
		end
	end, { desc = "Toggle Yerbreak" })
end

---@param opts? YerbreakConfig
local setup = function(opts)
	config.setup(opts)
	create_cmds()
end

---@type fun(opts: YerbreakConfig)
M.setup = setup

return M
