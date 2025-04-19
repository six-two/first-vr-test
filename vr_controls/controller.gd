extends XRNode3D

# This is the material we want to change to.
var normal_material : Material
var collision_material : Material

func _ready():
	# Store the default material of the object to revert back later if needed
	normal_material = $MeshInstance3D.material_override
	collision_material = StandardMaterial3D.new()
	collision_material.albedo_color = Color(1, 0, 0)
	collision_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

	
	$MeshInstance3D.scale = self.scale
	$Area3D.scale = self.scale

	# Connect signals to methods
	$Area3D.connect("area_entered", self._on_Area_body_entered)
	$Area3D.connect("area_exited", self._on_Area_body_exited)
	
	# Ensure that the collision shapes are in the "Collidable" group
	$Area3D.add_to_group("Collidable")
	print_tree_pretty()
	

func _on_Area_body_entered(body):
	print("On body entered")
	# Change the object's color when it collides
	if body.is_in_group("Collidable"):
		# Change the material to a new one (or just change its color)
		$MeshInstance3D.material_override = collision_material
		print("Collision detected!")

func _on_Area_body_exited(body):
	# Revert the material when the object exits the collision
	if body.is_in_group("Collidable"):
		$MeshInstance3D.material_override = normal_material
		print("Collision ended!")
