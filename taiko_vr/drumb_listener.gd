extends Node

var center_hit_material : Material
var edge_hit_material : Material
var normal_material : Material

func _ready():
	print("DrumbListener ready")
	$Drumb/Head.connect("drumb_center_hit", self._on_drumb_center_hit)
	$Drumb/Head.connect("drumb_edge_hit", self._on_drumb_edge_hit)
	$Drumb/Head.connect("drumb_exited", self._on_drumb_exited)
	
	center_hit_material = StandardMaterial3D.new()
	center_hit_material.albedo_color = Color(1, 0, 0)
	center_hit_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

	edge_hit_material = StandardMaterial3D.new()
	edge_hit_material.albedo_color = Color(0, 0, 1)
	edge_hit_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

func _on_drumb_center_hit(body : Area3D):
	print("Center")
	# This should mork for controllers
	var mesh = body.get_node("../MeshInstance3D")
	if mesh:
		mesh.material_override = center_hit_material

func _on_drumb_edge_hit(body):
	print("Edge")
	var mesh = body.get_node("../MeshInstance3D")
	if mesh:
		mesh.material_override = edge_hit_material

func _on_drumb_exited(body):
	print("Exited")
	var mesh = body.get_node("../MeshInstance3D")
	if mesh:
		mesh.material_override = null
