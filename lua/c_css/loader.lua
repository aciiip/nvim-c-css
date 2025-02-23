local M = {}

M.init = function(path)
	local files = {}

	local base_path = vim.fn.getcwd()
	local dir = base_path .. "/" .. path
	local contents = vim.split(vim.fn.glob(dir .. "/*"), "\n", { trimempty = true })

	for _, item in pairs(contents) do
		table.insert(files, {
			path = item,
			fetched = false,
			available = false,
			file_name = item,
			full_path = "",
		})
	end

	return files
end

return M
