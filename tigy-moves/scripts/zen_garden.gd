extends Node2D

var played = false
var played2 = false

var skip_typing = false
var dialogue = [
	{
		#0
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Look, who is that? ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#1
		"speaker": "you",
		"name": "",
		"text": "I don't know, but they are digging! "
	},
	{
		#2
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "HEY, TURN AROUND! ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#3
		"speaker": "cat",
		"name": "???",
		"text": "I'm sorry, please forgive me. ",
		"portrait": preload("res://assets/headshots/TUSKY FACE.png")
	},
	{
		#4
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Tusky? What are you doing here? ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#5
		"speaker": "you",
		"name": "",
		"text": "Who is Tusky "
	},
	{
		#6
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "He is my little cousin but move aside, NOW! ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#7
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Hey, that's, my shoe! And a PIECE OF THE RECIPE! ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#8
		"speaker": "cat",
		"name": "Tusky",
		"text": "Sorry? ",
		"portrait": preload("res://assets/headshots/TUSKY FACE.png")
	},
	{
		#9
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Let's go back in, and i'm not forgeting about what you did! (click door) ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
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
		$pausemenu.visible = true
	if dialogue_index == 2 and played == false:
		$sand.stop()
		played = true
		$AnimationPlayer.stop()
		$AnimationPlayer.play("tusky turn")
		$tusk.play()
	if dialogue_index == 6 and played == true:
		played = false
		await get_tree().create_timer(0.3).timeout
		print("works")
		$AnimationPlayer.stop()
		$AnimationPlayer.play("tusky move")
		
	if dialogue_index == 7:
		$"close items".visible = true
	if dialogue_index == 8:
		$"close items".visible = false
	if dialogue_index == 9 and played2 == false:
		$pan.play()
		played2 = true
		print(played2)
		$AnimationPlayer.play("grab_tusky")
	if event.is_action_pressed("ui_accept") and !typing:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			if dialogue_index != 9:
				dialogue_index += 1
				show_next_dialogue()
			
	elif event.is_action_pressed("ui_accept") and typing:
		skip_typing = true
		$Camera2D/Textbox/textlabel.visible_characters = $Camera2D/Textbox/textlabel.text.length()


func _on_you_pressed() -> void:
	dialogue_index += 1
	show_next_dialogue()
		
func _ready() -> void:
	$sand.play()
	$AnimationPlayer.play("digging")
	show_next_dialogue()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
