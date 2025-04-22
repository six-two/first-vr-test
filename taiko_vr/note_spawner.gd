extends Node3D

var beat_seconds # how long a beat takes
var remaining_time
var notes
var type

signal song_finished
# @TODO design: should I make different signals for big notes only being hit once, or should I just always count them as OK?
signal note_miss(input, note)
signal note_ok
signal note_perfect

static var NoteScene: PackedScene = preload("res://taiko_vr/small_note.tscn")
var SongData = preload("res://taiko_vr/songs/song_data.gd")

var area_to_type_map : Dictionary = {}
var last_note_index : int = 0

func init(drumb):
	var notes_str = SongData.current_song.notes_str
	#var notes_str = "  cc cc ccc e cccc e cccc e cccc e c ccce cccc e c ccce c ccce c ccc ecccc cce ccc e ccccc cc ccce cccc ccc ccc ec cc"
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
		
	drumb.connect("drumb_center_hit", self._on_drumb_center_hit)
	drumb.connect("drumb_edge_hit", self._on_drumb_edge_hit)
	drumb.connect("drumb_exited", self._on_drumb_exited)


func get_next_note():
	# Find the next note, that is not past the input window
	while last_note_index < notes.size():
		var note = notes[last_note_index]
		
		# Note is in judgement window
		if note.remaining_time > -TaikoConst.NOTE_MISS_SECONDS:
			# Note is not already (fully) processed
			if note.state != TaikoConst.NoteState.HIT:
				break

		# A note was partially hit, and it did not get hit again -> OK score
		if note.state == TaikoConst.NoteState.PARTIALLY_HIT:
			note_ok.emit()

		last_note_index += 1
		
	if last_note_index < notes.size():
		var note = notes[last_note_index]
		if note.remaining_time < TaikoConst.NOTE_MISS_SECONDS:
			# Only return a note if it is in the judgement window
			return notes[last_note_index]
		else:
			return null
	else:
		return null

func judge_input(type) -> void:
	var note = get_next_note()
	if type == "e":
		for note_i in notes:
			print("- " + note_i.to_str())
	
	if note:
		print("judge: ", type, note.to_str())
		if note.type == "c" or note.type == "e":
			if note.type == type:
				if abs(note.remaining_time) <= TaikoConst.NOTE_PERFECT_SECONDS:
					note_perfect.emit()
				else:
					note_ok.emit()
			else:
				# hit the wrong type
				note_miss.emit(type, note)
			note.state = TaikoConst.NoteState.HIT
		elif note.type == "C" or note.type == "E":
			if note.type.to_lower() == type:
				if get_input_count(type) > 1:
					note.state = TaikoConst.NoteState.HIT
					if abs(note.remaining_time) <= TaikoConst.NOTE_PERFECT_SECONDS:
						note_perfect.emit()
					else:
						note_ok.emit()
				else:
					# note only hit once, wait for second hit
					note.state = TaikoConst.NoteState.PARTIALLY_HIT
			else:
				# this hit the wrong note, but it could maybe be the next note
				# mark this note as processed
				note.state = TaikoConst.NoteState.HIT
				note_ok.emit()
				# call the function again
				judge_input(type)
		else:
			print("Unknown note type: ", type)
	else:
		# Input while no note was in judgement window -> Miss
		print("judge: ", type, " no match")
		note_miss.emit(type, null)

func get_input_count(type):
	var count = 0
	for value in area_to_type_map.values():
		if value == type:
			count += 1
	return count

func _on_drumb_center_hit(body : Area3D):
	area_to_type_map[body] = "c"
	judge_input("c")

func _on_drumb_edge_hit(body):
	area_to_type_map[body] = "e"
	judge_input("e")

func _on_drumb_exited(body):
	area_to_type_map[body] = " "


func _process(delta: float) -> void:
	remaining_time -= delta

	# Only send the song finished event once
	if remaining_time < 0 and remaining_time > -1000:
		song_finished.emit()
		remaining_time = -10000
