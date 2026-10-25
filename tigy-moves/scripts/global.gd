extends Node2D
var fade = false
var music_player: AudioStreamPlayer
var music_player2: AudioStreamPlayer
var change = false
# Called when the node enters the scene tree for the first time.
func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player2 = AudioStreamPlayer.new()
	add_child(music_player2)
	changing()
	

	
func changing():
	music_player.stop()
	music_player2.stop()
	if change == false: 
		music_player.stream = load("res://audio/blossomBG.mp3")
		music_player.bus = "Music"
		music_player.volume_db = -5
		music_player.play()
	elif change == true:
		music_player2.stream = load("res://audio/suspenseBG.mp3")
		music_player2.bus = "Music"
		music_player2.volume_db = -5

		music_player2.play()
	
