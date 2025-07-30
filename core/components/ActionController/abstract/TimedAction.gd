extends Action
class_name TimedAction

## Class for actions that remain active for a given amount of time.

@export_category("Parameters")
@export var duration: float = 1 ## In seconds
var duration_timer: SceneTreeTimer

func _ready():
	started_action.connect(start_timer)

func start_timer():
	duration_timer = get_tree().create_timer(duration)
	duration_timer.timeout.connect(
		func(): active = false
	)
