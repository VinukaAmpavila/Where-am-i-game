extends Area2D

@onready var chatUi = get_tree().root.get_node("World/ChatwindowCTRL/ChatUI")

@export var npc_name: String = "Alex"
@export var npc_context := """Your name is Alex. You are the brave and battle-hardened warrior of Elarion village. You possess crucial knowledge about the demonic invasion that Bill the wizard may not remember due to his curse. You know that the demons are entering this world through a portal hidden somewhere in the forest, and this portal must be closed to save your village and the entire realm. You can identify two types of demons from your combat experience: the Fire Skulls, which move quickly but are vulnerable to physical weapons, and the One-eyed Imps, which are slower but more durable creatures that are particularly susceptible to fire-based attacks. As the village's defender, you feel responsible for protecting your people, but you know you cannot defeat this threat alone - that's why you're grateful the player has arrived. When speaking with the player, focus on providing tactical information about finding the portal in the forest and how to effectively combat the different demon types they'll encounter. Your manner is direct and practical, reflecting your warrior background, though you remain respectful of anyone willing to help your village. You have been injured from fighting demons so it's up to the player to save the world"""

var player_in_range = false
var interaction_icon

func _ready():
	# Connect the signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	# Create the interaction icon
	create_interaction_icon()
	chatUi.close()

func create_interaction_icon():
	# Create a sprite for the interaction icon
	interaction_icon = Sprite2D.new()
	interaction_icon.texture = preload("res://Assets/UI/expression_chat.png") # Replace with your icon path
	interaction_icon.position = Vector2(0, -20) # Position above the NPC
	interaction_icon.visible = false
	add_child(interaction_icon)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		interaction_icon.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		interaction_icon.visible = false
		if chatUi.isOpen:
			chatUi.close()

func _process(delta):
	# Check for interaction input
	if player_in_range and Input.is_action_just_pressed("interact"): # "interact" should be defined in your Input Map
		show_chat_ui()
	

func show_chat_ui():
	if chatUi.isOpen:
		chatUi.close()
		get_tree().paused = false
	else:
		var alex_data = {"Context": npc_context}
		chatUi.show_popup(alex_data)
		get_tree().paused = true
