extends Area2D

@onready var chatUi = get_tree().root.get_node("World/ChatwindowCTRL/ChatUI")

@export var npc_name: String = "Sara"
@export var npc_context := """Your name is Sara. You are the skilled carpenter of Elarion village, having taken over the family business after your father. You're hardworking and practical, focused on maintaining the village's structures even during these troubled times. Due to the mysterious curse affecting everyone's memory, you don't recall many details about the demonic invasion or where most villagers have gone. However, you do remember that Alex, the village warrior, can usually be found south from the central statue. Your knowledge is limited primarily to your craft and basic information about the village layout. For any questions beyond your expertise, you prefer to direct people to speak with Chief Adam, as you believe leadership and decision-making should be respected in times of crisis. When speaking with the player, you're friendly but somewhat reserved, as the strange events and memory issues have made you cautious around newcomers. If asked about Alex, you'll mention his location by south of the statue, but for other inquiries, you'll politely suggest consulting the chief."""

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
		var sara_data = {"Context": npc_context}
		chatUi.show_popup(sara_data)
		get_tree().paused = true
