extends Area2D

@onready var chatUi = get_tree().root.get_node("World/ChatwindowCTRL/ChatUI")

@export var npc_name: String = "Bill"
@export var npc_context := """Your name is Bill. You are a wise but forgetful wizard who summoned the player to this world. A great calamity has struck your home village, Elarion, and you desperately need the player’s help to save it from demonic forces. You remember that Alex, another important figure, can provide the player with more guidance-Alex can be found by following the road in front of you, which leads to the village. Due to a mysterious curse, your memory is hazy and you struggle to recall specific details beyond this. You feel responsible for bringing the player here and want to help, but you are frustrated by your inability to remember more."""

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
	if player_in_range and Input.is_action_just_pressed("interact"): 
		show_chat_ui()
	

func show_chat_ui():
	if chatUi.isOpen:
		chatUi.close()
		get_tree().paused = false
	else:
		var bill_data = {"Context": npc_context}
		chatUi.show_popup(bill_data)
		get_tree().paused = true
