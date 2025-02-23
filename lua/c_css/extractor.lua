local M = {}

local ts = vim.treesitter
local q = require("c_css.querys")
local cmp = require("cmp")

local function provider_name(href_value)
	local filename = href_value:match("[^/]+%.css$") or href_value:match("[^/]+%.min%.css$")
	if filename then
		filename = filename:gsub("%.min%.css$", "")
		filename = filename:gsub("%.css$", "")
		filename = filename:gsub("^%l", string.upper)
		return filename
	end
	return nil
end

M.selectors = function(data, source)
	local selectors = {
		ids = {},
		classes = {},
	}

	local parser = ts.get_string_parser(data, "css")
	local parse = parser:parse()
	local root = parse[1]:root()
	local query = ts.query.parse("css", q.selectors)

	for _, match, _ in query:iter_matches(root, data, 0, -1, { all = true }) do
		for id, nodes in pairs(match) do
			for _, node in ipairs(nodes) do
				local capture_name = query.captures[id]
				local name = ts.get_node_text(node, data)

				if capture_name == "id_name" then
					local block_node
					for match_id, match_nodes in pairs(match) do
						if query.captures[match_id] == "id_block" then
							block_node = match_nodes[1]
							break
						end
					end

					local block_text = ""
					if block_node then
						block_text = ts.get_node_text(block_node, data)
					end

					table.insert(selectors.ids, {
						label = name,
						block = block_text,
						kind = cmp.lsp.CompletionItemKind.Enum,
						source = source,
						provider = provider_name(source),
					})
				elseif capture_name == "class_name" then
					local block_node
					for match_id, match_nodes in pairs(match) do
						if query.captures[match_id] == "class_block" then
							block_node = match_nodes[1]
							break
						end
					end

					local block_text = ""
					if block_node then
						block_text = ts.get_node_text(block_node, data)
					end

					table.insert(selectors.classes, {
						label = name,
						block = block_text,
						kind = cmp.lsp.CompletionItemKind.Enum,
						source = source,
						provider = provider_name(source),
					})
				end
			end
		end
	end

	return selectors
end

return M
