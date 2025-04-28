extends XRNode3D

# This is the material we want to change to.
var collision_material: Material = preload("res://taiko_vr/assets/controllers_touch_material.tres")

func _on_area_body_entered(body):
	if body.is_in_group("Controller"):
		# Change the material to a new one (or just change its color)
		$MeshInstance3D.material_override = collision_material
		print("Clap")

func _on_area_body_exited(body):
	if body.is_in_group("Controller"):
		$MeshInstance3D.material_override = null
