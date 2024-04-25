local M = {}

---@type boolean
M.status = false

---@type YerbaConfig
M.settings = {
	ascii_table = "op",
	buffer = {
		-- Accepts same border values as |nvim_open_win()|
		border = "rounded",
	},
}

return M
