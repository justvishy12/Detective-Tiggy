extends Node2D
var fridge = false
var microwave = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func mug_cooked():
	pass


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
