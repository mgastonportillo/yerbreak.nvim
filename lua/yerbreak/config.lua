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
	M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})
end

return M
