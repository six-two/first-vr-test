extends Node3D

var remaining_time
var notes

signal song_started
signal song_finished
signal note_miss(input : String, note)
signal note_ok
signal note_perfect

static var NoteScene: PackedScene = preload("res://taiko_vr/small_note.tscn")
const SongData = preload("res://taiko_vr/songs/song_data.gd")

var area_to_type_map : Dictionary = {}
var last_note_index : int = 0
var paused = true

func _ready() -> void:
	paused = true
	for drumb in get_tree().get_nodes_in_group("DrumbHead"):
		drumb.connect("drumb_center_hit", self._on_drumb_center_hit)
		drumb.connect("drumb_edge_hit", self._on_drumb_edge_hit)
		drumb.connect("drumb_exited", self._on_drumb_exited)

	# preload the notes / parse the chart
	SongData.current_chart.get_notes()

func start():
	var note_data_list = SongData.current_chart.get_notes()
	remaining_time = SongData.current_song.duration

	notes = []
	for note_data in note_data_list:
		var note = NoteScene.instantiate()
		note.init(note_data.type, note_data.time)
		notes.append(note)
		self.add_child(note)

	paused = false

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
		elif note.state == TaikoConst.NoteState.NOT_HIT:
			note_miss.emit(null, note)

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
	if paused:
		start()
		song_started.emit()
		return
	
	var note = get_next_note()
	if note:
		#print("judge: ", type, note.to_str())
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
	if not paused:
		remaining_time -= delta
		
		# Check notes, so that we trigger some OKs and MISSes on time
		get_next_note()

		# Only send the song finished event once
		if remaining_time < 0 and remaining_time > -1000:
			song_finished.emit()
			remaining_time = -10000
