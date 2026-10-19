extends RigidBody2D


var dragging = false
var start_position: Vector2
var checking_drop = false
var correct_box = false
var can_move = false
@export var type: String

func _ready() -> void:
	gravity_scale = 0
	start_position = global_position
	can_move = false


func _physics_process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position()
	elif checking_drop:
		check_box()
	if correct_box:
		check_box()


func reset_item() -> void:
	dragging = false
	checking_drop = false
	freeze = true
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	gravity_scale = 0

	global_position = start_position
	await get_tree().physics_frame

	PhysicsServer2D.body_set_state(
		get_rid(),
		PhysicsServer2D.BODY_STATE_TRANSFORM,
		global_transform
	)


	global_position = start_position
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	await get_tree().physics_frame
	freeze = false

	
func check_done():
	var all_correct = true
	for item in $"..".get_children():
		if !item.correct_box:
			all_correct = false
			break
	if all_correct and $"../..".played == false:
		$"../..".game_beat()

func check_box() -> void:
	
	for area in get_tree().get_nodes_in_group("sorting_boxes"):
		if area.overlaps_body(self):
			if area.types == type:
				freeze = false
				if !correct_box:
					$"../..".ammount_in += 1
				correct_box = true
				checking_drop = false
				check_done()
				gravity_scale = 1
				return
			else:
				print("works")
				checking_drop = false
				reset_item()
				return
	if correct_box:
		correct_box = false
		$"../..".ammount_in -= 1
		reset_item()
		return
	else:
		freeze = false
		gravity_scale = 1


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:                                            
		if event.is_pressed() and can_move == true:
			dragging = true
			freeze = true
			
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and dragging:
			$"../../drop".play_sfx_hit()
			dragging = false
			freeze = false
			gravity_scale = 1
			checking_drop = true
