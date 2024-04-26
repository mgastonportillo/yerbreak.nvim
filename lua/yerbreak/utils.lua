local M = {}
local options = require("yerbreak.config").options

local get_table = function()
	if options.ascii_table == "mate" then
		return require("yerbreak.ascii.mate")
	elseif options.ascii_table == "op" then
		return require("yerbreak.ascii.onepiece")
	end
end

local get_opts = function(frame_width, frame_height)
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
		border = options.border,
		zindex = 1,
	}
end

local prev_frame = nil
local get_random_frame = function(frames_tbl)
	local keys = vim.tbl_keys(frames_tbl)
	local random_key
	repeat
		random_key = keys[math.random(#keys)]
	until frames_tbl[random_key] ~= prev_frame
	return frames_tbl[random_key]
end

local get_size = function(frame)
	local width = #frame[1] / 3
	local height = math.min(32, #frame)
	return width, height
end

local win_id
M.open_float = function()
	local ascii_tbl = get_table()
	local frame = get_random_frame(ascii_tbl)
	local win_options = get_opts(get_size(frame))
	local new_buffer = vim.api.nvim_create_buf(false, true)
	win_id = vim.api.nvim_open_win(new_buffer, true, win_options)
	local bufnr = vim.fn.bufnr()

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, frame)
	vim.api.nvim_buf_set_name(bufnr, "yerbreak")
	-- Effectively erase the buffer from memory
	vim.api.nvim_buf_set_option(bufnr, "bufhidden", "delete")
	-- Prevent scrolling
	vim.api.nvim_win_set_option(win_id, "scrolloff", 999)
	vim.api.nvim_win_set_option(win_id, "wrap", false)
	vim.api.nvim_win_set_option(win_id, "cursorline", false)
	vim.api.nvim_win_set_option(win_id, "cursorcolumn", false)
	vim.api.nvim_win_set_option(win_id, "scrollbind", false)

	Void = function() end
	local mouse_actions = { "<ScrollWheelUp>", "<ScrollWheelDown>" }

	for _, action in ipairs(mouse_actions) do
		vim.api.nvim_buf_set_keymap(bufnr, "n", action, "<cmd>call v:lua.Void()<CR>", {
			silent = true,
			noremap = true,
		})
	end

	local update_frame
	update_frame = function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			-- Execute code only if win_id is open
			if win == win_id and bufnr ~= nil then
				-- Store prev frame
				prev_frame = frame
				frame = get_random_frame(ascii_tbl)
				local new_win_options = get_opts(get_size(frame))
				vim.api.nvim_win_set_config(win_id, new_win_options)
				vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, frame)
				-- Recursively pick a new frame
				vim.defer_fn(update_frame, options.delay)
			end
		end
	end

	update_frame()

	-- Display exit message
	vim.api.nvim_create_autocmd("BufUnload", {
		pattern = "yerbreak",
		group = vim.api.nvim_create_augroup("yerbreak_unload", { clear = true }),
		callback = function()
			print("Back to work >:(")
		end,
	})

	return new_buffer
end

M.close_float = function()
	vim.api.nvim_win_close(win_id, true)
end

return M
