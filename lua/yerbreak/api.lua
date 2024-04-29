YBVOID = function() end

local M = {}
local config = require("yerbreak.config")
local utils = require("yerbreak.utils")
local tint = require("tint")

local close_float = function(winnr)
	utils.set_status(false)
	vim.api.nvim_win_close(winnr, true)

	if tint ~= true then
		require("tint").disable()
	end

	-- Restore cursor
	vim.cmd([[
    hi Cursor blend=99
    set guicursor-=a:Cursor/lCursor
  ]])

	vim.notify.dismiss()
	vim.notify(" Back to work...", vim.log.levels.WARN, { icon = "😒", timeout = 500, render = "compact" })
end

local open_float = function(opts)
	utils.set_status(true)

	local ascii_tbl = utils.get_table(opts)
	local frame = ascii_tbl[utils.get_index(ascii_tbl)]
	local win_options = utils.get_win_opts(opts, frame)
	local bufnr = vim.api.nvim_create_buf(false, true)
	local winnr = vim.api.nvim_open_win(bufnr, true, win_options)

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, frame)
	vim.api.nvim_buf_set_name(bufnr, "yerbreak")
	-- Effectively erase the buffer from memory
	vim.api.nvim_buf_set_option(bufnr, "bufhidden", "delete")
	-- Prevent scrolling
	vim.api.nvim_win_set_option(winnr, "scrolloff", 999)
	vim.api.nvim_win_set_option(winnr, "wrap", false)
	vim.api.nvim_win_set_option(winnr, "cursorline", false)
	vim.api.nvim_win_set_option(winnr, "cursorcolumn", false)
	vim.api.nvim_win_set_option(winnr, "scrollbind", false)
	-- Hide cursor in float window
	vim.cmd([[
    hi Cursor blend=100
    set guicursor+=a:Cursor/lCursor
  ]])

	-- Dim float if tint is available
	if tint ~= true then
		require("tint").setup(utils.tint_config)
		require("tint").enable()
	end

	local update_frame
	update_frame = function()
		if vim.api.nvim_buf_is_loaded(bufnr) == true then
			frame = ascii_tbl[utils.get_index(ascii_tbl)]
			local new_win_options = utils.get_win_opts(opts, frame)
			vim.api.nvim_win_set_config(winnr, new_win_options)
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, frame)
			-- Recursively pick a new frame
			vim.defer_fn(update_frame, opts.delay)
		end
	end

	update_frame()

	-- Disable mouse-wheel scrolling
	local mouse_actions = { "<ScrollWheelUp>", "<ScrollWheelDown>" }
	for _, action in ipairs(mouse_actions) do
		vim.api.nvim_buf_set_keymap(bufnr, "n", action, "<cmd>call v:lua.YBVOID()<CR>", {
			silent = true,
			noremap = true,
		})
	end

	vim.keymap.set("n", "<ESC>", function()
		close_float(winnr)
	end, { buffer = bufnr })

	vim.notify.dismiss()
	vim.notify(" Yerbreak time!", vim.log.levels.INFO, { icon = "🧉", timeout = 500, render = "compact" })

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
