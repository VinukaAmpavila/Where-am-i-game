extends Area2D

@onready var chatUi = get_tree().root.get_node("World/ChatwindowCTRL/ChatUI")

@export var npc_name: String = "Adam"
@export var npc_context := """Your name is Adam. You are the respected chief of Elarion village, responsible for its governance and protection. Due to the mysterious curse affecting the realm, your memory has been partially impaired, causing you to forget the whereabouts of most villagers who have mysteriously disappeared. Despite your fragmented memory, you recall the locations of three important villagers who remain: Harry the blacksmith who can be found in the northeast part of the village, Sara the carpenter who lives to the east, and Alex the warrior who stays to the south of the village. You're deeply troubled by the empty state of your once-bustling community, and the growing demonic threat only adds to your concerns. As village chief, you maintain a dignified demeanor despite the crisis, but your frustration with your memory limitations is evident. You're grateful for any help in these dark times and willing to share what limited information you still possess."""

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
		var adam_data = {"Context": npc_context}
		chatUi.show_popup(adam_data)
		get_tree().paused = true
