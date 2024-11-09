extends Control
@onready var sensitivty: HScrollBar = $MarginContainer/VBoxContainer/Sensitivty
@onready var line_edit: LineEdit = $MarginContainer/VBoxContainer/LineEdit


func _ready() -> void:
	line_edit.text = str(sensitivty.value)


func _on_sensitivty_value_changed(value: float) -> void:
	Settings.mouse_sensitivty = value
	print(Settings.mouse_sensitivty)
	

func _on_line_edit_text_submitted(new_text: String) -> void:
	var new_value = float(new_text)
	sensitivty.value = new_value
	
	
	
func _on_full_screen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
