extends Node

const Song = preload("res://taiko_vr/songs/song.gd")
const Note = Song.Note

class TjaChart extends Song.Chart:
	var tja_file: String

	func _init(course: int, level: int, tja_file: String) -> void:
		super(course, level)
		self.tja_file = tja_file

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

	func _init(course: int, level: int, notes_str: String, beat_seconds: float) -> void:
		super(course, level)
		self.notes_str = notes_str
		self.beat_seconds = beat_seconds

	func __load_notes() -> Array[Note]:
		var notes: Array[Note] = []
		var time = 0
		for char in notes_str:
			if char in ["c", "e", "C", "E"]:
				var note = Note.new(char, time)
				notes.append(note)
			elif char == " ":
				# do nothing for space
				pass
			else:
				print("Unexpected note: ", char)

			time += beat_seconds
		return notes

	func __generate_id() -> String:
		var fingerprint = "%d:%d:%s" % [course, level, notes_str]
		return "S:" + fingerprint.sha256_text()
