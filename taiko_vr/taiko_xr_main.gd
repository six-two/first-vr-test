extends Node

var center_hit_material : Material
var edge_hit_material : Material
var normal_material : Material
var mapping_mode : bool = false

func _ready():
	print("TaikoXR ready")
	var drumb = $Drumb/Head
	drumb.connect("drumb_center_hit", self._on_drumb_center_hit)
	drumb.connect("drumb_edge_hit", self._on_drumb_edge_hit)
	drumb.connect("drumb_exited", self._on_drumb_exited)
	
	center_hit_material = StandardMaterial3D.new()
	center_hit_material.albedo_color = Color(1, 0, 0)
	center_hit_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

	edge_hit_material = StandardMaterial3D.new()
	edge_hit_material.albedo_color = Color(0, 0, 1)
	edge_hit_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	$AudioStreamPlayer.play()
	
	if mapping_mode:
		$JudgementLine.set_script(load("res://taiko_vr/mapping_mode.gd"))
		$JudgementLine.init(20, 0.20, drumb)
		$JudgementLine.set_process(true)
	else:
		$JudgementLine.set_script(load("res://taiko_vr/note_spawner.gd"))
		$JudgementLine.init(drumb)
		$JudgementLine.set_process(true)
		
		$JudgementLine.connect("note_miss", _on_note_miss)
		$JudgementLine.connect("note_ok", _on_note_ok)
		$JudgementLine.connect("note_perfect", _on_note_perfect)
	
func _on_note_miss(input_type, node):
	var node_str = node.to_str() if node else "null"
	print("Note: Miss (", input_type, " / ", node_str, ")")
		
func _on_note_ok():
	print("Note: OK")
	
func _on_note_perfect():
	print("Note: Perfect")

func update_mesh_color(body : Area3D, new_material : Material) -> void:
	var mesh = body.get_node("../MeshInstance3D")
	if mesh:
		mesh.material_override = new_material

func _on_drumb_center_hit(body : Area3D):
	#print("Center")
	update_mesh_color(body, center_hit_material)

func _on_drumb_edge_hit(body):
	#print("Edge")
	update_mesh_color(body, edge_hit_material)

func _on_drumb_exited(body):
	#print("Exited")
	update_mesh_color(body, null)
