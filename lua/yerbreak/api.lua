YBVOID = function() end

local M = {}
local config = require("yerbreak.config")
local utils = require("yerbreak.utils")

local close_float = function(winnr)
	vim.api.nvim_win_close(winnr, true)
	utils.set_status(false)
	utils.toggle_tint()
	-- Restore cursor
	vim.cmd([[
    hi Cursor blend=99
    set guicursor-=a:Cursor/lCursor
  ]])

	utils.notify(" 😒", " Back to work", vim.log.levels.WARN)
end

local open_float = function(opts)
	local ascii_tbl = utils.get_table(opts)
	local lines = ascii_tbl[utils.get_index(ascii_tbl)]
	local win_opts = utils.get_win_opts(opts, lines)
	local bufnr = vim.api.nvim_create_buf(false, true)
	local winnr = vim.api.nvim_open_win(bufnr, true, win_opts)

	utils.set_status(true)
	utils.toggle_tint()
	utils.set_buf_opts(bufnr, "yerbreak", lines)
	utils.set_win_opts("yerbreak")

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

	vim.keymap.set("n", "<ESC>", function()
		close_float(winnr)
	end, { buffer = bufnr })

	utils.notify(" 🧉", " Yerbreak time!", vim.log.levels.INFO)

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
