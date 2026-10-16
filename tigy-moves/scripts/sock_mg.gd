extends Node2D

#region game variables
@onready var a1 = [$Moveables/RS1, "R"]
@onready var a2 = [$Moveables/PS1, "P"]
@onready var a3 = [$Moveables/BS1, "B"]
@onready var a4 = [$Moveables/PS2, "P"]
#Row 2
@onready var b1 = [$Moveables/BS2, "B"]
@onready var b2 = [$Moveables/RS2, "R"]
@onready var b3 = [$Moveables/PS3, "P"]
@onready var b4 = [$Moveables/BS3, "B"]
#Row 3
@onready var c1 = [$Moveables/RS3, "R"]
@onready var c2 = [$Moveables/PS4, "P"]
@onready var c3 = [$Moveables/RS4, "R"]
@onready var c4 = [$Moveables/BS4, "B"]
#Row 4
@onready var d1 = [$Empty, "E"]
@onready var d2 = [$Empty, "E"]
@onready var d3 = [$Empty, "E"]
@onready var d4 = [$Empty, "E"]

var a1_pos = Vector2(154, 199)
var a2_pos = Vector2(154, 339)
var a3_pos = Vector2(154, 482)
var a4_pos = Vector2(154, 619)
var b1_pos = Vector2(479, 199)
var b2_pos = Vector2(479, 339)
var b3_pos = Vector2(479, 482)
var b4_pos = Vector2(479, 619)
var c1_pos = Vector2(802, 199)
var c2_pos = Vector2(802, 339)
var c3_pos = Vector2(802, 482)
var c4_pos = Vector2(802, 619)
var d1_pos = Vector2(1130, 199)
var d2_pos = Vector2(1130, 339)
var d3_pos = Vector2(1130, 482)
var d4_pos = Vector2(1130, 619)

var dragginga1 = false
var ofa1 = Vector2(0,0)
var in_zonea1 = false
var dragginga2 = false
var ofa2 = Vector2(0,0)
var in_zonea2 = false
var dragginga3 = false
var ofa3 = Vector2(0,0)
var in_zonea3 = false
var dragginga4 = false
var ofa4 = Vector2(0,0)
var in_zonea4 = false

var draggingb1 = false
var ofb1 = Vector2(0,0)
var in_zoneb1 = false
var draggingb2 = false
var ofb2 = Vector2(0,0)
var in_zoneb2 = false
var draggingb3 = false
var ofb3 = Vector2(0,0)
var in_zoneb3 = false
var draggingb4 = false
var ofb4 = Vector2(0,0)
var in_zoneb4 = false

var draggingc1 = false
var ofc1 = Vector2(0,0)
var in_zonec1 = false
var draggingc2 = false
var ofc2 = Vector2(0,0)
var in_zonec2 = false
var draggingc3 = false
var ofc3 = Vector2(0,0)
var in_zonec3 = false
var draggingc4 = false
var ofc4 = Vector2(0,0)
var in_zonec4 = false

var draggingd1 = false
var ofd1 = Vector2(0,0)
var in_zoned1 = false
var draggingd2 = false
var ofd2 = Vector2(0,0)
var in_zoned2 = false
var draggingd3 = false
var ofd3 = Vector2(0,0)
var in_zoned3 = false
var draggingd4 = false
var ofd4 = Vector2(0,0)
var in_zoned4 = false

var A = false
var B = false
var C = false
var D = false
var end = false

@onready var Buttons = [$Buttons/A1, $Buttons/A2,$Buttons/A3,$Buttons/A4,$Buttons/B1,$Buttons/B2,$Buttons/B3,$Buttons/B4,$Buttons/C1,$Buttons/C2,$Buttons/C3,$Buttons/C4,$Buttons/D1,$Buttons/D2,$Buttons/D3,$Buttons/D4]
#endregion

