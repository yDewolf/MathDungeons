extends PanelContainer
class_name CardUI

@export var animation_player: AnimationPlayer
@export var target_rotation: float

func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	animation_player.play("start_hovering")

func _on_mouse_exited() -> void:
	animation_player.play("stop_hovering")
