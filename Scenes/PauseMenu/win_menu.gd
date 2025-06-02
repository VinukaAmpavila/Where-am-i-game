extends Control

@onready var buttonclick: AudioStreamPlayer = $buttonclick
@onready var endsong: AudioStreamPlayer = $endsong

func open():
	endsong.play()
	get_parent().open_menu(self)

func _on_button_pressed() -> void:
	buttonclick.play()
	get_parent().close_menu()
	get_tree().reload_current_scene()


func _on_button_2_pressed() -> void:
	buttonclick.play()
	get_parent().close_menu()
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")
