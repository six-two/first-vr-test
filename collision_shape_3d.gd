extends XRNode3D

# This is the material we want to change to.
var collision_material : Material
var mat := StandardMaterial3D.new()


func _ready():
	# Store the default material of the object to revert back later if needed
	collision_material = $MeshInstance3D.material_override
	
	if $MeshInstance3D:
		$MeshInstance3D.scale = self.scale
	$Area3D.scale = self.scale

	# Connect signals to methods
	$Area3D.connect("area_entered", self._on_Area_body_entered)
	$Area3D.connect("area_exited", self._on_Area_body_exited)
	
	# Ensure that the collision shapes are in the "Collidable" group
	$Area3D.add_to_group("Collidable")
	print_tree_pretty()
	
	mat.albedo_color = Color(1, 1, 1)
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

func _on_Area_body_entered(body):
	print("On body entered")
	# Change the object's color when it collides
	if body.is_in_group("Collidable"):
		# Change the material to a new one (or just change its color)
		$MeshInstance3D.material_override = mat
		print("Collision detected!")

func _on_Area_body_exited(body):
	# Revert the material when the object exits the collision
	if body.is_in_group("Collidable"):
		$MeshInstance3D.material_override = collision_material
		print("Collision ended!")
