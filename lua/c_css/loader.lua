local M = {}

M.init = function(path)
	local files = {}

	local base_path = vim.fn.getcwd()
	local dir = base_path .. "/" .. path
	local contents = vim.split(vim.fn.glob(dir .. "/*"), "\n", { trimempty = true })

	local allowed_ext = { "css", "scss" }

	for _, item in pairs(contents) do
		local ext = item:match("^.+%.(.+)$")
		for _, allowed in pairs(allowed_ext) do
			if ext == allowed then
				table.insert(files, {
					path = item,
					fetched = false,
					available = false,
					file_name = item,
					full_path = "",
				})
			end
		end
	end

	return files
end

return M
