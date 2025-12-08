local M = {}

local store = require("c_css.store")

M.init = function(bufnr, path, current_files)
	local files = current_files

	local base_path = vim.fn.getcwd()
	local dir = base_path .. "/" .. path
	local contents = vim.fn.glob(dir .. "/**", false, true)
	local allowed_ext = { "css" }

	-- remove changed files
	for index, file in ipairs(files) do
		if store.has(bufnr, "mtime") then
			local stat = vim.loop.fs_stat(file.path)
			if stat then
				local mtime = store.get(bufnr, "mtime")
				if mtime < stat.mtime.sec then
					table.remove(files, index)
				end
			end
		else
			table.remove(files, index)
		end
	end

	-- remove deleted files
	for index, file in ipairs(files) do
		local removed = true
		for _, item in ipairs(contents) do
			if file.path == item then
				removed = false
			end
		end

		if removed then
			table.remove(files, index)
		end
	end

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
					local stat = vim.loop.fs_stat(item)
					if stat then
						store.set(bufnr, "mtime", stat.mtime.sec)
					end

					store.set(bufnr, "readed", false)
					table.insert(files, {
						path = item,
					})
				end
			end
		end
	end

	return files
end

return M
