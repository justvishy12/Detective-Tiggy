extends RigidBody2D
var dragging = false
var can_move = true
var start_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = global_position
	gravity_scale = 0

func _physics_process(_delta: float) -> void:
	if global_position != start_position:
		gravity_scale = 1
	if dragging:
		global_position = get_global_mouse_position()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:                                     
		if event.is_pressed() and can_move == true:

			PhysicsServer2D.body_set_state(
				get_rid(),
				PhysicsServer2D.BODY_STATE_TRANSFORM,
				global_transform
			)
			dragging = true
			freeze = true
			gravity_scale = 0
			linear_velocity = Vector2.ZERO
			angular_velocity = 0.0
			
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and dragging:
			$"..".check_ingredients()
			dragging = false
			freeze = false
			gravity_scale = 1
