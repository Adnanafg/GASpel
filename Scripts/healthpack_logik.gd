extends Node3D
@onready var timer: Timer = $Timer

@export var heal_amount = 25
var is_active = true
var new_health_pack = preload("res://Scenes/healthpack.tscn")


func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(self._on_respawn_timeout)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if is_active and body.is_in_group("player"):
		body.heal(heal_amount)
		is_active = false
		timer.start()
		visible = false


#Timar respawn funktionen
func _on_respawn_timeout() -> void:
	print("respawn function called")
	respawn() 


#respawn funktionen (((((skriv om)))))
func respawn() -> void:
	var health_pack_instance = new_health_pack.instantiate()
	if is_instance_valid(health_pack_instance):
		health_pack_instance.position = position
		get_parent().add_child(health_pack_instance)
		is_active = true
		visible = true
		queue_free()
