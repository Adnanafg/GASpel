extends CharacterBody3D
class_name Enemy

@onready var area: Area3D = $Area3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

@export var SPEED = 5
@export var damage_value = 10
@export var max_health = 100
@export var current_health = 100

signal enemy_died

var enemy_new_instance = preload("res://Scenes/enemy.tscn")

func _physics_process(delta):
	var current_loc = global_transform.origin
	var next_loc = navigation_agent_3d.get_next_path_position()
	var new_velocity = (next_loc - current_loc).normalized() * SPEED
	
	velocity = new_velocity
	move_and_slide()


func _ready() -> void:
	current_health = max_health
	
	
func take_damage(amount: int):
	current_health -= amount
	if current_health == 0:
		die()
	else:
		print("enemy hit current health;", current_health)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("Player collided with enemy")
		body.take_damage(damage_value) 


func target_location_update(target_loc):
	navigation_agent_3d.set_target_position(target_loc)


func die() -> void:
	print("Enemy died")
	emit_signal("enemy_died", global_transform.origin)
	queue_free()
