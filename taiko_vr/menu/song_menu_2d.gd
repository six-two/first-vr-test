extends PanelContainer

static var taiko_vr_play = preload("res://taiko_vr/taiko_xr_main.tscn")
var Highscores = preload("res://taiko_vr/songs/highscores.gd")
var SongScores = preload("res://taiko_vr/songs/score.gd")
var SongData = preload("res://taiko_vr/songs/song_data.gd")
var preview_remaining_seconds: float = 0
static var last_course = 0 # remember last difficulty

func _ready() -> void:
	for song_data in SongData.SONG_LIST:
		var high_score = Highscores.get_song_highscore(song_data)
		var rank = "[%s] " % SongScores.percent_to_rank(high_score.percent) if high_score else ""
		var song_menu_title = "%s%s by %s" % [rank, song_data.title, song_data.artist]
		$SplitContainer/ItemList.add_item(song_menu_title)
	
	# Select the first song by default
	$SplitContainer/ItemList.select(0)
	_on_item_list_item_selected(0)

func _on_item_list_item_selected(index: int) -> void:
	var selected_song = SongData.SONG_LIST[index]
	SongData.current_song = selected_song
	SongData.current_chart = selected_song.charts[0]
	print("Selected item:", selected_song.title)
	$SplitContainer/VBoxContainer/RichTextLabel.text = "Title: %s
Artist: %s
Length: %d seconds
BPM: %.1f
Source: %s" % [
	selected_song.title,
	selected_song.artist,
	selected_song.duration,
	selected_song.bpm,
	selected_song.source,
]

	# Show only matching difficulty buttons
	$SplitContainer/VBoxContainer/CourseSelector/EasyButton.visible = song_has_course(selected_song, 0)
	$SplitContainer/VBoxContainer/CourseSelector/NormalButton.visible = song_has_course(selected_song, 1)
	$SplitContainer/VBoxContainer/CourseSelector/HardButton.visible = song_has_course(selected_song, 2)
	$SplitContainer/VBoxContainer/CourseSelector/ExpertButton.visible = song_has_course(selected_song, 3)
	$SplitContainer/VBoxContainer/CourseSelector/MasterButton.visible = song_has_course(selected_song, 4)

	# Select a difficulty level
	for course in [last_course, 0, 1, 2, 3, 4]:
		if select_course(last_course):
			break

	$AudioStreamPlayer.stream = load(selected_song.song_file)
	$AudioStreamPlayer.play(TaikoConst.SONG_PREVIEW_OFFSET)
	preview_remaining_seconds = TaikoConst.SONG_PREVIEW_SECONDS

func _process(delta: float) -> void:
	if preview_remaining_seconds > 0:
		preview_remaining_seconds -= delta
		if preview_remaining_seconds <= 0:
			$AudioStreamPlayer.stop()

	# Play a preview of the song (lets say the beginning 5 seconds)

func song_has_course(song, course) -> bool:
	for chart in song.charts:
		if chart.course == course:
			return true
	return false

func select_course(course) -> bool:
	for chart in SongData.current_song.charts:
		if chart.course == course:
			SongData.current_chart = chart
			last_course = course
			
			var highscore = Highscores.get_chart_highscore(chart)
			var text
			if highscore:
				text = "Highscore: %.1f%%" % highscore.percent
				if highscore.all_perfect:
					text += " | All Perfect"
				elif highscore.full_combo:
					text += " | Full Combo"
			else:
				text = "Not played yet"
			$SplitContainer/VBoxContainer/HighscoreLabel.text = text

			return true
	return false


func _on_button_play_pressed():
	get_tree().change_scene_to_packed(taiko_vr_play)

# List of course values int -> string: https://gist.github.com/KatieFrogs/e000f406bbc70a12f3c34a07303eec8b#course
func _on_button_easy_pressed():
	select_course(0)

func _on_button_normal_pressed():
	select_course(1)

func _on_button_hard_pressed():
	select_course(2)

func _on_button_expert_pressed():
	select_course(3)

func _on_button_master_pressed():
	select_course(4)
