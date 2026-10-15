extends Node2D

var wrong = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_restart_pressed() -> void:
	for body in $Messy.get_children():
		body.dragging = false
		body.freeze = true
		body.linear_velocity = Vector2.ZERO
		body.angular_velocity = 0.0
		body.global_position = body.start_position
		body.gravity_scale = 0
