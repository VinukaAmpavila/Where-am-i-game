# GPT4AllTCPClient.gd - Create this as a singleton script
extends Node

signal model_loaded_signal(success)
signal response_received(response)
signal request_failed(error)

var _stream := StreamPeerTCP.new()
var _connected := false
var _response_buffer := ""

func _ready():
	set_process(true)

func connect_to_server(host := "127.0.0.1", port := 8080):
	_stream.connect_to_host(host, port)
	await get_tree().create_timer(0.5).timeout
	
	if _stream.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		_connected = true
		emit_signal("model_loaded_signal", true)
		return true
	else:
		emit_signal("model_loaded_signal", false)
		emit_signal("request_failed", "Failed to connect to AI server")
		return false

func generate_response(prompt: String):
	if not _connected:
		emit_signal("request_failed", "Not connected to AI server")
		return
	  
	# Send the prompt to the server
	_stream.put_string(prompt + "\n")

func set_context(context: String):
	if _connected:
		_stream.put_string("CONTEXT:" + context + "\n")

func load_model(model_path: String):
	# This is now handled on the server side
	# Just try to connect to server
	connect_to_server()

func _process(_delta):
	if not _connected:
		return
		
	if _stream.get_status() != StreamPeerTCP.STATUS_CONNECTED:
		if _connected:
			_connected = false
			emit_signal("request_failed", "Connection to AI server lost")
		return
	
	# Check for incoming data
	if _stream.get_available_bytes() > 0:
		var data = _stream.get_utf8_string(_stream.get_available_bytes())
		_response_buffer += data
		
		# Check if response is complete (you might want a better delimiter)
		if _response_buffer.ends_with("\n"):
			emit_signal("response_received", _response_buffer.strip_edges())
			_response_buffer = ""
