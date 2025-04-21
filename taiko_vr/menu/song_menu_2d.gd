extends PanelContainer

var taiko_vr_play = preload("res://taiko_vr/taiko_xr_main.tscn")

func _ready() -> void:
	$SplitContainer/VBoxContainer/PlayButton.pressed.connect(self._on_button_play_pressed)

func _on_button_play_pressed():
	get_tree().change_scene_to_packed(taiko_vr_play)
