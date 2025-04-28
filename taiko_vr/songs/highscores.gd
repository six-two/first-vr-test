extends Node

# This is the data that is stored for each song
class HighScore:
	var percent: float
	var all_perfect: bool
	var full_combo: bool

static var chart_to_high_score = {}

static func get_highscore(song) -> HighScore:
	return chart_to_high_score.get(song.charts[0].id()) # @TODO: get only highest score?

static func load() -> bool:
	if FileAccess.file_exists(TaikoConst.HIGHSCORE_FILE):
		var file = FileAccess.open(TaikoConst.HIGHSCORE_FILE, FileAccess.READ)
		var json_string = file.get_as_text()
		print("Loading highscores: ", json_string)
		
		var json = JSON.new()
		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return false
		
		var map = {}
		# Get the data from the JSON object.
		for song_id in json.data.keys():
			print(song_id)
			song_id = str(song_id) # It should be a string anyways, but lets make sure
			var values = json.data[song_id]
			var high_score = HighScore.new()
			high_score.percent = values["percent"]
			high_score.all_perfect = values["all_perfect"]
			high_score.full_combo = values["full_combo"]
			
			map[song_id] = high_score
		
		# If no errors during deserialisation, overwrite the existing data
		chart_to_high_score = map
		return true
	else:
		print("No saved highscores found")
		return false

static func save() -> void:
	var data_as_json = {}
	for song_id in chart_to_high_score.keys():
		var high_score = chart_to_high_score[song_id]
		data_as_json[song_id] = {
			"percent": high_score.percent,
			"all_perfect": high_score.all_perfect,
			"full_combo": high_score.full_combo,
		}
	
	var json_string = JSON.stringify(data_as_json)
	print("Saving highscores: ", json_string)
	
	var save_file = FileAccess.open(TaikoConst.HIGHSCORE_FILE, FileAccess.WRITE)
	save_file.store_line(json_string)

static func update(chart, full_score):
	# Check if the new score is better than the highscore. If so then save the new scores
	var id = chart.id()
	if id in chart_to_high_score:
		var high_score = chart_to_high_score[id]
		var updated = false

		# Update values if they are better than the last high score
		if full_score.percent > high_score.percent:
			print("Highscore: Got better percent: ", high_score.percent, " -> ", full_score.percent)
			high_score.percent = full_score.percent
			updated = true
		if full_score.all_perfect and not high_score.all_perfect:
			print("Highscore: Got all perfect")
			high_score.all_perfect = full_score.all_perfect
			updated = true
		if full_score.full_combo and not high_score.full_combo:
			print("Highscore: Got full combo")
			high_score.full_combo = full_score.full_combo
			updated = true

		if updated:
			save()
	else:
		var high_score = HighScore.new()
		high_score.all_perfect = full_score.all_perfect
		high_score.full_combo = full_score.full_combo
		high_score.percent = full_score.percent
		chart_to_high_score[id] = high_score
		print("Highscore: Got first score for song")
		save()
