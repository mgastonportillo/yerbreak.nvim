local M = {}
local config = require("yerbreak.config")

local is_named_table = function(tbl)
	for key in pairs(tbl) do
		if type(key) ~= "number" then
			return true
		end
	end
	return false
end

local has_border = function()
	if config.options.border ~= "none" then
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

M.set_status = function(new_status)
	config.status = new_status
end

M.tint_config = {
	tint = -25,
	saturation = 0.4,
	transforms = require("tint").transforms.SATURATE_TINT,
	tint_background_colors = true,
	highlight_ignore_patterns = { "WinSeparator", "Status.*" },
	window_ignore_function = function(winid)
		local floating = vim.api.nvim_win_get_config(winid).relative ~= ""
		return floating
	end,
}

return M
