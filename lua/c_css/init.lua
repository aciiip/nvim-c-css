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

function M:setup()
	require("cmp").register_source(source_name, source)

	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		pattern = enable_on_dto,
		once = true,
		callback = function(event)
			local files = loader.init(config.path)
			reader.init(event.buf, files)
		end,
	})

	vim.api.nvim_create_autocmd({ "WinEnter" }, {
		pattern = enable_on_dto,
		callback = function(event)
			local files = loader.init(config.path)
			reader.init(event.buf, files)
		end,
	})
end

return M
