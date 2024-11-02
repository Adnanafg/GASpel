extends Node3D

@onready var player: player = $player

func _physics_process(delta):
	get_tree().call_group("enemy", "target_location_update", player.global_transform.origin)
