local M = {}
local settings = require("yerbreak.config").settings

local get_table = function()
	if settings.default_table == "mate" then
		return require("yerbreak.ascii.mate")
	elseif settings.default_table == "op" then
		return require("yerbreak.ascii.onepiece")
	end
end

local buffer_opts = function(frame_width, frame_height)
	local ui_height = vim.api.nvim_list_uis()[1].height
	local ui_width = vim.api.nvim_list_uis()[1].width

	return {
		relative = "editor",
		width = frame_width,
		height = frame_height,
		-- center buffer
		row = (ui_height - frame_height) * 0.4,
		col = (ui_width - frame_width) * 0.5,
		style = "minimal",
		border = settings.border,
		zindex = 1,
	}
end

local prev_frame = nil
local pick_random_frame = function(frames_tbl)
	local keys = vim.tbl_keys(frames_tbl)
	local random_key
	repeat
		random_key = keys[math.random(#keys)]
	until random_key ~= prev_frame
	return frames_tbl[random_key]
end

local get_size = function(content)
	local width = #content[1] / 3
	local height = math.min(32, #content)
	return width, height
end

local win_id
M.open_float = function()
	local ascii_tbl = get_table()
	local content = pick_random_frame(ascii_tbl)
	prev_frame = content
	local win_opts = buffer_opts(get_size(content))
	local new_buffer = vim.api.nvim_create_buf(false, true)
	win_id = vim.api.nvim_open_win(new_buffer, true, win_opts)
	local bufnr = vim.fn.bufnr()

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, content)
	vim.api.nvim_buf_set_name(bufnr, "yerbreak")
	-- Effectively erase the buffer from memory
	vim.api.nvim_buf_set_option(bufnr, "bufhidden", "delete")

	local update_content
	update_content = function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			-- Execute code only if win_id is open
			if win == win_id then
				content = pick_random_frame(ascii_tbl)
				local new_win_opts = buffer_opts(get_size(content))
				vim.api.nvim_win_set_config(win_id, new_win_opts)
				vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, content)
				-- Recursively pick a new frame
				vim.defer_fn(update_content, 3000)
			end
		end
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
	vim.api.nvim_win_close(win_id, true)
end

return M
