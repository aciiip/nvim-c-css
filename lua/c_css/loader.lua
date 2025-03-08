local M = {}

local store = require("c_css.store")

M.init = function(bufnr, path, current_files)
	local files = current_files

	local base_path = vim.fn.getcwd()
	local dir = base_path .. "/" .. path
	local contents = vim.split(vim.fn.glob(dir .. "/*"), "\n", { trimempty = true })

	local allowed_ext = { "css" }

	-- get files from disk
	for _, item in pairs(contents) do
		-- check if file stored
		local stored = false
		for _, current_file in ipairs(files) do
			if current_file.path == item then
				stored = true
			end
		end

		-- add file to read
		if not stored then
			local ext = item:match("^.+%.(.+)$")
			for _, allowed in pairs(allowed_ext) do
				if ext == allowed then
					store.set(bufnr, "readed", false)
					table.insert(files, {
						path = item,
					})
				end
			end
		end
	end

	-- remove deleted files
	local deleted = false
	for index, file in ipairs(files) do
		local removed = true
		for _, item in ipairs(contents) do
			if file.path == item then
				removed = false
			end
		end

		if removed then
			table.remove(files, index)
			deleted = true
		end
	end

	-- tell the reader to remove existing selectors and re-read stored files
	if deleted then
		local buffers = vim.api.nvim_list_bufs()
		for _, bf in ipairs(buffers) do
			if store.has(bf, "readed") then
				store.set(bf, "readed", false)
			end
		end
	end

	return files
end

return M
