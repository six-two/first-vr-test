extends Node

class SongData:
	var song_name: String
	var artist: String
	var source: String
	var notes_str: String
	var beat_seconds: float
	var audio_stream_path: String
	var id: String # this is the ID that we use to reference the song, for example in save files
	# As such it should be deterministic and based on the songs unchanging characteristics (like name and artist)

static func new_song(song_name, artist, source, audio_stream_path, notes_str, beat_seconds):
	var song = SongData.new()
	song.song_name = song_name
	song.artist = artist
	song.source = source
	song.audio_stream_path = audio_stream_path
	song.notes_str = notes_str
	song.beat_seconds = beat_seconds
	# Generate the ID after all other values have been assigned
	song.id = generate_song_id(song)
	return song

static func generate_song_id(song: SongData) -> String:
	var fingerprint = "%s\n%s\n%s" % [song.song_name, song.artist, song.source]
	return fingerprint.sha256_text()


static var current_song
static var current_score

static var SONG_LIST = [
	new_song(
		"EDM Dance Club Music (2s)",
		"LudoSoundX",
		"https://pixabay.com/music/future-bass-edm-dance-club-music-259530/",
		"res://music/edm-dance-club-music-259530.mp3",
		"  cc ",
		0.2 
	),
	new_song(
		"EDM Dance Club Music",
		"LudoSoundX",
		"https://pixabay.com/music/future-bass-edm-dance-club-music-259530/",
		"res://music/edm-dance-club-music-259530.mp3",
		"  cc cc ccc e cccc e cccc e cccc e c ccce cccc e c ccce c ccce c ccc ecccc cce ccc e ccccc cc ccce cccc ccc ccc ec cc",
		0.5
	),
]
