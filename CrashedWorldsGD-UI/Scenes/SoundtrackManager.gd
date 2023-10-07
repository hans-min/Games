extends Node

var players: Array
var current_player = 0

func _ready():
	players = [$AudioStreamPlayer,
	$AudioStreamPlayer2,
	$AudioStreamPlayer3,
	$AudioStreamPlayer4,
	$AudioStreamPlayer5,
	$AudioStreamPlayer6,
	$AudioStreamPlayer7,
	$AudioStreamPlayer8]
	play_next_track()

func _process(_delta):
	if not players[current_player].playing:
		play_next_track()
	if Input.is_action_just_pressed("SkipTrack"):
		play_next_track()

func play_next_track():
	players[current_player].stop()
	current_player = (current_player + 1) % players.size()
	print("Currently playing : " + players[current_player].name)
	players[current_player].play()
