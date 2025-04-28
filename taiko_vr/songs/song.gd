extends Node


class Note:
	var type: String
	var time: float

	func _init(type: String, time: float) -> void:
		self.type = type
		self.time = time

class Chart:
	var course: int
	var level: int
	var __notes: Array[Note]
	var __id: String

	func _init(course: int, level: int) -> void:
		self.course = course
		self.level = level

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

class LoadedChart extends Chart:
	var notes: Array[Note]
	
	func _init(course: int, level: int, notes: Array[Note]) -> void:
		self.course = course
		self.level = level
		self.notes = notes

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

	func _init(title: String, artist: String, song_file: String, duration: float, source: String, bpm: float, charts: Array[Chart]) -> void:
		self.title = title
		self.artist = artist
		self.song_file = song_file
		self.duration = duration
		self.source = source
		self.bpm = bpm
		self.charts = charts
