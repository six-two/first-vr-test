extends Node

class BasicScore:
	var perfect: int = 0
	var ok: int = 0
	var miss: int = 0

class FullScore:
	var perfect: int = 0
	var ok: int = 0
	var miss: int = 0
	var percent: float
	var rank: String
	var description: String # like "All Combo" or "81.3%"
	var all_perfect: bool
	var full_combo: bool
	
static func percent_to_rank(percent: float) -> String:
	# Inspired partially by https://myjian.github.io/mai-tools/rating-visualizer/, to be tweaked later
	if percent > 99:
		return "SS"
	elif percent > 97:
		return "S"
	elif percent > 94:
		return "AAA"
	elif percent > 90:
		return "AA"
	elif percent > 80:
		return "A"
	elif percent > 70:
		return "B"
	elif percent > 60:
		return "C"
	else:
		return "D"

static func basic_to_full_score(basic_score: BasicScore) -> FullScore:
	var score = basic_score.perfect + 0.5 * basic_score.ok
	var count = basic_score.perfect + basic_score.ok + basic_score.miss
	var percent = 100 * (score / count)

	var rank
	var combo
	var all_perfect
	var full_combo
	if basic_score.ok == 0 and basic_score.miss == 0:
		combo = "All Perfect"
		all_perfect = true
		full_combo = true
	elif basic_score.miss == 0:
		combo = "Full Combo"
		all_perfect = false
		full_combo = true
	else:
		combo = "%.1f%%" % percent
		all_perfect = false
		full_combo = false
	
	rank = percent_to_rank(percent)
	
	var full_score = FullScore.new()
	full_score.perfect = basic_score.perfect
	full_score.ok = basic_score.ok
	full_score.miss = basic_score.miss
	full_score.percent = percent
	full_score.description = combo
	full_score.rank = rank
	full_score.all_perfect = all_perfect
	full_score.full_combo = full_combo
	return full_score
