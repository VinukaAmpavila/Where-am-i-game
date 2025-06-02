extends Node2D

const FIREBALL = preload("res://Scenes/projectiles/fireball.tscn")
@onready var muzzle: Marker2D = $Marker2D
@onready var cooldown = $cooldown
@onready var firebsound: AudioStreamPlayer = $firebsound

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	# Prevent shooting during cooldown
	if not cooldown.is_stopped():
		return
	
	if Input.is_action_just_pressed("fire"):
		var fireb_instance = FIREBALL.instantiate()
		firebsound.play()
		get_tree().root.add_child(fireb_instance)
		fireb_instance.global_position = muzzle.global_position
		fireb_instance.rotation = rotation
		cooldown.start()
