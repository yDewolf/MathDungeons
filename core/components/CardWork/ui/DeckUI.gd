extends HBoxContainer

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		var child_count = self.get_child_count()
		var middle_card: int = floor(child_count / 2)
		var children: Array[Node] = self.get_children()
		
		for idx in range(child_count):
			var child = children[idx]
			if child is CardUI:
				var target: float = deg_to_rad(90)
				if idx - middle_card < 0:
					target *= -1
				
				var weight: float = float(abs(idx - middle_card)) / child_count
				child.rotation = lerp(0.0, target, weight)
				child.target_rotation = child.rotation
				
				var position_weight: float = abs(idx - middle_card)
				child.position.y += lerp(0.0, rad_to_deg(abs(child.rotation)) / child_count, position_weight + middle_card / 2)
				child.position.x -= lerp(0.0, rad_to_deg(child.rotation) / middle_card, position_weight + middle_card / 2)
