extends Node2D

var window = true

var pan = false
var skip_typing = false
var dialogue = [
	{
		#0
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Welcome in, this is my house, as you see its very organiz- WHAT IS THAT! ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#1
		"speaker": "you",
		"name": "",
		"text": "What happened?"
	},
	{
		#2
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Look at all those socks, can you please organize them? ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#3
		"speaker": "you",
		"name": "",
		"text": "Uhh Okay!"
	},

	]

var dialogue_index = 0
var typing = false


func show_next_dialogue() -> void:
	if dialogue_index >= dialogue.size():
		$Camera2D/Textbox.visible = false
		$Camera2D/you.visible = false
		return
	
	var line = dialogue[dialogue_index]
	
	if line["speaker"] == "you":
		$Camera2D/Textbox.visible = false
		$Camera2D/you.visible = true
		$Camera2D/you.text = line["text"]
		
	elif line["speaker"] == "cat":
		$Camera2D/you.visible = false
		show_cat_text(line)
		



func show_cat_text(line) -> void:
	skip_typing = false
	$Camera2D/Textbox.visible = true
	typing = true
	
	$Camera2D/Textbox/namelabel.text = line["name"]
	$Camera2D/Textbox/textlabel.text = line["text"]
	
	if line.has("portrait"):
		$Camera2D/Textbox/photobox.texture = line["portrait"]
	else:
		$Camera2D/Textbox/photobox.texture = null
	$Camera2D/Textbox/textlabel.visible_characters = 0

	for i in $Camera2D/Textbox/textlabel.text.length():
		if skip_typing:
			$Camera2D/Textbox/textlabel.visible_characters = $Camera2D/Textbox/textlabel.text.length()
			break
		if !is_inside_tree():
			return
		$Camera2D/Textbox/textlabel.visible_characters = i
		await get_tree().create_timer(SaveManager.speed, false).timeout
	typing = false


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		$Camera2D/pausemenu.visible = true
	if dialogue_index == 2 and pan == false:
		pan = true
		$AnimationPlayer.play("basketfront")
		$AnimationPlayer2.play("camera pan")
	if event.is_action_pressed("ui_accept") and !typing:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			dialogue_index += 1
			show_next_dialogue()
			
	elif event.is_action_pressed("ui_accept") and typing:
		skip_typing = true
		$Camera2D/Textbox/textlabel.visible_characters = $Camera2D/Textbox/textlabel.text.length()


func _on_you_pressed() -> void:
	if dialogue_index == 3:
		$AnimationPlayer.play("fade out")
		await $AnimationPlayer.animation_finished
		SaveManager.room1 = true
		SaveManager.save_game(SaveManager.current_slot)
		get_tree().call_deferred("change_scene_to_file", "res://scenes/sockMG.tscn")
		return
		
		
	dialogue_index += 1
	show_next_dialogue()
	
func _ready() -> void:
	SaveManager.introduction = true
	SaveManager.save_game(SaveManager.current_slot)
	show_next_dialogue()


func _on_photo_1_area_mouse_entered() -> void:
	$photo1.play("default")


func _on_photo_1_area_mouse_exited() -> void:
	$photo1.stop()


func _on_window_pressed() -> void:
	if window == true:
		$WindowL.visible = false
		window = false
	elif window == false:
		$WindowL.visible = true
		window = true
