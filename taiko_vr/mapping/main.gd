extends Node

#var mapping_mode : bool = false
#var SongData = preload("res://taiko_vr/songs/song_data.gd")
#
#func _ready():
	#var drumb = $Drumb/Head
	#var script = load("res://taiko_vr/change_controller_color_listener.gd").new()
	#script.init(drumb)
	#
	#$AudioStreamPlayer.stream = null # @TODO
	#$AudioStreamPlayer.play()
	#SongData.current_score = SongData.SongScore.new()
	#
	#if mapping_mode:
		#$JudgementLine.set_script(load("res://taiko_vr/mapping_mode.gd"))
		#$JudgementLine.init(20, 0.20, drumb)
		#$JudgementLine.set_process(true)
	#else:
		#$JudgementLine.set_script(load("res://taiko_vr/note_spawner.gd"))
		#$JudgementLine.init(drumb)
		#$JudgementLine.set_process(true)
		#
		#$JudgementLine.connect("song_finished", _on_song_finished)
		#$JudgementLine.connect("note_miss", _on_note_miss)
		#$JudgementLine.connect("note_ok", _on_note_ok)
		#$JudgementLine.connect("note_perfect", _on_note_perfect)
#
#func _on_note_miss(input_type, node):
	#var node_str = node.to_str() if node else "null"
	#print("Note: Miss (", input_type, " / ", node_str, ")")
	#SongData.current_score.miss += 1
#
#func _on_note_ok():
	#print("Note: OK")
	#SongData.current_score.ok += 1
	#
#func _on_note_perfect():
	#print("Note: Perfect")
	#SongData.current_score.perfect += 1
#
#func _on_song_finished():
	#print("Song finished")
	#GlobalState.show_menu_room(get_tree(), "res://taiko_vr/menu/score_screen.tscn")
