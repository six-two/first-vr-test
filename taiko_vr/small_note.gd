extends MeshInstance3D

var remaining_time : float
var score : float
var type : String

static var small_center_note_mesh: Mesh = preload("res://taiko_vr/assets/small_center_note_mesh.tres")
static var small_edge_note_mesh: Mesh = preload("res://taiko_vr/assets/small_edge_note_mesh.tres")
static var big_center_note_mesh: Mesh = preload("res://taiko_vr/assets/big_center_note_mesh.tres")

func _ready() -> void:
	visible = false

func init(type: String, time: float) -> void:
	self.remaining_time = time
	self.type = type
	
	if type == "c":
		mesh = small_center_note_mesh
	elif type == "e":
		mesh = small_edge_note_mesh
	elif type == "C":
		mesh = big_center_note_mesh

func _process(delta: float) -> void:
	remaining_time -= delta

	if remaining_time < 0.2:
		self.visible = false
		score = -1 # Miss
	elif remaining_time < 2:
		self.visible = true
		self.position.x = remaining_time * 2
