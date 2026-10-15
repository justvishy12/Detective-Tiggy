extends RigidBody2D


var dragging = false
var start_position: Vector2
var checking_drop = false
var correct_box = false
@export var type: String

func _ready() -> void:
	gravity_scale = 0
	start_position = global_position


func _physics_process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position()
	elif checking_drop:
		check_box()


func reset_item() -> void:
	dragging = false
	freeze = true
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	global_position = start_position
	gravity_scale = 0
	print("changed")
	


func check_box() -> void:
	for area in get_tree().get_nodes_in_group("sorting_boxes"):
		if area.overlaps_body(self):
			if area.types == type:
				freeze = false
				correct_box = true
				checking_drop = false
				gravity_scale = 1
				return
			else:
				checking_drop = false
				reset_item()
				return
	freeze = false
	gravity_scale = 1


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:                                                
		if event.is_pressed():
			dragging = true
			freeze = true
			
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and dragging:
			dragging = false
			freeze = false
			gravity_scale = 1
			checking_drop = true
