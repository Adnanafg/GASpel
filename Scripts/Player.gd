extends CharacterBody3D
class_name player


# Character Nodes
@onready var nacke: Node3D = $Nacke
@onready var Huvud: Node3D = $Nacke/Huvud
@onready var standing_collision: CollisionShape3D = $Standing_collision
@onready var crouching_collision: CollisionShape3D = $Crouching_collision
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var camera_3d: Camera3D = $Nacke/Huvud/Camera3D
@onready var gun_animation = $Nacke/Huvud/Camera3D/AK74U/AnimationPlayer
@onready var pistolpipa = $Nacke/Huvud/Camera3D/AK74U/RayCast3D
@onready var healthbar: ProgressBar = $Nacke/Huvud/Camera3D/AK74U/UI/healthbar






@export var max_health = 100.0
var current_health = max_health
var is_alive = true
@export var damage_value = 10
@export var heal_value = 25

var skott = preload("res://Scenes/skott.tscn")
var instance

@export var current_speed = 5.0
@export var lerp_speed = 13.0
@export var walking_speed = 5.0
@export var sprinting_speed = 8.0
@export var crouching_speed = 3.0
@export var jump_velocity = 4.5
@export var crouching_height= -0.4

var slide_timer = 0.0
var slide_timer_max = 1.2
var slide = false
var slide_vector = Vector2.ZERO
@export var slide_speed = 10.0
var can_slide = true

var walking = false
var sprinting = false
var crouching = false

var direction = Vector3.ZERO
var free_looking = false
var free_look_tilt = 1.5
var mouse_sensitivty = Settings.mouse_sensitivty


func _unhandled_input(event):
#Detta är en funktion som gör att när jag trycker "ESC" så visar den mitt mus pekare
	if event.is_action_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#Detta är en funktion som gör att när jag trycker vänster click på musen så låser den in mitt mus in i skärmen
	if event.is_action_pressed("left_click"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


#kamera kontroll
func _input(event):
	if event is InputEventMouseMotion:
		if free_looking: 
			nacke.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivty))
			nacke.rotation.y = clamp(nacke.rotation.y,deg_to_rad(-100), deg_to_rad(100))
		else:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivty))
			Huvud.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivty))
			Huvud.rotation.x = clamp(Huvud.rotation.x,deg_to_rad(-90),deg_to_rad(90))


func _physics_process(delta):
	#Tar våra inputs och översätter de till rörelse i spelet
	var input_dir := Input.get_vector("left", "right", "up", "down")


#Skjut och skott animations
	if Input.is_action_pressed("shoot"):
		if !gun_animation.is_playing():
			gun_animation.play("shoot")
			instance = skott.instantiate()
			instance.position = pistolpipa.global_position
			instance.transform.basis = pistolpipa.global_transform.basis
			get_tree().root.add_child(instance)
#crouch logik
	if Input.is_action_pressed("crouch"):
		current_speed = crouching_speed
		Huvud.position.y = lerp(Huvud.position.y, + crouching_height,delta*lerp_speed)
		
		standing_collision.disabled = true
		crouching_collision.disabled = false
		
		#slide början logik
		if sprinting && input_dir != Vector2.ZERO and can_slide and not slide:
			slide = true
			slide_timer = slide_timer_max
			slide_vector = input_dir
			free_looking = true
			print("slide start")
			can_slide = false
			
		walking = false
		sprinting = false
		crouching = true
		
	elif !ray_cast_3d.is_colliding():
		
		#standing logik
		crouching_collision.disabled = true
		standing_collision.disabled = false
		
		Huvud.position.y = lerp(Huvud.position.y,0.0,delta*lerp_speed)
		
		
	#sprint logik
	if Input.is_action_just_pressed("sprint") and not sprinting:
	# Låta spelare slida en gång per sprint
		current_speed = sprinting_speed
		walking = false
		sprinting = true
		crouching = false
		can_slide = true

	elif not Input.is_action_pressed("sprint"):
	# Reset sprinting och walking state
		current_speed = walking_speed
		walking = true
		sprinting = false
		crouching = false
		can_slide = false  
		
	#Ta hand om freelook
	if Input.is_action_pressed("free_look") or slide:
		free_looking = true
		camera_3d.rotation.z = deg_to_rad(rotation.y*free_look_tilt)
	else:
		free_looking = false
		nacke.rotation.y = lerp(nacke.rotation.y,0.0,delta*lerp_speed)
		camera_3d.rotation.z = lerp(camera_3d.rotation.z,0.0,delta*lerp_speed)
		
	#Slide logik
	if slide:
		slide_timer -= delta
		if slide_timer <= 0:
			slide = false
			print("slide slut")
			free_looking = false
			
	# Gravitation logik.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Hopp logik.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*lerp_speed)
	
	if slide:
		direction = (transform.basis * Vector3(slide_vector.x,0,slide_vector.y)).normalized()
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		
		if slide:
			velocity.x = direction.x * slide_timer * slide_speed
			velocity.z = direction.z * slide_timer * slide_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
		
	move_and_slide()


func _on_Area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"): 
		take_damage (damage_value)
		
	if body.is_in_group("healing_items"): 
		heal(heal_value)
		body.queue_free()


func update_health_bar() -> void:
	healthbar.value = current_health


func take_damage(amount: int) -> void:
	if is_alive:
		current_health -= amount
		if current_health <= 0:
			die()
		update_health_bar()  
		print("Player took damage, current health:", current_health)


func heal(amount: int) -> void:
	if is_alive:
		current_health += amount
		if current_health > max_health:
			current_health = max_health
		update_health_bar()
		print("Player healed, current health:", current_health)


func die () -> void:
	is_alive = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
