extends CanvasLayer

var current_menu: Control = null

func open_menu(menu: Control):
	if current_menu:
		current_menu.visible = false
	current_menu = menu
	current_menu.visible = true
	get_tree().paused = true

func close_menu():
	if current_menu:
		current_menu.visible = false
		current_menu = null
	get_tree().paused = false
