extends PanelContainer

var SongData = preload("res://taiko_vr/songs/song_data.gd")
var scene_replay_song = preload("res://taiko_vr/taiko_xr_main.tscn")

func _ready():
	var perfect = SongData.current_score.perfect
	var ok = SongData.current_score.ok
	var miss = SongData.current_score.miss
	
	var score = perfect + 0.5 * ok
	var count = perfect + ok + miss
	var percent = 100 * (score / count)
	
	var rank
	var combo
	if ok == 0 and miss == 0:
		combo = "All Perfect"
	elif miss == 0:
		combo = "Full Combo"
	else:
		combo = "%.1f%%" % percent
	
	# Inspired partially by https://myjian.github.io/mai-tools/rating-visualizer/, to be tweaked later
	if percent > 99:
		rank = "SS"
	elif percent > 97:
		rank = "S"
	elif percent > 94:
		rank = "AAA"
	elif percent > 90:
		rank = "AA"
	elif percent > 80:
		rank = "A"
	elif percent > 70:
		rank = "B"
	elif percent > 60:
		rank = "C"
	else:
		rank = "D"
	
	$VBoxContainer/Rank.text = rank
	$VBoxContainer/Combo.text = combo
	$VBoxContainer/Details.text = "Perfect: %s\nOK: %s\nMiss: %s" % [perfect, ok, miss]

func _on_button_replay_pressed():
	print("Replay Song")
	get_tree().change_scene_to_packed(scene_replay_song)

func _on_button_menu_pressed():
	print("Return to Menu")
	GlobalState.show_menu_room(get_tree(), "res://taiko_vr/menu/song_menu_2d.tscn")
