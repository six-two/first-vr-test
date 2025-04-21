extends Node

const NOTE_MISS_SECONDS = 0.4
const NOTE_OK_SECONDS = 0.15
const NOTE_PERFECT_SECONDS = 0.06
const NOTE_DISPLAY_SECONDS = 2

enum NoteState {
	HIT,
	PARTIALLY_HIT, # for big notes that were only hit once
	NOT_HIT
}
