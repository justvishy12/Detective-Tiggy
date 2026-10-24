extends Node2D
var fridge = false
var microwave = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
