extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.fade == true:
		$Label.visible = false
	if Global.fade == false:
		Global.fade = true
		$AnimationPlayer.play("fade out")
	SaveManager.current_slot = 0
	refresh_slots()


func refresh_slots():
	for i in range(1, 4):
		var slot = get_node("Loading/Save%d" % i)

		var thumbnail = SaveManager.load_thumbnail(i)

		if thumbnail:
			slot.get_node("Thumbnail").texture = thumbnail
		else:
			slot.get_node("Thumbnail").texture = load("res://assets/txture plc holder.png")

		var data = SaveManager.get_save_data(i)

		if data:
			var datetime = data["saved_at"].split("T")

			var date = datetime[0].split("-")
			var time = datetime[1].substr(0, 5)

			slot.get_node("HBoxContainer/date").text = "%s/%s/%s" % [date[1], date[2], date[0]]
			slot.get_node("HBoxContainer/time").text = time




func _on_load_1_pressed() -> void:
	SaveManager.current_slot = 1
	$AnimationPlayer2.play("fade out")
	await $AnimationPlayer2.animation_finished
	if FileAccess.file_exists("user://save_1.json"):
		SaveManager.load_game(1)
	else:
		get_tree().change_scene_to_file("res://scenes/starting scene.tscn")


func _on_load_2_pressed() -> void:
	SaveManager.current_slot = 2
	$AnimationPlayer2.play("fade out")
	await $AnimationPlayer2.animation_finished
	if FileAccess.file_exists("user://save_2.json"):
		SaveManager.load_game(2)
	else:
		get_tree().change_scene_to_file("res://scenes/starting scene.tscn")


func _on_load_3_pressed() -> void:
	SaveManager.current_slot = 3
	$AnimationPlayer2.play("fade out")
	await $AnimationPlayer2.animation_finished
	if FileAccess.file_exists("user://save_3.json"):
		SaveManager.load_game(3)
	else:
		get_tree().change_scene_to_file("res://scenes/starting scene.tscn")


func _on_reset_1_pressed() -> void:
	SaveManager.delete_save(1)
	refresh_slots()
	$Loading/Save1/Thumbnail.texture = load("res://assets/txture plc holder.png")
	$Loading/Save1/HBoxContainer/date.text = "xx/xx/xxxx"
	$Loading/Save1/HBoxContainer/time.text = "xx:xx"


func _on_reset_2_pressed() -> void:
	SaveManager.delete_save(2)
	refresh_slots()
	$Loading/Save1/Thumbnail.texture = load("res://assets/txture plc holder.png")
	$Loading/Save1/HBoxContainer/date.text = "xx/xx/xxxx"
	$Loading/Save1/HBoxContainer/time.text = "xx:xx"


func _on_reset_3_pressed() -> void:
	SaveManager.delete_save(3)
	refresh_slots()
	$Loading/Save1/Thumbnail.texture = load("res://assets/txture plc holder.png")
	$Loading/Save1/HBoxContainer/date.text = "xx/xx/xxxx"
	$Loading/Save1/HBoxContainer/time.text = "xx:xx" 


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/prefferences.tscn")


func _on_guide_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/guide.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
