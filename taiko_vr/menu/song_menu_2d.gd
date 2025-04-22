extends PanelContainer

static var taiko_vr_play = preload("res://taiko_vr/taiko_xr_main.tscn")
var SongData = preload("res://taiko_vr/songs/song_data.gd")
var selected_song

func _ready() -> void:
	for song_data in SongData.SONG_LIST:
		$SplitContainer/ItemList.add_item(song_data.song_name + " by " + song_data.artist)
	
	# Select the first song by default
	$SplitContainer/ItemList.select(0)
	_on_item_list_item_selected(0)

func _on_item_list_item_selected(index: int) -> void:
	var selected_song = SongData.SONG_LIST[index]
	SongData.current_song = selected_song
	print("Selected item:", selected_song.song_name)
	$SplitContainer/VBoxContainer/RichTextLabel.text = "Title: %s
Artist: %s
Length: %s
Speed: %s
Source: %s" % [
	selected_song.song_name,
	selected_song.artist,
	selected_song.notes_str.length() * selected_song.beat_seconds,
	1.0 / selected_song.beat_seconds,
	selected_song.source,
]

func _on_button_play_pressed():
	get_tree().change_scene_to_packed(taiko_vr_play)
