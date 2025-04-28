extends Node

# SEE https://gist.github.com/KatieFrogs/e000f406bbc70a12f3c34a07303eec8b#song-notation
# USE https://whmhammer.github.io/tja-tools/ (and select dificulty easy) to view how the demo file should look like

const Song = preload("res://taiko_vr/songs/song.gd")

const NOTE_MAP = {
	"0": " ",
	"1": "c",
	"2": "e",
	"3": "C",
	"4": "E",
}

# Function to parse the notes from a TJA file
static func parse_tja_song(file_path: String) -> Song.Song:
	var song = Song.Song.new("Unknown Title", "Unknown Artist", "", 999, file_path, 999, [])
	var chart = Song.LoadedChart.new(0, 0, [])
	var in_song_notation = false
	var base_bpm = 0
	var segment_seconds = 0
	var time = 0

	var file = FileAccess.open(file_path, FileAccess.READ)

	while not file.eof_reached():
		var line: String = file.get_line()

		if line.begins_with("#START"):
			in_song_notation = true
			segment_seconds = 60 * 8 / base_bpm
			time = 0
		elif line.begins_with("#END"):
			in_song_notation = false
			# add the current chart to the song
			song.charts.append(chart)
			chart = Song.LoadedChart.new(0, 0, [])
		elif in_song_notation:
			if line.ends_with(","):
				var note_types = parse_segment(line)
				for type in note_types:
					time += segment_seconds / note_types.length()
					var note = Song.Note.new(type, time)
					chart.notes.append(note)
			elif line in ["#GOGOSTART", "#GOGOEND"]:
				# Ignore some instructions we do not care about
				pass
			else:
				print("Ignored line: ", line)
		else:
			# parse metadata
			if line.begins_with("TITLE:"):
				song.title = line.substr("TITLE:".length())
			elif line.begins_with("WAVE:"):
				song.song_file = line.substr("WAVE:".length())
			elif line.begins_with("COURSE:"):
				chart.course = int(line.substr("COURSE:".length()))
			elif line.begins_with("LEVEL:"):
				chart.level = int(line.substr("LEVEL:".length()))
			elif line.begins_with("BPM:"):
				base_bpm = float(line.substr("BPM:".length()))
				song.bpm = base_bpm

	file.close()
	return song

static func parse_segment(line: String) -> String:
	# Parse the notes in the current measure
	var current_measure = ""
	for note_char in line.split(",")[0].split():
		if note_char in NOTE_MAP:
			current_measure += NOTE_MAP[note_char]
		else:
			#print("Ignored note type: ", note_char)
			current_measure += " "

	return current_measure
