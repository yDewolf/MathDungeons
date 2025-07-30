class_name NodeUtils

static func get_deep_children(node: Node, group_filter: String = ""):
	var children = []
	for child in node.get_children():
		var node_children = NodeUtils.get_deep_children(child, group_filter)
		
		children.append_array(node_children)
		if not child.is_in_group(group_filter) and group_filter != "":
			continue
		
		children.append(child)
	
	return children
