extends Node3D

var beat_seconds # how long a beat takes
var remaining_time
var notes

signal song_finished

static var NoteScene: PackedScene = preload("res://taiko_vr/small_note.tscn")

func _ready():
	create_notes()
	
func create_notes():
	#var notes_str = "    " + "cce cce C   ".repeat(100)
	var notes_str = "  cc cc ccc e cccc e cccc e cccc e c ccce cccc e c ccce c ccce c ccc ecccc cce ccc e ccccc cc ccce cccc ccc ccc ec cc"
	beat_seconds = 0.2
	remaining_time = notes_str.length() * beat_seconds
	
	notes = []
	var beat_time = 0
	for char in notes_str:
		if char in ["c", "e", "C", "E"]:
			var note = NoteScene.instantiate()
			note.init(char, beat_time)
			notes.append(note)
			self.add_child(note)
		# do nothing for space, etc
		beat_time += beat_seconds

func _process(delta: float) -> void:
	remaining_time -= delta

	if remaining_time < 0:
		print("Song over")
		song_finished.emit() #@TODO: make a song select screen
