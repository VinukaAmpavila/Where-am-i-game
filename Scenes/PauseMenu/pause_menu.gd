extends Control

@onready var buttonclick: AudioStreamPlayer = $buttonclick


func _input(event):
	if event.is_action_pressed("pause") and visible == false:
		get_parent().open_menu(self)

func _on_button_pressed() -> void:
	buttonclick.play()
	get_parent().close_menu()


func _on_button_2_pressed() -> void:
	buttonclick.play()
	get_parent().close_menu()
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")
