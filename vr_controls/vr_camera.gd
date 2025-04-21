extends XRCamera3D

func _ready() -> void:
	var viewport = get_viewport()
	if viewport and viewport.use_xr:
		# VR mode: do nothing for now
		pass
	else:
		# Flatscreen mode: simulate viewport of normal person in VR
		position.y = 1.8 # The average persion is around 1.8m tall
		rotation_degrees.x = -10 # look slightly down
