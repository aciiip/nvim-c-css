local M = {}
local store = {}

M.set = function(bufnr, key, value)
	if not store[bufnr] then
		store[bufnr] = {
			[key] = value,
		}
	end
	store[bufnr][key] = value
end

M.get = function(bufnr, key)
	if not store[bufnr] then
		return nil
	end
	if not key then
		return store[bufnr]
	end
	return store[bufnr][key]
end

M.has = function(bufnr, key)
	if not store[bufnr] then
		return false
	end
	if not key then
		return store[bufnr] ~= nil
	end
	return store[bufnr][key] ~= nil
end

return M
