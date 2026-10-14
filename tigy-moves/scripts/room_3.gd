extends Node2D
var recipie_pieces = 0
var m1 = false
var m2 = false
var m3 = false
var m4 = false
var m5 = false

var canm1 = false
var canm2 = false
var canm3 = false
var canm4 = false
var canm5 = false

var played = false

var skip_typing = false
var dialogue = [
	{
		#0
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "This is the kitchen, lets go look at my favorite recipe. ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#1
		"speaker": "you",
		"name": "",
		"text": "Where is it?"
	},
	{
		#2
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "It's right, WHO RIPPED IT!!! ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#3
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Find all the pieces by clicking them, and hover object to move them, good luck! ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#4
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Thanks, exit the room. ",
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
	if dialogue_index == 1 and played == false:
		played = true
		$AnimationPlayer.play("camerapan")

	if event.is_action_pressed("ui_accept") and !typing:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			if dialogue_index != 3 and dialogue_index != 4:
				dialogue_index += 1
				show_next_dialogue()
			elif dialogue_index == 3:
				$Camera2D/Textbox.visible = false
			
	elif event.is_action_pressed("ui_accept") and typing:
		skip_typing = true
		$Camera2D/Textbox/textlabel.visible_characters = $Camera2D/Textbox/textlabel.text.length()

func _on_you_pressed() -> void:
	if dialogue_index == 3:
		$AnimationPlayer.play("fade out")
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_file("res://scenes/sockMG.tscn")
		
		
	dialogue_index += 1
	show_next_dialogue()


func _ready() -> void:
	show_next_dialogue()
	$door.visible = false

func _process(delta: float) -> void:
	pass

func update_label():
	if recipie_pieces == 1:
		$ammount.text = "1/5"
	elif recipie_pieces == 2:
		$ammount.text = "2/5"
	elif recipie_pieces == 3:
		$ammount.text = "3/5"
	elif recipie_pieces == 4:
		$ammount.text = "4/5"
	elif recipie_pieces == 5:
		$ammount.text = "5/5"
		dialogue_index = 4
		SaveManager.kitchen = true
		SaveManager.save_game(SaveManager.current_slot)
		show_next_dialogue()
		$door.visible = true
		$AnimationPlayer.play("camerapan2")

#region button pressed
func _on_button_pressed() -> void:
	if m1 == false:
		$M1.visible = false
		m1 = true
		recipie_pieces += 1
		update_label()

func _on_button_2_pressed() -> void:
	if m2 == false:
		$M2.visible = false
		m2 = true
		recipie_pieces += 1
		update_label()

func _on_button_3_pressed() -> void:
	if m3 == false:
		$M3.visible = false
		m3 = true
		recipie_pieces += 1
		update_label()
		
func _on_button_4_pressed() -> void:
	if m4 == false:
		$M4.visible = false
		m4 = true
		recipie_pieces += 1
		update_label()
		
func _on_button_5_pressed() -> void:
	if m5 == false:
		$M5.visible = false
		m5 = true
		recipie_pieces += 1
		update_label()
		
#endregion

#region Move Objects

func _on_area_1_mouse_entered() -> void:
	if canm1 == false:
		canm1 = true
		
		var start_y = $Bottle.position.y
		var tween = create_tween()
		tween.tween_property($Bottle, "position:y", start_y - 50, 2)
		tween.tween_property($Bottle, "position:y", start_y, 1)
		tween.tween_property($Bottle, "position", Vector2(441, 177), 1)

func _on_area_1_mouse_exited() -> void:
	canm1 = false

func _on_area_2_mouse_entered() -> void:
	if canm2 == false:
		canm2 = true
		
		var start_x = $Jar.position.x
		var tween = create_tween()
		tween.tween_property($Jar, "position:x", start_x + 50, 2)
		tween.tween_property($Jar, "position", Vector2(540, 175), 1)

func _on_area_2_mouse_exited() -> void:
	canm2 = false

func _on_area_3_mouse_entered() -> void:
	if canm3 == false:
		canm3 = true
		
		var start_y = $Bottle1.position.y
		var tween = create_tween()
		tween.tween_property($Bottle1, "position:y", start_y - 50, 2)
		tween.tween_property($Bottle1, "position:y", start_y, 1)
		tween.tween_property($Bottle1, "position", Vector2(1096, 173), 1)
func _on_area_3_mouse_exited() -> void:
	canm3 = false

func _on_area_4_mouse_entered() -> void:
	if canm4 == false:
		canm4 = true
		
		var start_x = $Mixer.position.x
		var tween = create_tween()
		tween.tween_property($Mixer, "position:x", start_x - 50, 2)
		tween.tween_property($Mixer, "position:x", start_x, 1)
		tween.tween_property($Mixer, "position", Vector2(519, 464), 1)

func _on_area_4_mouse_exited() -> void:
	canm4 = false
#endregion


func _on_door_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/room2.tscn")
