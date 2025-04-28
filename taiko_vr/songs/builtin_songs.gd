extends Node

const SongClass = preload("res://taiko_vr/songs/song.gd")
const Song = SongClass.Song
const SimpleChart = preload("res://taiko_vr/songs/charts.gd").SimpleChart

static func get_builtin_songs() -> Array[Song]:
	var chart_short_edm_ludosoundx = SimpleChart.new(1, 2, "      c c  ", 0.2)
	var chart_edm_ludosoundx = SimpleChart.new(1, 2,
		"  cc cc ccc e cccc e cccc e cccc e c ccce cccc e c ccce c ccce c ccc ecccc cce ccc e ccccc cc ccce cccc ccc ccc ec cc",
		0.5)

	var songs: Array[Song] = [
		Song.new(
			"EDM Dance Club Music (2s)",
			"LudoSoundX",
			"res://music/edm-dance-club-music-259530.mp3",
			2,
			"https://pixabay.com/music/future-bass-edm-dance-club-music-259530/",
			240,
			[chart_short_edm_ludosoundx]
		),
		Song.new(
			"EDM Dance Club Music",
			"LudoSoundX",
			"res://music/edm-dance-club-music-259530.mp3",
			30,
			"https://pixabay.com/music/future-bass-edm-dance-club-music-259530/",
			120,
			[chart_edm_ludosoundx]
		),
	]
	return songs
