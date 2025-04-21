extends MeshInstance3D

var remaining_time : float
var state : TaikoConst.NoteState
var type : String

static var small_center_note_mesh: Mesh = preload("res://taiko_vr/assets/small_center_note_mesh.tres")
static var small_edge_note_mesh: Mesh = preload("res://taiko_vr/assets/small_edge_note_mesh.tres")
static var big_center_note_mesh: Mesh = preload("res://taiko_vr/assets/big_center_note_mesh.tres")

func _ready() -> void:
	visible = false

func init(new_type: String, time: float) -> void:
	self.remaining_time = time
	self.type = new_type
	self.state = TaikoConst.NoteState.NOT_HIT
	
	if type == "c":
		mesh = small_center_note_mesh
	elif type == "e":
		mesh = small_edge_note_mesh
	elif type == "C":
		mesh = big_center_note_mesh

func _process(delta: float) -> void:
	remaining_time -= delta

	if remaining_time < -TaikoConst.NOTE_MISS_SECONDS:
		self.visible = false
	elif remaining_time < TaikoConst.NOTE_DISPLAY_SECONDS:
		if state == TaikoConst.NoteState.HIT:
			visible = false
		else:
			self.visible = true
			self.position.x = remaining_time * 2

func to_str() -> String:
	return "(type=" + type + ", time=" + str(remaining_time) + ")"
