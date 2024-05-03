local M = {}

---@type boolean
M.status = false

---@type YerbreakConfig
local defaults = {
	ascii_table = "mate",
	delay = nil,
	border = "rounded",
}

local set_default_delay = function(opts)
	local tbl = opts.ascii_table
	local delay = opts.delay
	if tbl == "op" and delay == nil then
		opts.delay = 2000
	elseif tbl == "mate" and delay == nil then
		opts.delay = 200
	end
end

---@type YerbreakConfig
M.options = {}

---@param opts? YerbreakConfig
M.setup = function(opts)
	if opts then
		set_default_delay(opts)
	end

	opts = opts or {}
	M.options = vim.tbl_deep_extend("force", defaults, opts)
end

return M
