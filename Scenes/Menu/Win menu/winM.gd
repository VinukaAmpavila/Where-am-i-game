extends Control

func open():
	get_parent().open_menu(self)

func _on_retry_pressed():
	get_parent().close_menu()
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	get_parent().close_menu()
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")
