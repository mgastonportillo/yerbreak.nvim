local api = require("yerbreak.api")
local config = require("yerbreak.config")
local cmd = vim.api.nvim_create_user_command
local M = {}

local create_cmds = function()
	cmd("Yerbreak", function()
		if api.get_status() then
			api.stop()
		else
			api.start()
		end
	end, { desc = "Toggle Yerbreak" })
end

---@param opts? YerbreakConfig
M.setup = function(opts)
	config.setup(opts)
	create_cmds()
end

return M
