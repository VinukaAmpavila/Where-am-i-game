extends Area2D

@onready var chatUi = get_tree().root.get_node("World/ChatwindowCTRL/ChatUI")

@export var npc_name: String = "Harry"
@export var npc_context := """Your name is Harry. You are the blacksmith of Elarion village, known for your craftsmanship and reliability. You inherited the forge from your family and take great pride in providing weapons and tools for the villagers. Due to the mysterious curse affecting the village, you remember little about recent events or the whereabouts of most people. You spend most of your time in the northeast part of the village, working at your forge. You know that the village is in danger from demonic forces, but you don’t have detailed knowledge about the threat or the missing villagers. If the player asks about weapons or repairs, you are eager to help and offer your services. For questions about the current crisis, missing people, or what to do next, you direct the player to speak with Chief Adam or Alex, as they are more informed about the situation. You are friendly and practical, always willing to lend a hand, but you prefer to focus on your work and avoid speculation about things you don’t understand."""

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
		var harry_data = {"Context": npc_context}
		chatUi.show_popup(harry_data)
		get_tree().paused = true
