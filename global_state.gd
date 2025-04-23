extends Node

var _menu_room_2d_scene : PackedScene
var _menu_room_2d_scene_path : String
var _scene_menu_room = preload("res://taiko_vr/menu/menu_room.tscn")

func show_menu_room(scene_tree, scene_2d_path):
	var scene_2d = load(scene_2d_path)
	if scene_2d:
		if scene_2d.can_instantiate():
			_menu_room_2d_scene = scene_2d
			_menu_room_2d_scene_path = scene_2d_path
			scene_tree.change_scene_to_packed(_scene_menu_room)
		else:
			print("[-] show_menu_root: ", scene_2d_path, " can be loaded, but not instantiated")
	else:
		print("[-] show_menu_root: ", scene_2d_path, " can not be loaded")
