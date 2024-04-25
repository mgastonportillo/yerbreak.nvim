local settings = require("yerbreak.config").settings
local M = {}

local retrieve_table = function()
	if settings.ascii_table == "mate" then
		return require("yerbreak.ascii.mate")
	elseif settings.ascii_table == "op" then
		return require("yerbreak.ascii.onepiece")
	end
end

local buffer_opts = function(width, height)
	local gheight = vim.api.nvim_list_uis()[1].height
	local gwidth = vim.api.nvim_list_uis()[1].width

	return {
		relative = "editor",
		width = width,
		height = height,
		row = (gheight - height) * 0.4,
		col = (gwidth - width) * 0.5,
		style = "minimal",
		border = settings.buffer.border,
		zindex = 1,
	}
end

local pick_random_frame = function(tbl)
	local keys = vim.tbl_keys(tbl)
	local random_key = keys[math.random(#keys)]
	return tbl[random_key]
end

local get_size = function(content)
	local width = #content[1] / 3
	local height = math.min(32, #content)
	return width, height
end

M.open_float = function()
	local ascii_tbl = retrieve_table()
	local content = pick_random_frame(ascii_tbl)
	local win_opts = buffer_opts(get_size(content))
	local new_buffer = vim.api.nvim_create_buf(false, true)
	local win_id = vim.api.nvim_open_win(new_buffer, true, win_opts)
	local bufnr = vim.fn.bufnr()

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, content)
	vim.api.nvim_buf_set_name(bufnr, "yerbreak")
	vim.api.nvim_buf_set_option(bufnr, "bufhidden", "delete")

	local update_content
	update_content = function()
		content = pick_random_frame(ascii_tbl)
		local new_win_opts = buffer_opts(get_size(content))
		vim.api.nvim_win_set_config(win_id, new_win_opts)
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, content)
		vim.defer_fn(update_content, 5000)
	end

	update_content()

	-- Display exit message if force closed
	vim.api.nvim_create_autocmd("WinClosed", {
		pattern = "<buffer=" .. new_buffer .. ">",
		callback = function()
			print("Yerbreak is off :(")
		end,
	})

	return new_buffer
end

M.close_float = function()
	vim.api.nvim_win_close(0, true)
end

return M
