extends Node

const NOTE_MISS_SECONDS = 0.4
const NOTE_OK_SECONDS = 0.15
const NOTE_PERFECT_SECONDS = 0.06
const NOTE_DISPLAY_SECONDS = 2
const NOTE_FEEDBACK_DISPLAY_SECONDS = 0.15
# Play seconds 5 - 8, since the beginning of songs may be quiet(er)
const SONG_PREVIEW_OFFSET = 5
const SONG_PREVIEW_SECONDS = 3
const HIGHSCORE_FILE = "user://taiko-highscores.json"

enum NoteState {
	HIT,
	PARTIALLY_HIT, # for big notes that were only hit once
	NOT_HIT
}
