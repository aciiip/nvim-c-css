local M = {}

local source = require("c_css.source")
local config = require("c_css.config").config
local loader = require("c_css.loader")
local reader = require("c_css.reader")

local source_name = "c_css"

---@type string[]
local enable_on_dto = {}

if config.enable_on ~= nil then
	for _, ext in pairs(config.enable_on) do
		table.insert(enable_on_dto, "*." .. ext)
	end
end

local files = loader.init(config.path)

function M:setup()
	require("cmp").register_source(source_name, source)

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePre", "WinEnter" }, {
		pattern = enable_on_dto,
		callback = function(event)
			reader.init(event.buf, files)
		end,
	})
end

return M
