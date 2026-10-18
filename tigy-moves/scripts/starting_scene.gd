extends Node2D
var played = false
var skip_typing = false
var dialogue = [
	{
		#0
		"speaker": "cat",
		"name": "???",
		"text": "What are you doing here? This is my detective ZONE! ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#1
		"speaker": "you",
		"name": "",
		"text": "Just exploring"
	},
	{
		#2
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Well, I am Detective Tiggy, I solve mysteries, and since you explore, you will be Traveler! ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#3
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "While you're here, help me solve this mystery. ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#4
		"speaker": "you",
		"name": "",
		"text": "Uhh Okay!"
	},

	]

var dialogue_index = 0
var typing = false


func show_next_dialogue() -> void:
	if dialogue_index >= dialogue.size():
		$Textbox.visible = false
		$you.visible = false
		return
	
	var line = dialogue[dialogue_index]
	
	if line["speaker"] == "you":
		$Textbox.visible = false
		$you.visible = true
		$you.text = line["text"]
		
	elif line["speaker"] == "cat":
		$you.visible = false
		show_cat_text(line)
		



func show_cat_text(line) -> void:
	skip_typing = false
	$Textbox.visible = true
	typing = true
	
	$Textbox/namelabel.text = line["name"]
	$Textbox/textlabel.text = line["text"]
	
	if line.has("portrait"):
		$Textbox/photobox.texture = line["portrait"]
	else:
		$Textbox/photobox.texture = null
	$Textbox/textlabel.visible_characters = 0

	for i in $Textbox/textlabel.text.length():
		if skip_typing:
			$Textbox/textlabel.visible_characters = $Textbox/textlabel.text.length()
			break
		if !is_inside_tree():
			return
		$Textbox/textlabel.visible_characters = i
		await get_tree().create_timer(SaveManager.speed, false).timeout
	typing = false


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		$pausemenu.visible = true
	if event.is_action_pressed("ui_accept") and !typing:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			dialogue_index += 1
			show_next_dialogue()
			
	elif event.is_action_pressed("ui_accept") and typing:
		skip_typing = true
		$Textbox/textlabel.visible_characters = $Textbox/textlabel.text.length()


func _on_you_pressed() -> void:
	if dialogue_index == 4 and played == false:
		played = true
		$AnimationPlayer.play("fade out")
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_file("res://scenes/room1.tscn")
		
		
	dialogue_index += 1
	show_next_dialogue()
	
func _ready() -> void:
	SaveManager.save_game(SaveManager.current_slot)
	show_next_dialogue()
