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
;; find nested class
;; (
;; (rule_set
;;	 (selectors
;;		 (class_selector
;;			 (class_name) @nested.class_name)
;;		 ) @nested.class_decl
;;	 (#lua-match? @nested.class_decl "^[.][a-zA-Z0-9_-]+$")
;;	 (#not-has-ancestor? @nested.class_decl "media_statement")
;;	 (block) @nested.class_block
;;	 ) @nested.rs (#has-ancestor? @nested.rs "rule_set")
;;)
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
