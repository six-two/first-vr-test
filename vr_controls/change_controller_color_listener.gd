extends "res://vr_controls/ball_controller.gd"

static var center_material = preload("res://taiko_vr/assets/center_material.tres")
static var edge_material = preload("res://taiko_vr/assets/edge_material.tres")

func init(drumb):
	drumb.connect("drumb_center_hit", self._on_drumb_center_hit)
	drumb.connect("drumb_edge_hit", self._on_drumb_edge_hit)
	drumb.connect("drumb_exited", self._on_drumb_exited)

func update_mesh_color(body : Area3D, new_material : Material) -> void:
	var mesh = body.get_node("../MeshInstance3D")
	if mesh:
		mesh.material_override = new_material

func _on_drumb_center_hit(body : Area3D):
	#print("Center")
	update_mesh_color(body, center_material)

func _on_drumb_edge_hit(body):
	#print("Edge")
	update_mesh_color(body, edge_material)

func _on_drumb_exited(body):
	#print("Exited")
	update_mesh_color(body, null)
