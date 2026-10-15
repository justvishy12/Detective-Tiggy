extends RigidBody2D

var count = 1
var dragging = false
var start_position: Vector2
@export var type: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0
	start_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		count += 1
		if count % 2 == 0:
			dragging = true
			freeze = true
		else:
			dragging = false
			freeze = false
