extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade_in_label()

func fade_in_label():
	$Label.modulate.a = 0.0
	$Label.visible = true

	var tween = create_tween()
	tween.tween_property($Label, "modulate:a", 1.0, 1)
