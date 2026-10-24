extends Node2D
var fridge = false
var microwave = false
var all_moved = true
var mix = true
var mixing = false
var mouse_moved = true
var mouse_position = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func check_ingredients():
	for item in get_tree().get_nodes_in_group("ingredients"):
		if item.global_position == item.start_position:
			all_moved = false
			break

	if all_moved:
		print("good")

func _on_fridge_pressed() -> void:
	if fridge == false:
		$fridge.disabled = true
		$AnimationPlayer.play("open")
		await $AnimationPlayer.animation_finished
		$fridge.disabled = false
		fridge = true
	elif fridge == true:
		$fridge.disabled = true
		$AnimationPlayer.play("close")
		await $AnimationPlayer.animation_finished
		$fridge.disabled = false
		fridge = false


func _on_microwave_pressed() -> void:
	if microwave == false:
		$MicrowaveO.visible = true
		microwave = true
	elif microwave == true:
		$MicrowaveO.visible = false
		microwave = false





func _on_border_body_exited(body: Node2D) -> void:
	if body.is_in_group("ingredients"):
		print("out")
		body.dragging = false
		body.freeze = true
		body.gravity_scale = 0
		body.linear_velocity = Vector2.ZERO
		body.angular_velocity = 0.0

		body.global_position = body.start_position

		PhysicsServer2D.body_set_state(
			body.get_rid(),
			PhysicsServer2D.BODY_STATE_TRANSFORM,
			body.global_transform
		)


func fade_items():
	if mixing and mix:
		mouse_position = get_global_mouse_position()

		while $Mixed.modulate.a < 1.0 and mix and mixing:
			var current_position = get_global_mouse_position()

			if mouse_position.distance_to(current_position) > 1:
				mouse_moved = true
			else:
				mouse_moved = false

			if mouse_moved:
				$Mixed.modulate.a = min($Mixed.modulate.a + 0.01, 1.0)
				$Unmixed.modulate.a = max($Unmixed.modulate.a - 0.01, 0.0)

			mouse_position = current_position
			await get_tree().create_timer(0.02).timeout

		if $Mixed.modulate.a >= 1.0:
			$Mixed.modulate.a = 1.0
			$Unmixed.modulate.a = 0.0

func _on_mousemix_mouse_entered() -> void:
	mixing = true
	print("god")
	if mix:
		fade_items()


func _on_mousemix_mouse_exited() -> void:
	mixing = false
