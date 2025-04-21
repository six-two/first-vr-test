extends Node3D

func _ready():
	var mat = StandardMaterial3D.new()
	mat.albedo_texture = $SubViewport.get_texture()
	$MenuScreen.material_override = mat
	$MenuScreen/Area3D.add_to_group("menu_screen")

#func _unhandled_input(event):
	#if event is InputEventMouseButton and event.pressed:
		#var from = $XROrigin3D/VrCamera.project_ray_origin(event.position)
		#var to = from + $XROrigin3D/VrCamera.project_ray_normal(event.position) * 1000
		#var space_state = get_world_3d().direct_space_state
		#var ray = PhysicsRayQueryParameters3D(from, to)
		#var result = space_state.intersect_ray(ray)
#
		#if result and result.collider == $MenuScreen:
			#_handle_click_on_ui(result.position)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Mouse clicked")
		# Get the ray start and direction from the camera
		var ray_origin = $XROrigin3D/VrCamera.project_ray_origin(event.position)
		var ray_direction = $XROrigin3D/VrCamera.project_ray_normal(event.position)

		# Set up the PhysicsRayQueryParameters3D
		var ray_parameters = PhysicsRayQueryParameters3D.new()
		ray_parameters.from = ray_origin
		ray_parameters.to = ray_origin + ray_direction * 1000  # Adjust ray length here
		ray_parameters.collide_with_areas = true  # Or false, depending on what you want to hit
		ray_parameters.collide_with_bodies = true
		ray_parameters.exclude = []  # Add any nodes you want to exclude from the raycast

		# Perform the raycast
		var result = get_world_3d().direct_space_state.intersect_ray(ray_parameters)

		# If the ray hits something, print out what it hit
		if result:
			var collider = result.collider
			print("Ray hit: ", collider)
			if collider and collider.is_in_group("menu_screen"):  # Assuming you grouped your UI elements
				print("UI element clicked: ", collider.name)
				print("pos: ", result.position)
				handle_click_on_ui(result.position)


func handle_click_on_ui(world_pos: Vector3):
	var local_pos = $MenuScreen.to_local(world_pos)

	var mesh_size = Vector2(10.0, 5.0)  # size of the QuadMesh
	var uv_x = (local_pos.x / mesh_size.x) + 0.5
	var uv_y = -(local_pos.y / mesh_size.y) + 0.5  # Y is flipped

	var viewport_size = Vector2($SubViewport.size)
	var click_pos = Vector2(uv_x, uv_y) * viewport_size

	# Simulate the mouse click
	var viewport = $SubViewport
	var click_event = InputEventMouseButton.new()
	click_event.button_index = MOUSE_BUTTON_LEFT
	click_event.pressed = true
	click_event.position = click_pos
	viewport.push_input(click_event)

	# Simulate release
	var release_event = InputEventMouseButton.new()
	release_event.button_index = MOUSE_BUTTON_LEFT
	release_event.pressed = false
	release_event.position = click_pos
	viewport.push_input(release_event)
