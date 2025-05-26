extends Node

## This class represents a library of songs.
## Each song has a remote URL from where it can be downloaded.
## After the song has been downloaded, it will be stored to be locally available.
## This should make it possible to easily import collections of songs by just importing an index instead of importing possibly thousands of songs.
## Only the songs the players actually play would then be downloaded and stored.
class SongIndex:
	## What game the song is for. Currently only "taiko" is implemented.
	var game: String
	## Absolute path to a directory where to store the downloaded song data. Each song will have a sub directory in this structure.
	var directory_name: String
	## The list of songs that this index contains
	var songs: Array[SongIndexEntry]
	
	func _init(_game: String, _directory_name: String, _songs: Array[SongIndexEntry]) -> void:
		self.game = _game
		self.directory_name = _directory_name
		self.songs = _songs
	
	## Deserialize from JSON
	static func from_json_dict(json_dict) -> SongIndex:
		var _game = json_dict["game"]
		var _directory_name = json_dict["directory_name"]
		var _songs: Array[SongIndexEntry] = []
		var index_directory = TaikoConst.SONG_INDEX_FOLDER.path_join(_directory_name)
		for song_json in json_dict["songs"]:
			var song = SongIndexEntry.from_json_dict(song_json, index_directory)
			if song:
				_songs.append(song)

		return SongIndex.new(_game, _directory_name, _songs)


## This represents a single song, that is part of a song index
class SongIndexEntry:
	## The title of the song
	var title: String
	## The name of the artist that created the song
	var artist: String
	## A path that all files belonging to this song should be stored in. @TODO: should be absolute
	var directory: String
	## A list of the chart difficulties available for this song
	var difficulties: Array[ChartDifficulty]
	## Whether the music and song data have been downloaded. Is intended mainly for song filtering
	var is_downloaded: bool
	## A link where to download the actual music (MP3, OGG, etc) file from
	var music_link: DownloadableFile
	## A link where to download the chart (TJA, etc) from
	var charts_link: DownloadableFile

	func _init(_title: String, _artist: String, _directory: String, _difficulties: Array[ChartDifficulty], _is_downloaded: bool, _music_link: DownloadableFile, _charts_link: DownloadableFile) -> void:
		self.title = _title
		self.artist = _artist
		self.directory = _directory
		self.difficulties = _difficulties
		self.is_downloaded = _is_downloaded
		self.music_link = _music_link
		self.charts_link = _charts_link

	## Deserialize from JSON
	static func from_json_dict(json_dict, song_index_directory: String) -> SongIndexEntry:
		# Serialized values
		var _title = json_dict["title"]
		var _artist = json_dict["artist"]
		var _directory = ("%s - %s" % [_artist, _title]).replace("/", "").replace("\\", "") # TODO sanitize
		while _directory.contains(".."): # Recursively remove double dots to prevent any path traversal attempts
			_directory = _directory.replace("..", "")
		_directory = song_index_directory.path_join(_directory)
		
		var _difficulties: Array[ChartDifficulty] = []
		for json_value in json_dict["difficulties"]:
			_difficulties.append(ChartDifficulty.from_json_dict(json_value))
		
		var _music_link = DownloadableFile.from_json_dict(json_dict["music"], _directory)
		var _charts_link = DownloadableFile.from_json_dict(json_dict["charts"], _directory)
		var _is_downloaded = _music_link.is_downloaded() and _charts_link.is_downloaded()
		return SongIndexEntry.new(_title, _artist, _directory, _difficulties, _is_downloaded, _music_link, _charts_link)


## Represents a downloadable file used in a SongIndex to reference to music and chart data.
## It may or may not be downloaded
class DownloadableFile:
	## The URL that the file can be downloaded from
	var url: String
	## The absolute path where the file will be stored as
	var path: String

	func _init(_url: String, _path: String) -> void:
		while _path.contains(".."): # Recursively remove double dots to prevent any path traversal attempts
			_path = _path.replace("..", "")
		self.url = _url
		self.path = _path
	
	func is_downloaded() -> bool:
		return FileAccess.file_exists(path)

	## Deserialize from JSON
	static func from_json_dict(json_dict, base_directory: String) -> DownloadableFile:
		var _url = json_dict["url"]
		# In the serialized form, this only contains the relative path from the song directory
		var _path = json_dict["path"]
		# Remove leading dashes that may be interpreted as absolute paths
		_path = _path.lstrip("/")
		_path = base_directory.path_join(_path)
		return DownloadableFile.new(_url, _path)

	## Serialize to JSON
	func to_json_dict(base_directory: String) -> Dictionary:
		return {
			"url": url,
			"path": path.trim_prefix(base_directory),
		}

## Represents how difficult a chart is
class ChartDifficulty:
	## This represents the difficulty options from 0 (easy) to 4 (master)
	var course: int
	## This represents how hard the chart actually is. For example a level 4 "easy" is harder than a level 3 "medium". Higher values mean more difficult
	var level: int

	func _init(_course: int, _level: int) -> void:
		self.course = _course
		self.level = _level

	## Deserialize from JSON
	static func from_json_dict(json_dict) -> ChartDifficulty:
		var _course = json_dict["course"]
		var _level = json_dict["level"]
		return ChartDifficulty.new(_course, _level)

	## Serialize to JSON
	func to_json_dict() -> Dictionary:
		return {
			"course": course,
			"level": level,
		}

## Non-Recursivly parse song indices from the given directory. By making it non-recursive, you can easily store the downloaded data in the same directory as the index files
static func parse_from_directory(path: String) -> Array[SongIndex]:
	var entries: Array[SongIndex] = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".json"):
				var entry = parse_song_index_file(path.path_join(file_name))
				if entry:
					entries.append(entry)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path: %s" % path)
	return entries

## Parse a song index file. May return null in case of errors
static func parse_song_index_file(path: String) -> SongIndex:
	var file = FileAccess.open(path, FileAccess.READ)
	var json_string = file.get_as_text()
	
	var json = JSON.new()
	# Check if there is any error while parsing the JSON string, skip in case of failure.
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print(path, "- JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return null

	return SongIndex.from_json_dict(json.data)
