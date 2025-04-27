# Based on this great tutorial: https://www.snopekgames.com/tutorial/2023/how-make-vr-game-webxr-godot-4
extends Node

var webxr_interface
var Highscores = preload("res://taiko_vr/songs/highscores.gd")


func _ready() -> void:
	webxr_interface = XRServer.find_interface("WebXR")
	if webxr_interface:
		# WebXR uses a lot of asynchronous callbacks, so we connect to various
		# signals in order to receive them.
		webxr_interface.session_supported.connect(self._webxr_session_supported)
		webxr_interface.session_started.connect(self._webxr_session_started)
		webxr_interface.session_ended.connect(self._webxr_session_ended)
		webxr_interface.session_failed.connect(self._webxr_session_failed)
 
		# This returns immediately - our _webxr_session_supported() method
		# (which we connected to the "session_supported" signal above) will
		# be called sometime later to let us know if it's supported or not.
		webxr_interface.is_session_supported("immersive-vr")
 
func _webxr_session_supported(session_mode: String, supported: bool) -> void:
	if session_mode == 'immersive-vr':
		if not supported:
			$ErrorText.text = "Your browser doesn't support VR"
 

func _on_button_flat_pressed() -> void:
	Highscores.load()
	GlobalState.show_menu_room(get_tree(), "res://taiko_vr/menu/song_menu_2d.tscn")

func _on_button_tutorial_pressed() -> void:
	# Open URL in a web browser
	OS.shell_open("https://github.com/six-two/first-vr-test/blob/main/taiko_vr/tutorial.md")


func _on_button_vr_pressed() -> void:
	Highscores.load()
	if webxr_interface:
		# We want an immersive VR session, as opposed to AR ('immersive-ar') or a
		# simple 3DoF viewer ('viewer').
		webxr_interface.session_mode = 'immersive-vr'
		# 'bounded-floor' is room scale, 'local-floor' is a standing or sitting
		# experience (it puts you 1.6m above the ground if you have 3DoF headset),
		# whereas as 'local' puts you down at the ARVROrigin.
		# This list means it'll first try to request 'bounded-floor', then
		# fallback on 'local-floor' and ultimately 'local', if nothing else is
		# supported.
		webxr_interface.requested_reference_space_types = 'bounded-floor, local-floor, local'
		# In order to use 'local-floor' or 'bounded-floor' we must also
		# mark the features as required or optional.
		webxr_interface.required_features = 'local-floor'
		webxr_interface.optional_features = 'bounded-floor'
	 
		# This will return false if we're unable to even request the session,
		# however, it can still fail asynchronously later in the process, so we
		# only know if it's really succeeded or failed when our
		# _webxr_session_started() or _webxr_session_failed() methods are called.
		if not webxr_interface.initialize():
			$ErrorText.text = "Failed to initialize WebXR"
	else:
		$ErrorText.text = "Failed to get WebXR context"
 
func _webxr_session_started() -> void:
	# This tells Godot to start rendering to the headset.
	get_viewport().use_xr = true
	# This will be the reference space type you ultimately got, out of the
	# types that you requested above. This is useful if you want the game to
	# work a little differently in 'bounded-floor' versus 'local-floor'.
	print("Reference space type: " + webxr_interface.reference_space_type)
 
	GlobalState.show_menu_room(get_tree(), "res://taiko_vr/menu/song_menu_2d.tscn")


func _webxr_session_ended() -> void:
	self.visible = true
	# If the user exits immersive mode, then we tell Godot to render to the web
	# page again.
	get_viewport().use_xr = false
 
func _webxr_session_failed(message: String) -> void:
	OS.alert("Failed to initialize: " + message)
 
