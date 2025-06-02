extends PanelContainer

@onready var message_label = $MessageContent

func _ready():
	# Style setup
	self_modulate = Color("e6ffea")  # Light green background
	
	# Debug initial state
	if message_label:
		
		# Clear any default text that might be in the Label
		message_label.text = ""
		
	else:
		push_error("MessageContent node not found in npc_message.tscn during _ready()")

func set_message(text: String) -> void:
	# Attempt to get a fresh reference to the label
	var label = get_node_or_null("MessageContent")
	
	if label:
		# Set text using the fresh reference
		label.text = text
		print("NPC set_message() - Text set using get_node reference: ", text)
	elif message_label:
		# Use the @onready variable as fallback
		message_label.text = text
		print("NPC set_message() - Text set using @onready reference: ", text)
	else:
		# All attempts failed
		push_error("Unable to set message text - all references to MessageContent are null")
		# Last resort - create a new label
		var new_label = Label.new()
		new_label.name = "MessageContent"
		new_label.text = text
		add_child(new_label)
		print("NPC set_message() - Created new label with text: ", text)

func set_system_style():
	self_modulate = Color("ffeeee")  # Light red background
