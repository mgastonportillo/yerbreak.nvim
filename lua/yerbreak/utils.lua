local M = {}

YerbreakVoid = function() end

local get_table = function(opts)
	if opts.ascii_table == "mate" then
		return require("yerbreak.ascii.mate")
	elseif opts.ascii_table == "op" then
		return require("yerbreak.ascii.onepiece")
	end
end

local is_named_table = function(tbl)
	for key in pairs(tbl) do
		if type(key) ~= "number" then
			return true
		end
	end
	return false
end

local get_frame_size = function(frame)
	local width = #frame[1] / 3
	local height = math.min(32, #frame)
	return width, height
end

local get_win_opts = function(opts, frame)
	local frame_width, frame_height = get_frame_size(frame)
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
		border = opts.border,
		zindex = 1,
	}
end

local current_index = 0
local get_index = function(tbl)
	-- "onepiece"
	if is_named_table(tbl) == true then
		local keys = vim.tbl_keys(tbl)
		local next_index
		repeat
			next_index = keys[math.random(#keys)]
		until next_index ~= current_index and next_index ~= "name"
		return next_index
	-- "mate"
	else
		if current_index >= 9 or current_index == nil then
			current_index = 1
			return 1
		end
		local next_index = current_index + 1
		current_index = next_index
		return next_index
	end
end

M.open_float = function(opts)
	local ascii_tbl = get_table(opts)
	local frame = ascii_tbl[get_index(ascii_tbl)]
	local win_options = get_win_opts(opts, frame)
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

	-- Disable mouse-wheel scrolling
	local mouse_actions = { "<ScrollWheelUp>", "<ScrollWheelDown>" }
	for _, action in ipairs(mouse_actions) do
		vim.api.nvim_buf_set_keymap(bufnr, "n", action, "<cmd>call v:lua.YerbreakVoid()<CR>", {
			silent = true,
			noremap = true,
		})
	end

	local update_frame
	update_frame = function()
		if vim.api.nvim_buf_is_loaded(bufnr) == true then
			frame = ascii_tbl[get_index(ascii_tbl)]
			local new_win_options = get_win_opts(opts, frame)
			vim.api.nvim_win_set_config(winnr, new_win_options)
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, frame)
			-- Recursively pick a new frame
			vim.defer_fn(update_frame, opts.delay)
		end
	end

	update_frame()

	return winnr
end

M.close_float = function(winnr)
	vim.api.nvim_win_close(winnr, true)
	vim.notify(" Back to work...", 3, { icon = "😒", timeout = 500 })
	-- Restore cursor
	vim.cmd([[
    hi Cursor blend=99
    set guicursor-=a:Cursor/lCursor
  ]])
end

return M
