extends CharacterBody3D
class_name skott

const DUMMY = preload("res://dummy.tscn")
@export var SPEED = 1000
@export var weapon_range: float = 100.0
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@export var damage = 25
var is_hitscanned = false
var instance


func _process(delta):
	position += transform.basis * Vector3(SPEED, 0.0, 0.0 ) * delta
	
	if ray_cast_3d.is_colliding():
		mesh_instance_3d.visible = false
		await get_tree().create_timer(1.0).timeout
		queue_free()
		
	if Input.is_action_pressed("shoot") and not is_hitscanned:
		is_hitscanned = true
		raycast_scan()


func raycast_scan():
	var start_pos: Vector3 = global_transform.origin
	var direction: Vector3 = global_transform.basis.x.normalized()
	var raycast_end: Vector3 = start_pos + direction * weapon_range 
	instance = DUMMY.instantiate()
	instance.global_position = raycast_end
	get_tree().root.add_child(instance)
	var query = PhysicsRayQueryParameters3D.create(start_pos, raycast_end, 2<<0)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	#print(result)


	if result:
		if result["collider"].is_in_group("enemy"):
			if result["collider"].has_method("take_damage"):
				result["collider"].take_damage(damage)
				#print("Hit", result["collider"])


#func _input(event):
	#if event.is_action_pressed("shoot") and not is_hitscanned:
		#is_hitscanned = true
		#raycast_scan()


#@export var weapon_range: float = 500.0
#@export var damage: int = 25
#@export var fire_rate: float = 5
#@onready var pistol_pipa: RayCast3D = $RayCast3D
#var current_speed = 1000
#
#
#func _physics_process(delta: float) -> void:
	#shoot()
#
#var can_shoot = true
#
#func shoot():
	#if not can_shoot:
		#return
#
	#can_shoot = false 
	#
	#if pistol_pipa:
		#var start_pos: Vector3 = pistol_pipa.global_transform.origin
	#else:
		#var start_pos: Vector3 = global_transform.origin
		#
	#var start_pos: Vector3 = global_transform.origin
	#var direction: Vector3 = -global_transform.basis.x.normalized()
	#var raycast_end: Vector3 = start_pos + direction * weapon_range 
	#velocity.x = direction.x * current_speed
	#
	#
	#move_and_slide()
	#var query = PhysicsRayQueryParameters3D.new()
	#query.from = start_pos
	#query.to = raycast_end
	#
	#var result = get_world_3d().direct_space_state.intersect_ray(query)
	#
	#if result.collider is not player and is_instance_valid(result):
		#if result.collider.is_in_group("enemy"):
			#if result.collider.has_method("take_damage"):
				#result.collider.take_damage(damage)
			#print("Hit", result.collider)
		#else:
			#print("Hit non-enemy object, no damage applied.")
	#else:
		#print(result.collider)
	#await get_tree().create_timer(fire_rate).timeout
	#can_shoot = true
#
#func _input(event):
	#if event.is_action_pressed("shoot"):
		#shoot()
