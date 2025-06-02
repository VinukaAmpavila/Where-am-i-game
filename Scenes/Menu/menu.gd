extends Control

@onready var menu_song: AudioStreamPlayer = $MenuSong
@onready var buttonclick: AudioStreamPlayer = $buttonclick


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_song.play()
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	buttonclick.play()
	get_tree().change_scene_to_file("res://Scenes/World/world.tscn")


func _on_exit_pressed() -> void:
	buttonclick.play()
	get_tree().quit()
