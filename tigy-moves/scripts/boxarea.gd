extends Area2D

@export var types: String

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		if types == body.type:
			pass
		else:
			body.dragging = false
			body.freeze = true
			body.linear_velocity = Vector2.ZERO
			body.angular_velocity = 0.0
			body.global_position = body.start_position
			$"..".wrong += 1
			
