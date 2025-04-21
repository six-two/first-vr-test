extends Node

class SongData:
	var song_name: String
	var artist: String
	var source: String
	var notes_str: String
	var beat_seconds: float

static func new_song(song_name, artist, source, notes_str, beat_seconds):
	var song = SongData.new()
	song.song_name = song_name
	song.artist = artist
	song.source = source
	song.notes_str = notes_str
	song.beat_seconds = beat_seconds
	return song

static var SONG_LIST = [
	new_song(
		"EDM Dance Club Music",
		"LudoSoundX",
		"https://pixabay.com/music/future-bass-edm-dance-club-music-259530/",
		"  cc cc ccc e cccc e cccc e cccc e c ccce cccc e c ccce c ccce c ccc ecccc cce ccc e ccccc cc ccce cccc ccc ccc ec cc",
		0.2 
	)
]
