extends Node

const Song = preload("res://taiko_vr/songs/song.gd")
const Note = Song.Note

class TjaChart extends Song.Chart:
	var tja_file: String

	func _init(_course: int, _level: int, _tja_file: String) -> void:
		super(_course, _level)
		self.tja_file = _tja_file

	func __load_notes() -> Array[Note]:
		const TjaParser = preload("res://taiko_vr/songs/tja_parser/parser.gd")
		var song = TjaParser.parse_tja_song(tja_file)
		for chart in song.charts:
			if chart.course == course and chart.level == level:
				return chart.notes
		
		print("TjaChart::__load_notes: Not a chart with matching level and course")
		return []

	func __generate_id() -> String:
		var fingerprint = "%d:%d:%s" % [course, level, tja_file]
		return "T:" + fingerprint.sha256_text()

class SimpleChart extends Song.Chart:
	var notes_str: String
	var beat_seconds: float

	func _init(_course: int, _level: int, _notes_str: String, _beat_seconds: float) -> void:
		super(_course, _level)
		self.notes_str = _notes_str
		self.beat_seconds = _beat_seconds

	func __load_notes() -> Array[Note]:
		var notes: Array[Note] = []
		var time = 0
		for type_char in notes_str:
			if type_char in ["c", "e", "C", "E"]:
				var note = Note.new(type_char, time)
				notes.append(note)
			elif type_char == " ":
				# do nothing for space
				pass
			else:
				print("Unexpected note: ", type_char)

			time += beat_seconds
		return notes

	func __generate_id() -> String:
		var fingerprint = "%d:%d:%s" % [course, level, notes_str]
		return "S:" + fingerprint.sha256_text()
