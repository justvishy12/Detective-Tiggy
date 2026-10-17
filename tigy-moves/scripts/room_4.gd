extends Node2D

var wrong = 0
var played = false
var start_time: int
var elapsed_time: int
var ammount_in = 0

var skip_typing = false
var dialogue = [
	{
		#0
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "This is MY ROOM, WHAT HAPPENED!!! ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#1
		"speaker": "you",
		"name": "",
		"text": "Who is messing with you? "
	},
	{
		#2
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "I don't know, but it looks like a job for Detective Tiggy and Travler. ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#3
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Drag the 14 different items into their perspective box, if its wrong it will be put back ready? ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#4
		"speaker": "you",
		"name": "",
		"text": "Let's Start! "
	},
	{
		#5
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Yay, wait I hear something, do you? ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#6
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Enter the ZEN GARDEN, NOW! ",
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
	
	if event.is_action_pressed("ui_accept") and !typing:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			if dialogue_index != 4:	
				dialogue_index += 1
				show_next_dialogue()
			
	elif event.is_action_pressed("ui_accept") and typing:
		skip_typing = true
		$Camera2D/Textbox/textlabel.visible_characters = $Camera2D/Textbox/textlabel.text.length()


func _on_you_pressed() -> void:
	if dialogue_index == 4:
			$Camera2D/you.visible = false
			$"game items".visible = true
			$bg.visible = false
			start_time = Time.get_ticks_msec()
			$"game items/Timer".start_timer()
			for item in $Messy.get_children():
				item.can_move = true
		
	if dialogue_index != 4:	
		dialogue_index += 1
		show_next_dialogue()


func _ready() -> void:
	show_next_dialogue()
	
func _process(delta: float) -> void:
	$"game items/count".text = str(ammount_in) + "/14"
	

func game_beat():
	SaveManager.room4 = true
	SaveManager.save_game(SaveManager.current_slot)
	$"game items/Timer".stop_timer()
	played = true
	dialogue_index = 5
	show_next_dialogue()
	$"game items".visible = false
	elapsed_time = (Time.get_ticks_msec() - start_time) / 1000
	print(elapsed_time)
	SaveManager.rMGtime = elapsed_time
	$stars.modulate.a = 0.0
	$stars.visible = true
	var tween1 = create_tween()
	tween1.tween_property($stars, "modulate:a", 1.0, 1.0)
	if elapsed_time < 35:
		$stars/Star1.modulate.a = 0.0
		var tween2 = create_tween()
		tween2.tween_property($stars/Star1, "modulate:a", 1.0, 1.0)
	if elapsed_time < 20:
		$stars/Star2.modulate.a = 0.0
		var tween3 = create_tween()
		tween3.tween_property($stars/Star2, "modulate:a", 1.0, 1.0)
	if elapsed_time < 12:
		$stars/Star3.modulate.a = 0.0
		var tween4 = create_tween()
		tween4.tween_property($stars/Star3, "modulate:a", 1.0, 1.0)

func _on_restart_pressed() -> void:
	for body in $Messy.get_children():
		body.dragging = false
		body.freeze = true
		body.linear_velocity = Vector2.ZERO
		body.angular_velocity = 0.0
		body.global_position = body.start_position
		body.gravity_scale = 0
