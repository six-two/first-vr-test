extends Node

static var TjaParser = preload("res://taiko_vr/songs/tja_parser/parser.gd")

static func parse_from_directory(path: String):
	var songs = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and file_name != "." and file_name != "..":
				songs += parse_from_directory(path.path_join(file_name))
			elif file_name.ends_with(".tja"):
				var song = handle_tja_song(path, file_name)
				songs.append(song)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")
	return songs

static func handle_tja_song(base_dir: String, filename: String):
	var tja_file = base_dir.path_join(filename)
	print("custom_song_parser: Parsing TJA file ", tja_file)
	var song = TjaParser.parse_tja_song(tja_file)
	# convert relative path to full path
	if song.song_file and not song.song_file.begins_with("/"):
		song.song_file = base_dir.path_join(song.song_file)
	return song
