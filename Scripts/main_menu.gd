extends Control
@onready var MainMenu: Control = $"."


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level 1.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
	# Unpause the game
		print("Unpausing game")
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		MainMenu.hide()
		get_tree().paused = false
	else:
	# Pause the game
		print("Pausing game")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		MainMenu.show()
		print("Game paused state:", get_tree().paused)
		get_tree().paused = true
