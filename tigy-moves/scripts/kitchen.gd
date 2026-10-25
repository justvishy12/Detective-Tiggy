extends Node2D
var fridge = false
var microwave = false
var all_moved = true
var can_open = true
var mix = false
var mixing = false
var mouse_moved = true
var mouse_position = Vector2(0,0)


var skip_typing = false
var dialogue = [
	{
		#0
		"speaker": "cat",
		"name": "Tusky",
		"text": "Can you help me? ",
		"portrait": preload("res://assets/headshots/TUSKY FACE.png")
	},
	{
		#1
		"speaker": "you",
		"name": "",
		"text": "With what tusky? "
	},
	{
		#2
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Drag all the items we need for the recipe to the countertop (click fridge to open)! ",
		"portrait": preload("res://assets/headshots/TUSKY FACE.png")
	},
	{
		#3
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Great, now move your cursor in the bowl to mix it! ",
		"portrait": preload("res://assets/headshots/TUSKY FACE.png")
	},
	{
		#4
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Yay, it's cooking, thank you so much! ",
		"portrait": preload("res://assets/headshots/TUSKY FACE.png")
	},
	{
		#5
		"speaker": "cat",
		"name": "Detective Tiggy",
		"text": "Ooh, that smells so good!",
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
	if event.is_action_pressed("ui_accept") and !typing:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			if dialogue_index == 5:
				SaveManager.cookie = true
				SaveManager.save_game(SaveManager.current_slot)
				fade_in()
			if dialogue_index !=2 and dialogue_index !=3:
				dialogue_index += 1
				show_next_dialogue()
			
	elif event.is_action_pressed("ui_accept") and typing:
		skip_typing = true
		$Camera2D/Textbox/textlabel.visible_characters = $Camera2D/Textbox/textlabel.text.length()


func _on_you_pressed() -> void:
	if dialogue_index == 1:
		$DesertRecipe.visible = true
	dialogue_index += 1
	show_next_dialogue()


func _ready() -> void:
	Global.change = false
	Global.changing()
	show_next_dialogue()
	
func check_ingredients():
	all_moved = true
	for item in get_tree().get_nodes_in_group("ingredients"):
		if item.global_position == item.start_position:
			all_moved = false
			break

	if all_moved:
		dialogue_index = 3
		show_next_dialogue()
		print("did")
		$Butter.visible = false
		$Chocolate.visible = false
		$Flour.visible = false
		$Vanila.visible = false
		$Sugar.visible = false
		$Egg.visible = false
		$"bg p".visible = true
		$Bowll2.visible = true
		$Mixed.visible = true
		$Unmixed.visible = true
		$Mixed.modulate.a = 0.0
		$Unmixed.modulate.a = 1.0
		mix = true

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
	if can_open == true:
		if microwave == false:
			$MicrowaveO.visible = true
			microwave = true
		elif microwave == true:
			$MicrowaveO.visible = false
			microwave = false





func _on_border_body_exited(body: Node2D) -> void:
	if body.is_in_group("ingredients"):
		print("out")
		body.dragging = false
		body.freeze = true
		body.gravity_scale = 0
		body.linear_velocity = Vector2.ZERO
		body.angular_velocity = 0.0

		body.global_position = body.start_position

		PhysicsServer2D.body_set_state(
			body.get_rid(),
			PhysicsServer2D.BODY_STATE_TRANSFORM,
			body.global_transform
		)


func fade_items():
	if mixing and mix:
		mouse_position = get_global_mouse_position()

		while $Mixed.modulate.a < 1.0 and mix and mixing:
			var current_position = get_global_mouse_position()

			if mouse_position.distance_to(current_position) > 1:
				mouse_moved = true
			else:
				mouse_moved = false
 
			if mouse_moved:
				$Mixed.modulate.a = min($Mixed.modulate.a + 0.01, 1.0)
				$Unmixed.modulate.a = 1.0 - $Mixed.modulate.a

			mouse_position = current_position
			await get_tree().create_timer(0.02).timeout

		if $Mixed.modulate.a >= 1.0:
			$Mixed.modulate.a = 1.0
			$Unmixed.modulate.a = 0.0
			$MicrowaveW.visible = true
			$"bg p".visible = false
			$Bowll2.visible = false
			$Mixed.visible = false
			$Unmixed.visible = false
			dialogue_index = 4
			show_next_dialogue()
			
func _on_mousemix_mouse_entered() -> void:
	mixing = true
	print("god")
	if mix:
		$Bowll.visible = false
		fade_items()


func _on_mousemix_mouse_exited() -> void:
	mixing = false

func fade_in():
	$fade.modulate.a = 0.0
	$fade.visible = true

	var tween = create_tween()
	tween.tween_property($fade, "modulate:a", 1.0, 1.0)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/end.tscn")
