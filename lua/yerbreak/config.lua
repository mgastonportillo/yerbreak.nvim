local M = {}

---@type boolean
M.status = false

---@type YerbreakConfig
local defaults = {
	ascii_table = "mate",
	delay = 200,
	border = "rounded",
	tint = {
		tint = -25,
		saturation = 0.4,
		transforms = require("tint").transforms.SATURATE_TINT,
		tint_background_colors = true,
		highlight_ignore_patterns = { "WinSeparator", "Status.*" },
		window_ignore_function = function(winid)
			local floating = vim.api.nvim_win_get_config(winid).relative ~= ""
			return floating
		end,
	},
}

---@type YerbreakConfig
M.options = {}

---@param opts? YerbreakConfig
M.setup = function(opts)
	opts = opts or {}
	M.options = vim.tbl_deep_extend("force", defaults, opts)
end

M.setup()

return M
