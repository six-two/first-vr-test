extends Node3D

func _ready() -> void:
	if GlobalState._menu_room_2d_scene:
		if GlobalState._menu_room_2d_scene.can_instantiate():
			$Viewport2Din3D.scene = GlobalState._menu_room_2d_scene
		else:
			print("[-] Menu Room Error: GlobalState._menu_room_2d_scene is set, but can not be instanciated")
	else:
		print("[-] Menu Room Error: GlobalState._menu_room_2d_scene is not set")
