local M = {}

local utils = require("c_css.utils")
local config = require("c_css.config")
local extractor = require("c_css.extractor")
local store = require("c_css.store")

M.init = function(bufnr, files)
	for _, file in pairs(files) do
		if not file.fetched then
			utils.readFile(file.path, function(data)
				local extracted_selectors = extractor.selectors(data, file.path)
				local selectors = store.get(bufnr, "selectors") or {
					ids = {},
					classes = {},
				}
				selectors.classes = vim.list_extend(selectors.classes, extracted_selectors.classes)
				selectors.ids = vim.list_extend(selectors.ids, extracted_selectors.ids)

				file.fetched = true
				file.available = true
				store.set(bufnr, "selectors", selectors)

				if config.config.notify then
					vim.schedule(function()
						vim.notify(file.path, vim.log.levels.INFO, { title = "C_CSS Loaded" })
					end)
				end
			end)
		end
	end
end

return M
