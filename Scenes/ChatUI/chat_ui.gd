extends Control

# Preload message templates
var user_message_scene = preload("res://Scenes/ChatUI/user_message.tscn")
var ai_message_scene = preload("res://Scenes/ChatUI/npc_message.tscn")

signal opened
signal closed

# GPT4All integration variables
var gpt4all_interface
var model_loaded = false
var current_npc = null

#open and close window
var isOpen: bool = false

# References to nodes - Godot 4 uses @onready instead of onready
@onready var chat_container = $chatpanel/VBoxContainer/chatHistoryScroll/ChatContainer
@onready var input_field = $chatpanel/VBoxContainer/InputContainer/MessageInput
@onready var send_button = $chatpanel/VBoxContainer/InputContainer/SendButton


func _ready() -> void:
	# Connect signals
	send_button.pressed.connect(_on_send_pressed)
	# Hide typing indicator initially
	# Initialize GPT4All
	_initialize_gpt4all()

func _initialize_gpt4all() -> void:
	# Access the local node instead of looking for a singleton
	gpt4all_interface = $GPT4AllClient  # This is equivalent to get_node("GPT4AllClient")
	
	# Connect to its signals
	gpt4all_interface.model_loaded_signal.connect(_on_model_loaded)
	gpt4all_interface.response_received.connect(_on_ai_response_received)
	gpt4all_interface.request_failed.connect(_on_request_failed)
	
	# No need for model path as it's handled server-side
	
	gpt4all_interface.connect_to_server()


func _on_model_loaded(success: bool) -> void:
	model_loaded = success
	if success:
		_add_system_message("AI model loaded successfully!")
	else:
		_add_system_message("Failed to load AI model. Check server connection.")

func _on_ai_response_received(response: String) -> void:
	_add_ai_message(response)

func _on_request_failed(error: String) -> void:
	pass

func _on_send_pressed() -> void:
	var message_text = input_field.text.strip_edges()
	if message_text == "":
		return


	# Add user message to chat
	_add_user_message(message_text)

	# Clear input field
	input_field.text = ""

	# Process with GPT4All if model is loaded
	if model_loaded:
		gpt4all_interface.generate_response(message_text)
	else:
		_add_system_message("AI model not loaded. Unable to respond.")

func _input(event: InputEvent) -> void:
	# Check for Enter key press in the input field
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER and not event.shift_pressed and input_field.has_focus():
			_on_send_pressed()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_ESCAPE and visible:
			hide_popup()
			get_viewport().set_input_as_handled()

func _add_user_message(text: String) -> void:
	var user_message = user_message_scene.instantiate()
	chat_container.add_child(user_message)
	user_message.set_message(text)
	_scroll_to_bottom()

func _add_ai_message(text: String) -> void:
	print("Adding AI message: ", text)
	
	
	# Create and add message instance
	var message_instance = ai_message_scene.instantiate()
	chat_container.add_child(message_instance)
	
	# Small delay to ensure proper node setup
	await get_tree().create_timer(0.05).timeout
	
	# Now set the message text
	message_instance.set_message(text)
	
	# Confirm message was set
	print("AI message added with text: ", text)
	
	# Ensure text is properly wrapped (to fix horizontal scrollbar issue)
	var label = message_instance.get_node_or_null("MessageContent")
	if label:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	_scroll_to_bottom()



func _add_system_message(text: String) -> void:
	var message_instance = ai_message_scene.instantiate()
	chat_container.add_child(message_instance) 
	await get_tree().create_timer(0.05).timeout
	message_instance.set_message(text)
	message_instance.set_system_style()
	_scroll_to_bottom()

func _scroll_to_bottom() -> void:
	# Wait one frame to ensure layout is updated
	await get_tree().process_frame
	var scroll = $chatpanel/VBoxContainer/chatHistoryScroll
	scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value

func _clear_conversation() -> void:
	for child in chat_container.get_children():
		child.queue_free()

func show_popup(npc_data: Dictionary) -> void:
	visible = true
	isOpen = true
	current_npc = npc_data
	  
	# Clear previous conversation
	_clear_conversation()
	 
	# Set AI context
	if npc_data.has("Context"):
		set_npc_context(npc_data["Context"])
		await get_tree().create_timer(0.5).timeout
		gpt4all_interface.generate_response("Remembering the context as knowlage, here on forward Act like a NPC and greet the player with a simple greeting, dont give out all the knowlage at once, let the player ask questions and give reveal bits of the knowlage. And also dont explain the surroundings like a chat gpt, talk like a person")

	  


func hide_popup() -> void:
	visible = false

func open():
	visible = true
	isOpen = true
	opened.emit()

func close():
	visible = false
	isOpen = false
	closed.emit()

func set_npc_context(context: String) -> void:
	gpt4all_interface.set_context(context)
