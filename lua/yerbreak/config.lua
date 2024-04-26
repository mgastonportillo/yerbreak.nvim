local M = {}

---@type boolean
M.status = false

---@type YerbreakConfig
local defaults = {
	ascii_table = "mate",
	delay = 200,
	border = "rounded",
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
