local M = {}
local config = require("yerbreak.config")
local options = config.options

local buf_map = function(bufnr, mode, lhs, rhs, custom_opts)
	local map_opts = { noremap = true, silent = true }
	if custom_opts then
		map_opts = vim.tbl_extend("force", map_opts, custom_opts)
	end
	vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, map_opts)
end

local is_named_table = function(tbl)
	for key in pairs(tbl) do
		if type(key) ~= "number" then
			return true
		end
	end
	return false
end

local has_border = function()
	if options.border ~= "none" then
		return true
	else
		return false
	end
end

local get_frame_size = function(frame)
	local width = #frame[1] / 3
	local height = math.min(32, #frame)
	return width, height
end

M.get_table = function(opts)
	if opts.ascii_table == "mate" then
		return require("yerbreak.ascii.mate")
	elseif opts.ascii_table == "op" then
		return require("yerbreak.ascii.onepiece")
	end
end

M.get_win_opts = function(opts, frame)
	local frame_width, frame_height = get_frame_size(frame)
	local ui_height = vim.api.nvim_list_uis()[1].height
	local ui_width = vim.api.nvim_list_uis()[1].width
	return {
		relative = "editor",
		width = frame_width,
		height = frame_height,
		-- center buffer
		row = (ui_height - frame_height) * (has_border() and 0.4 or 0.5),
		col = (ui_width - frame_width) * 0.5,
		style = "minimal",
		border = opts.border,
		zindex = 49,
	}
end

local current_index = 0
M.get_index = function(tbl)
	-- "onepiece"
	if is_named_table(tbl) == true then
		local keys = vim.tbl_keys(tbl)
		local next_index
		repeat
			next_index = keys[math.random(#keys)]
		until next_index ~= current_index
		return next_index
	-- "mate"
	else
		if current_index >= 9 or current_index == nil then
			local next_index = 1
			current_index = next_index
			return next_index
		else
			local next_index = current_index + 1
			current_index = next_index
			return next_index
		end
	end
end

M.notify = function(icon, msg, type)
	---@diagnostic disable-next-line
	vim.notify.dismiss()
	vim.notify(msg, type, { icon = icon, timeout = 500, render = "compact" })
end

M.set_status = function(new_status)
	config.status = new_status
end

M.set_buf_opts = function(bufnr, name, lines)
	local opt = vim.opt_local

	opt.scrolloff = 999
	opt.number = false
	-- opt.list = false
	opt.wrap = false
	opt.cursorline = false
	opt.scrollbind = false
	opt.cursorcolumn = false
	opt.buflisted = false
	opt.buftype = "nofile"
	opt.bufhidden = "delete"
	opt.colorcolumn = "0"
	opt.foldcolumn = "0"
	-- Effectively erase the buffer from memory once hidden
	opt.filetype = name

	vim.api.nvim_buf_set_name(bufnr, name)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)

	-- Keymaps local to buffer
	local quit_actions = { "q", "<ESC>" }
	for _, lhs in ipairs(quit_actions) do
		buf_map(bufnr, "n", lhs, "<cmd>lua require('yerbreak.api').stop()<CR>")
	end
	local void_actions = { "<ScrollWheelUp>", "<ScrollWheelDown>", "<leader>b" }
	for _, lhs in ipairs(void_actions) do
		buf_map(bufnr, "n", lhs, "<cmd><CR>")
	end

	-- Hide cursor
	vim.cmd([[
    hi Cursor blend=100
    set guicursor+=a:Cursor/lCursor
  ]])
end

return M
