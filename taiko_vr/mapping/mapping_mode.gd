extends Node

var song_time : float
var beat_seconds : float
var note_string : String
var time : float
var type : String


func init(song_time, beat_seconds, drumb) -> void:
	self.song_time = song_time
	self.beat_seconds = beat_seconds
	self.time = -0.5 * beat_seconds # shift the window, so that input map to the nearest beat and not always the next one
	self.note_string = ""
	self.type = " "

	drumb.connect("drumb_center_hit", self._on_drumb_center_hit)
	drumb.connect("drumb_edge_hit", self._on_drumb_edge_hit)
	drumb.connect("drumb_exited", self._on_drumb_exited)

func _on_drumb_center_hit(body : Area3D):
	if type == " ":
		type = "c"
	elif type == "c":
		type = "C"
	else:
		print("Cannot add input 'c' to existing type '", type, "'")

func _on_drumb_edge_hit(body):
	if type == " ":
		type = "e"
	elif type == "e":
		type = "E"
	else:
		print("[-] Cannot add input 'e' to existing type '", type, "'")

func _on_drumb_exited(body):
	pass # Nothing to do here


func _process(delta: float) -> void:
	if time > song_time:
		print("[*] Song Mapping done:", note_string)
		
	if int((time + delta) / beat_seconds) > int(time / beat_seconds):
		# we are in a new beat. First store the old one
		print("[*] Debug mapping: ", type)
		note_string += type
		type = " "
		
		if int((time + delta) / beat_seconds) % 10 == 0:
			print("[*] Debug current map: ", note_string)
	
	time += delta
