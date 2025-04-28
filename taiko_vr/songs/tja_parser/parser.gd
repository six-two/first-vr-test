extends Node

# SEE https://gist.github.com/KatieFrogs/e000f406bbc70a12f3c34a07303eec8b#song-notation
# USE https://whmhammer.github.io/tja-tools/ (and select difficulty easy) to view how the demo file should look like

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
	var base_bpm: float = 120 # "If omitted, BPM defaults to 120." --https://gist.github.com/KatieFrogs/e000f406bbc70a12f3c34a07303eec8b#bpm
	var measure_seconds: float = 0
	var time: float = 0
	var measure: float = 4.0 / 4.0 # The measure is usually 4/4
	var bpm
	var skip_this_path

	var file = FileAccess.open(file_path, FileAccess.READ)

	while not file.eof_reached():
		var line: String = file.get_line()
		
		# Remove comments
		var comment_start = line.find("//")
		if comment_start > -1:
			line = line.substr(0, comment_start).strip_edges(false, true)

		if line:
			if line.begins_with("#START") and chart.course != -1:
				in_song_notation = true
				measure = 4.0 / 4.0 # The measure is usually 4/4
				bpm = base_bpm # bpm can change during the song, so we copy it
				# "Formula to get the amount of milliseconds per measure: 60000 * MEASURE * 4 / BPM." --https://gist.github.com/KatieFrogs/e000f406bbc70a12f3c34a07303eec8b#measure
				measure_seconds = 60 * measure * 4 / bpm
				time = 0
				skip_this_path = false
			elif line.begins_with("#END"):
				if in_song_notation:
					# add the current chart to the song
					song.charts.append(chart)

				# Reset the chart parsing logic
				in_song_notation = false
				chart = Song.LoadedChart.new(0, 0, [])
			elif line.begins_with("#MEASURE"):
				# SEE https://gist.github.com/KatieFrogs/e000f406bbc70a12f3c34a07303eec8b#measure
				# example: "#MEASURE 2/4"
				var measure_str = line.trim_prefix("#MEASURE").strip_edges()
				var parts = measure_str.split("/")
				measure = float(parts[0]) / float(parts[1])
				measure_seconds = 60 * measure * 4 / bpm
			elif line.begins_with("#BPMCHANGE"):
				# SEE https://gist.github.com/KatieFrogs/e000f406bbc70a12f3c34a07303eec8b#bpmchange
				var bpm_str = line.trim_prefix("#BPMCHANGE").strip_edges()
				bpm = int(bpm_str)
				measure_seconds = 60 * measure * 4 / bpm
			elif in_song_notation:
				if line.ends_with(","): # @TODO: some songs have a single measure over multiple lines, possibly with a bpm change in the middle
					if not skip_this_path:
						var note_types = parse_segment(line)
						var note_time = measure_seconds / note_types.length()
						for type in note_types:
							if type != " ":
								var note = Song.Note.new(type, time)
								chart.notes.append(note)

							time += note_time
				elif line.begins_with("#BRANCHSTART"):
					# https://gist.github.com/KatieFrogs/e000f406bbc70a12f3c34a07303eec8b#branchstart
					# Branches are hard an will maybe implemented later.
					# For now we just always take the normal path "#N" and ignore the advanced and master paths
					pass
				elif line in ["#BRANCHEND", "#N"]:
					# Normal brach or branching ends -> treat all notes normally
					skip_this_path = false
				elif line in ["#E", "#M"]:
					# we always take the normal path, so skip the master and expert ones
					skip_this_path = true
				elif line in ["#GOGOSTART", "#GOGOEND", "#BARLINEOFF", "#BARLINEON", "#SECTION"] or line.begins_with("#SCROLL"):
					# Ignore some instructions we do not care about
					# https://gist.github.com/KatieFrogs/e000f406bbc70a12f3c34a07303eec8b#scroll
					# https://gist.github.com/KatieFrogs/e000f406bbc70a12f3c34a07303eec8b#gogostart-gogoend
					# https://gist.github.com/KatieFrogs/e000f406bbc70a12f3c34a07303eec8b#barlineoff-barlineon
#					# https://gist.github.com/KatieFrogs/e000f406bbc70a12f3c34a07303eec8b#section
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
					var course = line.substr("COURSE:".length())
					chart.course = parse_course(course)
				elif line.begins_with("LEVEL:"):
					chart.level = int(line.substr("LEVEL:".length()))
				elif line.begins_with("BPM:"):
					base_bpm = float(line.substr("BPM:".length()))
					song.bpm = base_bpm

	file.close()
	return song
	
static func parse_course(course: String) -> int:
	course = course.to_lower().strip_edges()
	if course in ["0", "easy"]:
		return 0
	elif course in ["1", "normal"]:
		return 1
	elif course in ["2", "hard"]:
		return 2
	elif course in ["3", "oni"]:
		return 3
	elif course in ["4", "edit"]:
		return 4
	elif course in ["5", "tower", "6", "dan"]:
		print("Ignoring known course: ", course)
		return -1
	else:
		print("[-] Unknown course: ", course)
		return -1

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
