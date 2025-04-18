extends Node3D
# This script "moves" the controllers in non-XR mode to have easy debugging on the desktop

# Movement parameters
@export var left_limit: float = -0.02
@export var right_limit: float = 0.02
@export var speed: float = 0.02

var direction: int = 1  # 1 = right, -1 = left

func _ready() -> void:
	# Move the camera backwards, so that we can see the controllers
	get_node("/root/XRMain/XROrigin3D/XRNode3D/XRCamera3D").position.z = 0.1


func _process(delta: float) -> void:
	if not get_viewport().use_xr:
		# Move object
		var x = get_parent().position.x
		x += direction * speed * delta

		# Switch direction if we hit a limit
		if x > right_limit:
			x = right_limit
			direction = -1
		elif x < left_limit:
			x = left_limit
			direction = 1
		
		get_parent().position.x = x
