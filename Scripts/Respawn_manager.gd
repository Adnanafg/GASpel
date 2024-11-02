extends Node3D

var enemy_scene = preload("res://Scenes/enemy.tscn")
var respawn_delay = 2.0

var respawn_points = []
var respawn_timers = []

func _ready():
	for child in get_children():
		if child is Marker3D:
			respawn_points.append(child)


func _on_enemy_dead(_param):
	print("Enemy died starting respawn timer.")
	var timer = Timer.new()
	timer.wait_time = respawn_delay
	timer.timeout.connect(_on_enemytimer_timeout)
	timer.one_shot = true
	add_child(timer)
	timer.start()
	respawn_timers.append(timer)

func spawn_enemy(position: Vector3):
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_transform.origin = position
	print("Enemy spawned at position", position)
	enemy.enemy_died.connect(_on_enemy_dead)

func _on_enemytimer_timeout() -> void:
	print("Respawn timer completed.")
	if respawn_points.size() > 0:
		var random_spawn_point = respawn_points[randi() % respawn_points.size()]
		spawn_enemy(random_spawn_point.global_transform.origin)
