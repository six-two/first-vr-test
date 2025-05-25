extends PanelContainer

var SongData = preload("res://taiko_vr/songs/song_data.gd")
var SongIndex = preload("res://game/song_manager/song_index.gd")
var downloadable_songs: Array = []
var selected_song

func _ready() -> void:
	for song_index in SongData.SONG_INDICES:
		for song_entry in song_index.songs:
			if not song_entry.is_downloaded:
				downloadable_songs.append(song_entry)
				var song_menu_title = "%s by %s" % [song_entry.title, song_entry.artist]
				$SplitContainer/ItemList.add_item(song_menu_title)

	if downloadable_songs.size() > 0:
		# Select the first song by default
		$SplitContainer/ItemList.select(0)
		_on_item_list_item_selected(0)

func _on_item_list_item_selected(index: int) -> void:
	selected_song = downloadable_songs[index]
	var difficulty_text = ""
	for difficulty in selected_song.difficulties:
		difficulty_text += "- %s:%s\n" % [difficulty.course, difficulty.level]
	print("Selected item:", selected_song.title)
	$SplitContainer/VBoxContainer/RichTextLabel.text = "Title: %s
Artist: %s
Difficulties:
%s
" % [
	selected_song.title,
	selected_song.artist,
	difficulty_text,
]

func _on_button_download_pressed():
	print("TODO download from:")
	print(selected_song.music_link.url)
	print(selected_song.charts_link.url)

func _on_button_back_pressed():
	GlobalState.show_menu_room(get_tree(), "res://taiko_vr/menu/song_menu_2d.tscn")
