local M = {}

M.selectors = [[
(
 (rule_set
	 (selectors
		 (class_selector
			 (class_name) @class_name)
		 ) @class_decl
	 (#lua-match? @class_decl "^[.][a-zA-Z0-9_-]+$")
	 (#not-has-ancestor? @class_decl "media_statement")
	 (block) @class_block
	 )
 )
(
 (rule_set
	 (selectors
		 (id_selector
			 (id_name) @id_name)
		 ) @id_decl
	 (#lua-match? @id_decl "^#[a-zA-Z0-9_-]+")
	 (#not-has-ancestor? @id_decl "media_statement")
	 (block) @id_block
	 )
 )
]]

return M
