extends Node2D

@onready var heartContainer = $CanvasLayer/heartsContainer
@onready var player = $TileMap/Player
@onready var bgmusic: AudioStreamPlayer = $bgmusic


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bgmusic.play()
	heartContainer.setMaxHearts(player.maxHealth)
	heartContainer.updateHearts(player.currentHealth)
	player.healthChanged.connect(heartContainer.updateHearts)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_chat_ui_closed() -> void:
	get_tree().paused = false


func _on_chat_ui_opened() -> void:
	get_tree().paused = true
