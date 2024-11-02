extends Control



func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_sensitivty_value_changed(value: float) -> void:
	pass # Replace with function body.



func _on_resolution_item_selected(index: int) -> void:
	match index:
		
		0:
			DisplayServer.window_set_size(Vector2i(2560, 1440))
		1:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		2:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		3:
			DisplayServer.window_set_size(Vector2i(1280, 720))


func _on_window_type_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
