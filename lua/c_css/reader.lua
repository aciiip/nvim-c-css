local M = {}

local utils = require("c_css.utils")
local config = require("c_css.config")
local extractor = require("c_css.extractor")
local store = require("c_css.store")

M.init = function(bufnr, files)
	local readed = store.get(bufnr, "readed") or false
	if not readed then
		store.set(bufnr, "selectors", nil)
	end

	local loaded = {}
	local pending = 0

	for _, file in pairs(files) do
		if not readed then
			pending = pending + 1
			utils.readFile(file.path, function(data)
				local extracted_selectors = extractor.selectors(data, file.path)
				local selectors = store.get(bufnr, "selectors") or {
					ids = {},
					classes = {},
				}

				selectors.classes = vim.list_extend(selectors.classes, extracted_selectors.classes)
				selectors.ids = vim.list_extend(selectors.ids, extracted_selectors.ids)

				store.set(bufnr, "selectors", selectors)
				store.set(bufnr, "readed", true)
				table.insert(loaded, file.path)

				pending = pending - 1
				if pending == 0 then
					if config.config.notify and next(loaded) ~= nil then
						local result = {}
						for _, value in pairs(loaded) do
							table.insert(result, config.config.list_icon .. " " .. tostring(value))
						end
						vim.schedule(function()
							vim.notify(table.concat(result, "\n"), vim.log.levels.INFO, { title = "C_CSS Loaded" })
						end)
					end
				end
			end)
		end
	end
end

return M