var start_time: int
var elapsed_time: int
var skip_typing = false
var dialogue = [
	{
		#0
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "This is the sock basket, your job is to organize it. ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#1
		"speaker": "you",
		"name": "",
		"text": "Okay"
	},
	{
		#2
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Drag socks into different collumns, each can hold 4. ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#3
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "To finish, three collumn should have socks of same color, with one empty, got it? ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
	},
	{
		#4
		"speaker": "you",
		"name": "",
		"text": "Yeah, lets start!"
	},
	{
		#5
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "You did it, lets move on! ",
		"portrait": preload("res://assets/headshots/TIGGY FACE.png")
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
	if dialogue_index == 6:
		SaveManager.sockMG = true
		SaveManager.save_game(SaveManager.current_slot)
		$AnimationPlayer.play("fade out")
		get_tree().change_scene_to_file("res://scenes/room2.tscn")
	if event.is_action_pressed("ui_accept") and !typing:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			dialogue_index += 1
			show_next_dialogue()
			
	elif event.is_action_pressed("ui_accept") and typing:
		skip_typing = true
		$Textbox/textlabel.visible_characters = $Textbox/textlabel.text.length()


func _on_you_pressed() -> void:
	if dialogue_index != 4:
		dialogue_index += 1
		show_next_dialogue()
	if dialogue_index == 4:
		$Panel.visible = false
		$you.visible = false
		$Timer.start_timer()
		$Panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		start_time = Time.get_ticks_msec()
		
func _ready() -> void:
	SaveManager.room1 = true
	SaveManager.save_game(SaveManager.current_slot)
	show_next_dialogue()
	
func _process(delta: float) -> void:
	if a1[1] == a2[1] and a2[1] == a3[1] and a3[1] == a4[1]:
		A = true
	else:
		A = false
	if b1[1] == b2[1] and b2[1] == b3[1] and b3[1] == b4[1]:
		B = true
	else:
		B = false
	if c1[1] == c2[1] and c2[1] == c3[1] and c3[1] == c4[1]:
		C = true
	else:
		C = false
	if d1[1] == d2[1] and d2[1] == d3[1] and d3[1] == d4[1]:
		D = true
	else:
		D = false
	if A and B and C and D and end == false:
		end = true
		elapsed_time = (Time.get_ticks_msec() - start_time) / 1000
		print(elapsed_time)
		SaveManager.sMGtime = elapsed_time
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
			
		$Timer.stop_timer()
		$Panel.mouse_filter = Control.MOUSE_FILTER_STOP
		SaveManager.sockMG = true
		SaveManager.save_game(SaveManager.current_slot)
		dialogue_index = 5
		show_next_dialogue()
#region dragging
	if dragginga1:
		a1[0].global_position = get_global_mouse_position() - ofa1
	if dragginga2:
		a2[0].global_position = get_global_mouse_position() - ofa2
	if dragginga3:
		a3[0].global_position = get_global_mouse_position() - ofa3
	if dragginga4:
		a4[0].global_position = get_global_mouse_position() - ofa4
	if draggingb1:
		b1[0].global_position = get_global_mouse_position() - ofb1
	if draggingb2:
		b2[0].global_position = get_global_mouse_position() - ofb2
	if draggingb3:
		b3[0].global_position = get_global_mouse_position() - ofb3
	if draggingb4:
		b4[0].global_position = get_global_mouse_position() - ofb4
	if draggingc1:
		c1[0].global_position = get_global_mouse_position() - ofc1
	if draggingc2:
		c2[0].global_position = get_global_mouse_position() - ofc2
	if draggingc3:
		c3[0].global_position = get_global_mouse_position() - ofc3
	if draggingc4:
		c4[0].global_position = get_global_mouse_position() - ofc4
	if draggingd1:
		d1[0].global_position = get_global_mouse_position() - ofd1
	if draggingd2:
		d2[0].global_position = get_global_mouse_position() - ofd2
	if draggingd3:
		d3[0].global_position = get_global_mouse_position() - ofd3
	if draggingd4:
		d4[0].global_position = get_global_mouse_position() - ofd4
#endregion


#region but down
func _on_a_1_button_down() -> void:
	if a1[0] != $Empty:
		dragginga1 = true
		ofa1 = get_global_mouse_position() - a1[0].global_position
		print("works")

func _on_a_2_button_down() -> void:
	if a2[0] != $Empty:
		dragginga2 = true
		ofa2 = get_global_mouse_position() - a2[0].global_position

func _on_a_3_button_down() -> void:
	if a3[0] != $Empty:
		dragginga3 = true
		ofa3 = get_global_mouse_position() - a3[0].global_position


func _on_a_4_button_down() -> void:
	if a4[0] != $Empty:
		dragginga4 = true
		ofa4 = get_global_mouse_position() - a4[0].global_position


func _on_b_1_button_down() -> void:
	if b1[0] != $Empty:
		draggingb1 = true
		ofb1 = get_global_mouse_position() - b1[0].global_position


func _on_b_2_button_down() -> void:
	if b2[0] != $Empty:
		draggingb2 = true
		ofb2 = get_global_mouse_position() - b2[0].global_position


func _on_b_3_button_down() -> void:
	if b3[0] != $Empty:
		draggingb3 = true
		ofb3 = get_global_mouse_position() - b3[0].global_position


func _on_b_4_button_down() -> void:
	if b4[0] != $Empty:
		draggingb4 = true
		ofb4 = get_global_mouse_position() - b4[0].global_position


func _on_c_1_button_down() -> void:
	if c1[0] != $Empty:
		draggingc1 = true
		ofc1 = get_global_mouse_position() - c1[0].global_position

func _on_c_2_button_down() -> void:
	if c2[0] != $Empty:
		draggingc2 = true
		ofc2 = get_global_mouse_position() - c2[0].global_position


func _on_c_3_button_down() -> void:
	if c3[0] != $Empty:
		draggingc3 = true
		ofc3 = get_global_mouse_position() - c3[0].global_position


func _on_c_4_button_down() -> void:
	if c4[0] != $Empty:
		draggingc4 = true
		ofc4 = get_global_mouse_position() - c4[0].global_position


func _on_d_1_button_down() -> void:
	if d1[0] != $Empty:
		draggingd1 = true
		ofd1 = get_global_mouse_position() - d1[0].global_position


func _on_d_2_button_down() -> void:
	if d2[0] != $Empty:
		draggingd2 = true
		ofd2 = get_global_mouse_position() - d2[0].global_position


func _on_d_3_button_down() -> void:
	if d3[0] != $Empty:
		draggingd3 = true
		ofd3 = get_global_mouse_position() - d3[0].global_position


func _on_d_4_button_down() -> void:
	if d4[0] != $Empty:
		draggingd4 = true
		ofd4 = get_global_mouse_position() - d4[0].global_position


#endregion


#region but up
func _on_a_1_button_up() -> void:
	dragginga1 = false
	if a1[1] == "E":
		pass
	elif a1[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = a1[0]
			b4[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = a1[0]
			b3[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = a1[0]
			b2[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = a1[0]
			b1[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			b1[0].position = b1_pos
		else:
			a1[0].position = a1_pos
	elif a1[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = a1[0]
			c4[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = a1[0]
			c3[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = a1[0]
			c2[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = a1[0]
			c1[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			c1[0].position = c1_pos
		else:
			a1[0].position = a1_pos
	elif a1[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = a1[0]
			d4[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = a1[0]
			d3[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = a1[0]
			d2[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = a1[0]
			d1[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			d1[0].position = d1_pos
		else:
			a1[0].position = a1_pos
	else:
		a1[0].position = a1_pos


func _on_a_2_button_up() -> void:
	dragginga2 = false
	if a2[1] == "E":
		pass
	elif a2[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = a2[0]
			b4[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = a2[0]
			b3[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = a2[0]
			b2[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = a2[0]
			b1[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			b1[0].position = b1_pos
		else:
			a2[0].position = a2_pos
	elif a2[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = a2[0]
			c4[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = a2[0]
			c3[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = a2[0]
			c2[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = a2[0]
			c1[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			c1[0].position = c1_pos
		else:
			a2[0].position = a2_pos
	elif a2[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = a2[0]
			d4[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = a2[0]
			d3[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = a2[0]
			d2[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = a2[0]
			d1[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			d1[0].position = d1_pos
		else:
			a2[0].position = a2_pos
	else:
		a2[0].position = a2_pos

func _on_a_3_button_up() -> void:
	dragginga3 = false
	if a3[1] == "E":
		pass
	elif a3[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = a3[0]
			b4[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = a3[0]
			b3[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = a3[0]
			b2[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = a3[0]
			b1[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			b1[0].position = b1_pos
		else:
			a3[0].position = a3_pos
	elif a3[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = a3[0]
			c4[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = a3[0]
			c3[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = a3[0]
			c2[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = a3[0]
			c1[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			c1[0].position = c1_pos
		else:
			a3[0].position = a3_pos
	elif a3[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = a3[0]
			d4[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = a3[0]
			d3[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = a3[0]
			d2[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = a3[0]
			d1[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			d1[0].position = d1_pos
		else:
			a3[0].position = a3_pos
	else:
		a3[0].position = a3_pos

func _on_a_4_button_up() -> void:
	dragginga4 = false
	if a4[1] == "E":
		pass
	elif a4[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = a4[0]
			b4[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = a4[0]
			b3[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = a4[0]
			b2[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = a4[0]
			b1[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			b1[0].position = b1_pos
		else:
			a4[0].position = a4_pos
	elif a4[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = a4[0]
			c4[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = a4[0]
			c3[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = a4[0]
			c2[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = a4[0]
			c1[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			c1[0].position = c1_pos
		else:
			a4[0].position = a4_pos
	elif a4[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = a4[0]
			d4[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = a4[0]
			d3[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = a4[0]
			d2[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = a4[0]
			d1[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			d1[0].position = d1_pos
		else:
			a4[0].position = a4_pos
	else:
		a4[0].position = a4_pos


func _on_b_1_button_up() -> void:
	draggingb1 = false
	if b1[1] == "E":
		pass
	elif b1[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = b1[0]
			a4[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = b1[0]
			a3[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = b1[0]
			a2[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = b1[0]
			a1[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			a1[0].position = a1_pos
		else:
			b1[0].position = b1_pos
	elif b1[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = b1[0]
			c4[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = b1[0]
			c3[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = b1[0]
			c2[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = b1[0]
			c1[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			c1[0].position = c1_pos
		else:
			b1[0].position = b1_pos
	elif b1[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = b1[0]
			d4[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = b1[0]
			d3[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = b1[0]
			d2[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = b1[0]
			d1[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			d1[0].position = d1_pos
		else :
			b1[0].position = b1_pos
	else:
		b1[0].position = b1_pos

func _on_b_2_button_up() -> void:
	draggingb2 = false
	if b2[1] == "E":
		pass
	elif b2[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		print("r1")
		if a4[0] == $Empty:
			a4[0] = b2[0]
			a4[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = b2[0]
			a3[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = b2[0]
			a2[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = b2[0]
			a1[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			a1[0].position = a1_pos
		else :
			b2[0].position = b2_pos
	elif b2[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		print("r3")
		if c4[0] == $Empty:
			c4[0] = b2[0]
			c4[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = b2[0]
			c3[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = b2[0]
			c2[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = b2[0]
			c1[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			c1[0].position = c1_pos
		else :
			b2[0].position = b2_pos
	elif b2[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = b2[0]
			d4[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = b2[0]
			d3[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = b2[0]
			d2[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = b2[0]
			d1[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			d1[0].position = d1_pos
		else :
			b2[0].position = b2_pos
	else:
		b2[0].position = b2_pos

func _on_b_3_button_up() -> void:
	draggingb3 = false
	if b3[1] == "E":
		pass
	elif b3[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = b3[0]
			a4[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = b3[0]
			a3[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = b3[0]
			a2[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = b3[0]
			a1[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			a1[0].position = a1_pos
		else :
			b3[0].position = b3_pos
	elif b3[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = b3[0]
			c4[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = b3[0]
			c3[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = b3[0]
			c2[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = b3[0]
			c1[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			c1[0].position = c1_pos
		else :
			b3[0].position = b3_pos
	elif b3[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = b3[0]
			d4[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = b3[0]
			d3[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = b3[0]
			d2[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = b3[0]
			d1[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			d1[0].position = d1_pos
		else :
			b3[0].position = b1_pos
	else:
		b3[0].position = b3_pos

func _on_b_4_button_up() -> void:
	draggingb4 = false
	if b4[1] == "E":
		pass
	elif b4[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = b4[0]
			a4[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = b4[0]
			a3[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = b4[0]
			a2[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = b4[0]
			a1[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			a1[0].position = a1_pos
		else:
			b4[0].position = b4_pos
	elif b4[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = b4[0]
			c4[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = b4[0]
			c3[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = b4[0]
			c2[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = b4[0]
			c1[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			c1[0].position = c1_pos
		else:
			b4[0].position = b4_pos
	elif b4[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = b4[0]
			d4[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = b4[0]
			d3[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = b4[0]
			d2[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = b4[0]
			d1[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			d1[0].position = d1_pos
		else:
			b4[0].position = b4_pos
		
		
	else:
		b4[0].position = b4_pos



func _on_c_1_button_up() -> void:
	draggingc1 = false
	if c1[1] == "E":
		pass
	elif c1[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = c1[0]
			a4[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = c1[0]
			a3[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = c1[0]
			a2[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = c1[0]
			a1[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			a1[0].position = a1_pos
		else:
			c1[0].position = c1_pos
	elif c1[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = c1[0]
			b4[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = c1[0]
			b3[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = c1[0]
			b2[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = c1[0]
			b1[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			b1[0].position = b1_pos
		else:
			c1[0].position = c1_pos
	elif c1[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		print("row4")
		if d4[0] == $Empty:
			d4[0] = c1[0]
			d4[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = c1[0]
			d3[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = c1[0]
			d2[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = c1[0]
			d1[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			d1[0].position = d1_pos
		else:
			c1[0].position = c1_pos
	else:
			c1[0].position = c1_pos

func _on_c_2_button_up() -> void:
	draggingc2 = false
	if c2[1] == "E":
		pass
	elif c2[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = c2[0]
			a4[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = c2[0]
			a3[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = c2[0]
			a2[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = c2[0]
			a1[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			a1[0].position = a1_pos
		else:
			c2[0].position = c2_pos
	elif c2[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = c2[0]
			b4[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = c2[0]
			b3[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty :
			b2[0] = c2[0]
			b2[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = c2[0]
			b1[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			b1[0].position = b1_pos
		else:
			c2[0].position = c2_pos
	elif c2[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = c2[0]
			d4[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = c2[0]
			d3[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = c2[0]
			d2[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = c2[0]
			d1[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			d1[0].position = d1_pos
		else:
			c2[0].position = c2_pos
	else:
		c2[0].position = c2_pos

func _on_c_3_button_up() -> void:
	draggingc3 = false
	if c3[1] == "E":
		pass
	elif c3[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = c3[0]
			a4[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = c3[0]
			a3[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = c3[0]
			a2[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = c3[0]
			a1[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			a1[0].position = a1_pos
		else:
			c3[0].position = c3_pos
	elif c3[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = c3[0]
			b4[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = c3[0]
			b3[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = c3[0]
			b2[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = c3[0]
			b1[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			b1[0].position = b1_pos
		else:
			c3[0].position = c3_pos
	elif c3[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = c3[0]
			d4[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = c3[0]
			d3[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = c3[0]
			d2[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = c3[0]
			d1[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			d1[0].position = d1_pos
		else:
			c3[0].position = c3_pos
	else:
		c3[0].position = c3_pos

func _on_c_4_button_up() -> void:
	draggingc4 = false
	if c4[1] == "E":
		pass
	elif c4[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = c4[0]
			a4[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = c4[0]
			a3[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = c4[0]
			a2[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = c4[0]
			a1[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			a1[0].position = a1_pos
		else:
			c4[0].position = c4_pos
	elif c4[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = c4[0]
			b4[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = c4[0]
			b3[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = c4[0]
			b2[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = c4[0]
			b1[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			b1[0].position = b1_pos
		else:
			c4[0].position = c4_pos
	elif c4[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = c4[0]
			d4[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = c4[0]
			d3[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = c4[0]
			d2[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = c4[0]
			d1[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			d1[0].position = d1_pos
		else:
			c4[0].position = c4_pos
	else:
		c4[0].position = c4_pos

func _on_d_1_button_up() -> void:
	draggingd1 = false
	if d1[1] == "E":
		pass
	elif d1[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = d1[0]
			a4[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = d1[0]
			a3[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = d1[0]
			a2[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = d1[0]
			a1[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			a1[0].position = a1_pos
		else:
			d1[0].position = d1_pos
	elif d1[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = d1[0]
			b4[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = d1[0]
			b3[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = d1[0]
			b2[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = d1[0]
			b1[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			b1[0].position = b1_pos
		else:
			d1[0].position = d1_pos
	elif d1[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = d1[0]
			c4[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = d1[0]
			c3[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = d1[0]
			c2[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = d1[0]
			c1[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			c1[0].position = c1_pos
		else:
			d1[0].position = d1_pos
	else:
		d1[0].position = d1_pos
func _on_d_2_button_up() -> void:
	draggingd2 = false
	if d2[1] == "E":
		pass
	elif d2[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = d2[0]
			a4[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = d2[0]
			a3[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = d2[0]
			a2[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = d2[0]
			a1[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			a1[0].position = a1_pos
		else:
			d2[0].position = d2_pos
	elif d2[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = d2[0]
			b4[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = d2[0]
			b3[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = d2[0]
			b2[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = d2[0]
			b1[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			b1[0].position = b1_pos
		else:
			d2[0].position = d2_pos
	elif d2[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = d2[0]
			c4[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = d2[0]
			c3[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = d2[0]
			c2[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = d2[0]
			c1[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			c1[0].position = c1_pos
		else:
			d2[0].position = d2_pos
	else:
		d2[0].position = d2_pos
func _on_d_3_button_up() -> void:
	draggingd3 = false
	if d3[1] == "E":
		pass
	elif d3[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = d3[0]
			a4[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = d3[0]
			a3[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = d3[0]
			a2[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = d3[0]
			a1[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			a1[0].position = a1_pos
		else:
			d3[0].position = d3_pos
	elif d3[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = d3[0]
			b4[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = d3[0]
			b3[1] = d3[1]
			b1[0] = $Empty
			d3[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = d3[0]
			b2[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = d3[0]
			b1[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			b1[0].position = b1_pos
		else:
			d3[0].position = d3_pos
	elif d3[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = d3[0]
			c4[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = d3[0]
			c3[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = d3[0]
			c2[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = d3[0]
			c1[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			c1[0].position = c1_pos
		else:
			d3[0].position = d3_pos
	else:
		d3[0].position = d3_pos

func _on_d_4_button_up() -> void:
	draggingd4 = false
	if d4[1] == "E":
		pass
	elif d4[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = d4[0]
			a4[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = d4[0]
			a3[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = d4[0]
			a2[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = d4[0]
			a1[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			a1[0].position = a1_pos
		else:
			d4[0].position = d4_pos
	elif d4[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = d4[0]
			b4[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = d4[0]
			b3[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = d4[0]
			b2[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = d4[0]
			b1[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			b1[0].position = b1_pos
		else:
			d4[0].position = d4_pos
	elif d4[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = d4[0]
			c4[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = d4[0]
			c3[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = d4[0]
			c2[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = d4[0]
			c1[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			c1[0].position = c1_pos
		else:
			d4[0].position = d4_pos
	else:
		d4[0].position = d4_pos
#endregion
