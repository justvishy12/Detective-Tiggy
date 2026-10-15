extends RigidBody2D


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


func reset_item() -> void:
	freeze = true
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	global_position = start_position
	gravity_scale = 0


func check_box() -> void:
	await get_tree().physics_frame
	for area in get_tree().get_nodes_in_group("sorting_boxes"):
		if area.overlaps_body(self):
			if area.types == type:
				freeze = false
				gravity_scale = 1
				return
			else:
				reset_item.call_deferred()
				return
	freeze = false
	gravity_scale = 1


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			dragging = true
			freeze = true
			
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and dragging:
			dragging = false
			check_box()
