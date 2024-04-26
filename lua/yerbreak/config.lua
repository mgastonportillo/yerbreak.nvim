local M = {}

M.namespace = vim.api.nvim_create_namespace("Yerbreak")

---@type boolean
M.status = false

---@type YerbreakConfig
local defaults = {
	ascii_table = "op",
	delay = 10000,
	border = "rounded",
}

---@type YerbreakConfig
M.options = {}

function M.setup(opts)
	opts = opts or {}
	M.options = vim.tbl_deep_extend("force", defaults, opts)
end

M.setup()

return M
