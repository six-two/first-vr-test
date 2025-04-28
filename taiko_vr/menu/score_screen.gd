extends PanelContainer

var SongData = preload("res://taiko_vr/songs/song_data.gd")
var Highscores = preload("res://taiko_vr/songs/highscores.gd")
var Score = preload("res://taiko_vr/songs/score.gd")
var scene_replay_song = preload("res://taiko_vr/taiko_xr_main.tscn")

func _ready():	
	var score = Score.basic_to_full_score(SongData.current_score)
	Highscores.update(SongData.current_chart, score)

	$VBoxContainer/Rank.text = score.rank
	$VBoxContainer/Combo.text = score.description
	$VBoxContainer/Details.text = "Perfect: %s\nOK: %s\nMiss: %s" % [score.perfect, score.ok, score.miss]

func _on_button_replay_pressed():
	print("Replay Song")
	get_tree().change_scene_to_packed(scene_replay_song)

func _on_button_menu_pressed():
	print("Return to Menu")
	GlobalState.show_menu_room(get_tree(), "res://taiko_vr/menu/song_menu_2d.tscn")
