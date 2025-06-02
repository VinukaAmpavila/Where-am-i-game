extends PanelContainer

@onready var message_label = $MessageContent  # Reference to the Label node

func _ready():
	# Debugging: Check if message_label exists and its type
	print("message_label exists: ", message_label != null)
	if message_label:
		print("message_label type: ", message_label.get_class())
		print("Initial text: ", message_label.text)
	else:
		print("Error: MessageContent node not found or not properly set up in user_message.tscn")
	# Style setup for the UserMessage container
	self_modulate = Color("e6f7ff")  # Light blue background

func set_message(text):
	# REMOVED: await get_tree().process_frame - This was causing the error
	if message_label:
		print("Setting message: ", text)
		print("Current label text before setting: ", message_label.text)
		message_label.text = text  # Set the text dynamically
		print("Label text after setting: ", message_label.text)
	else:
		print("Error: message_label is null. Check user_message.tscn scene setup.")
