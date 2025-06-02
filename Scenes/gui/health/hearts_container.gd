extends HBoxContainer

@onready var HeartGuiClass = preload("res://Scenes/gui/health/heart_gui.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print("Hearts container has: ", get_children().size(), " children")

func setMaxHearts(max: int):
	for i in range(max):
		var heart = HeartGuiClass.instantiate()
		add_child(heart)

func updateHearts(currentHealth: float):
	var hearts = get_children()
	var fullHearts = floor(currentHealth)
	var remainder = currentHealth - fullHearts
	
	# First set all hearts to their appropriate state
	# Set full hearts
	for i in range(fullHearts):
		hearts[i].update(3)
	
	# Set partial heart if needed
	if remainder > 0 and fullHearts < hearts.size():
		if remainder <= 0.33:
			hearts[fullHearts].update(1)  # 1/3 filled
		elif remainder <= 0.67:
			hearts[fullHearts].update(2)  # 2/3 filled
		else:
			hearts[fullHearts].update(3)  # Full heart for high partial values
	
	# Set empty hearts
	for i in range(fullHearts + (1 if remainder > 0 else 0), hearts.size()):
		hearts[i].update(0)  # empty
