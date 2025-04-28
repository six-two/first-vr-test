extends Node

var SongData = preload("res://taiko_vr/songs/song_data.gd")
var SongScore = preload("res://taiko_vr/songs/score.gd")
var TjaParser = preload("res://taiko_vr/songs/tja_parser/parser.gd")
var hide_note_feedback_in_seconds: float = 0
var started = false

func _ready():
	var drumb = $Drumb/Head
	var script = load("res://vr_controls/change_controller_color_listener.gd").new()
	script.init(drumb)
	set_note_feedback("")
	
	$AudioStreamPlayer.stream = load(SongData.current_song.song_file)
	SongData.current_score = SongScore.BasicScore.new()

	#var notes = TjaParser.parse_tja_notes("res://taiko_vr/songs/tja_parser/demo.tja")
	#print("12345678")
	#for segment in notes:
		#print(segment)
	#print("12345678")

func set_note_feedback(text):
	$JudgementLine/NoteFeedback.text = text
	$JudgementLine/NoteFeedback.visible = true
	hide_note_feedback_in_seconds = TaikoConst.NOTE_FEEDBACK_DISPLAY_SECONDS

func _on_note_miss(input_type, node):
	var node_str = node.to_str() if node else "null"
	print("Note: Miss (", input_type, " / ", node_str, ")")
	SongData.current_score.miss += 1
	set_note_feedback("Miss")

func _on_note_ok():
	print("Note: OK")
	SongData.current_score.ok += 1
	set_note_feedback("Ok")
	
func _on_note_perfect():
	print("Note: Perfect")
	SongData.current_score.perfect += 1
	set_note_feedback("Perfect")

func _on_song_started():
	print("Song started")
	$AudioStreamPlayer.play()
	$IntroLabel3D.visible = false

func _on_song_finished():
	print("Song finished")
	GlobalState.show_menu_room(get_tree(), "res://taiko_vr/menu/score_screen.tscn")

func _process(delta: float) -> void:
	hide_note_feedback_in_seconds -= delta
	if hide_note_feedback_in_seconds <= 0:
		$JudgementLine/NoteFeedback.visible = false
