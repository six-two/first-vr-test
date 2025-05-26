extends PanelContainer

var SongData = preload("res://taiko_vr/songs/song_data.gd")
var SongIndex = preload("res://game/song_manager/song_index.gd")
const CustomSongs = preload("res://taiko_vr/songs/custom_song_parser.gd")
var downloadable_songs: Array = []
var selected_song
var remaining_requests

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
	print("[*] Song downloader: Selected song '%s'" % selected_song.title)
	update_song_description_textbox()

func update_song_description_textbox():
	var difficulty_text = ""
	for difficulty in selected_song.difficulties:
		difficulty_text += "- %s:%s\n" % [difficulty.course, difficulty.level]
	$SplitContainer/VBoxContainer/RichTextLabel.text = "Title: %s
Artist: %s
Music downloaded: %s
Charts downloaded: %s
Difficulties:
%s
" % [
	selected_song.title,
	selected_song.artist,
	selected_song.music_link.is_downloaded(),
	selected_song.charts_link.is_downloaded(),
	difficulty_text,
]

func _on_button_download_pressed():
	print("[*] Downloading song '%s' requested" % selected_song.title)
	if not selected_song.music_link.is_downloaded():
		$DownloadParent.download_from_url(selected_song.music_link.url, selected_song.music_link.path, on_file_downloaded)
	
	if not selected_song.charts_link.is_downloaded():
		$DownloadParent.download_from_url(selected_song.charts_link.url, selected_song.charts_link.path, on_file_downloaded)

	#print_tree_pretty()

func on_file_downloaded():
	update_song_description_textbox()

	if selected_song.music_link.is_downloaded() and selected_song.charts_link.is_downloaded():
		# Mark it as downloaded, so that it will not be shown if you reload the download dialog
		selected_song.is_downloaded = true
		# parse song and add to song list
		var tja_path = selected_song.charts_link.path
		var parsed_song = CustomSongs.handle_tja_song(tja_path.get_base_dir(), tja_path.get_file())
		SongData.SONG_LIST.append(parsed_song)


func _on_button_back_pressed():
	GlobalState.show_menu_room(get_tree(), "res://taiko_vr/menu/song_menu_2d.tscn")
