extends Node3D

# Speed of movement
var move_speed := 1

# Reference to the left controller
@onready var controller = $RightController

#func _physics_process(delta):
func _process(delta: float) -> void:
	# Read joystick axes from left controller (values from -1 to 1)
	var input_vec = controller.get_vector2("thumbstick")
	print("Stick position", input_vec)

	if input_vec.length() > 0.1:
		# Optional: rotate input by camera's orientation so movement matches where you're looking
		var camera = $XRCamera3D
		var forward = -camera.global_transform.basis.z
		var right = camera.global_transform.basis.x

		var move_dir = (right * input_vec.x + forward * input_vec.y).normalized()
		# Do NOT modify Y axis, since it is Up/Down direction
		position.x += move_dir.x * move_speed * delta
		position.z += move_dir.z * move_speed * delta
