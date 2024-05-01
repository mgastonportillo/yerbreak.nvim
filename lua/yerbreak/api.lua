local M = {}
local config = require("yerbreak.config")
local utils = require("yerbreak.utils")

local close_float = function(winnr)
	utils.set_status(false)
	vim.api.nvim_win_close(winnr, true)
	utils.notify(" 😒", " Back to work", vim.log.levels.WARN)
	-- Restore cursor
	vim.cmd([[
    hi Cursor blend=99
    set guicursor-=a:Cursor/lCursor
  ]])
end

local open_float = function(opts)
	utils.set_status(true)
	local ascii_tbl = utils.get_table(opts)
	local lines = ascii_tbl[utils.get_index(ascii_tbl)]
	local win_opts = utils.get_win_opts(opts, lines)
	local bufnr = vim.api.nvim_create_buf(false, true)
	local winnr = vim.api.nvim_open_win(bufnr, true, win_opts)
	utils.set_buf_opts(bufnr, "yerbreak", lines)
	utils.notify(" 🧉", " Yerbreak time!", vim.log.levels.INFO)

	-- TODO: move function definition to utils
	local update_frame
	update_frame = function()
		if vim.api.nvim_buf_is_loaded(bufnr) == true then
			local new_lines = ascii_tbl[utils.get_index(ascii_tbl)]
			local new_win_opts = utils.get_win_opts(win_opts, new_lines)
			vim.api.nvim_win_set_config(winnr, new_win_opts)
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, new_lines)
			-- Recursively get the next frame
			vim.defer_fn(update_frame, opts.delay)
		end
	end
	update_frame()

	return winnr
end

M.get_status = function()
	return config.status
end

local float
M.start = function()
	float = open_float(config.options)
end

M.stop = function()
	close_float(float)
end

return M
