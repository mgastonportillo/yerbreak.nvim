local M = {}

local api = require("yerbreak.api")
local cmd = vim.api.nvim_create_user_command

local update_config = function(opts)
	local config = require("yerbreak.config")
	opts = opts or {}
	config.settings = vim.tbl_extend("force", config.settings, opts)
end

local create_commands = function()
	cmd("Yerbreak", function()
		if api.get_status() == false then
			api.start()
		else
			api.stop()
		end
	end, { desc = "Toggle Yerbreak" })
end

M.setup = function(opts)
	update_config(opts)
	create_commands()
end

return M
