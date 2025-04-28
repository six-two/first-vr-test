extends Node


class Note:
	var type: String
	var time: float

	func _init(_type: String, _time: float) -> void:
		self.type = _type
		self.time = _time

class Chart:
	var course: int
	var level: int
	var __notes: Array[Note]
	var __id: String

	func _init(_course: int, _level: int) -> void:
		self.course = _course
		self.level = _level

	func get_notes() -> Array[Note]:
		if not __notes:
			__notes = __load_notes()
		return __notes

	func id() -> String:
		if not __id:
			__id = __generate_id()
		return __id
	
	func __load_notes() -> Array[Note]:
		print("__load_notes is not overwritten")
		return []
		
	func __generate_id() -> String:
		print("__generate_id is not overwritten")
		return "default_id"
	
	func compare(other: Chart) -> int:
		var diff = other.course - self.course
		if diff == 0:
			diff = other.level - self.level
		return diff

class LoadedChart extends Chart:
	var notes: Array[Note]
	
	func _init(_course: int, _level: int, _notes: Array[Note]) -> void:
		self.course = _course
		self.level = _level
		self.notes = _notes

	func __load_notes() -> Array[Note]:
		return self.notes

	func __generate_id() -> String:
		var fingerprint = "%d:%d:" % [course, level]
		var note_strings = notes.map(func(note): return note.type)
		fingerprint += "".join(note_strings)
		return "L:" + fingerprint.sha256_text()

class Song:
	var title: String
	var artist: String
	var song_file: String
	var duration: float
	var source: String
	var bpm: float
	var charts: Array[Chart]

	func _init(_title: String, _artist: String, _song_file: String, _duration: float, _source: String, _bpm: float, _charts: Array[Chart]) -> void:
		self.title = _title
		self.artist = _artist
		self.song_file = _song_file
		self.duration = _duration
		self.source = _source
		self.bpm = _bpm
		self.charts = _charts
