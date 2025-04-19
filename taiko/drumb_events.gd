extends Node3D

signal drumb_center_hit(source_object)
signal drumb_edge_hit(source_object)
signal drumb_exited(source_object)

# We need to store this to prevent an object moving from the edge to the center to trigger both edge and center events. To triger a new event, you need to fully leave the drumb first
var already_processed = []

func _ready():
	# Connect signals to methods
	$Edge/Area3D.connect("area_entered", self._on_area_edge_body_entered)
	$Edge/Area3D.connect("area_exited", self._on_area_body_exited)	

	$Center/Area3D.connect("area_entered", self._on_area_center_body_entered)
	$Center/Area3D.connect("area_exited", self._on_area_body_exited)

func _on_area_edge_body_entered(body):
	if body.is_in_group("Controller"):
		if body not in already_processed:
			if body not in $Center/Area3D.get_overlapping_areas():
				already_processed.append(body)
				drumb_edge_hit.emit(body)

func _on_area_center_body_entered(body):
	if body.is_in_group("Controller"):
		if body not in already_processed:
			already_processed.append(body)
			drumb_center_hit.emit(body)

func _on_area_body_exited(body):
	if body.is_in_group("Controller"):
		if body not in $Edge/Area3D.get_overlapping_areas():
			if body not in $Center/Area3D.get_overlapping_areas():
				already_processed.erase(body)
				drumb_exited.emit(body)
