# GPT4AllTCPClient.gd - Enhanced TCP client
extends Node

signal model_loaded_signal(success)
signal response_received(response)
signal request_failed(error)
signal context_set_successful

var _stream := StreamPeerTCP.new()
var _connected := false
var _response_buffer := ""
var _connection_attempts := 0

func _ready():
	print("GPT4AllClient: Initializing...")
	set_process(true)

func connect_to_server(host = "127.0.0.1", port = 8081) -> bool:
	print("GPT4AllClient: Connecting to ", host, ":", port)
	_stream = StreamPeerTCP.new()
	_connected = false
	_response_buffer = ""
	
	var timeout = 10.0
	var poll_interval = 0.1
	var elapsed = 0.0
	
	var err = _stream.connect_to_host(host, port)
	if err != OK:
		print("Immediate connection failure: ", err)
		return false
	
	while elapsed < timeout:
		_stream.poll()  # <-- THIS IS CRUCIAL
		var status = _stream.get_status()
		print("Current status: ", _get_status_string(status))
		match status:
			StreamPeerTCP.STATUS_CONNECTED:
				print("Connection established successfully!")
				_connected = true
				emit_signal("model_loaded_signal", true)
				return true
			StreamPeerTCP.STATUS_ERROR:
				print("Connection error state detected")
				break
		elapsed += poll_interval
		await get_tree().create_timer(poll_interval).timeout
	
	print("Connection timed out after %.1f seconds" % elapsed)
	_stream.disconnect_from_host()
	return false

func get_response(timeout: float):
	var start_time = Time.get_ticks_msec()
	while Time.get_ticks_msec() - start_time < timeout * 1000:
		var available = _stream.get_available_bytes()
		if available > 0:
			return _stream.get_utf8_string(available)
		await get_tree().process_frame
	return null


func generate_response(prompt: String):
	if not _connected:
		emit_signal("request_failed", "Not connected to AI server")
		return
	
	var message = prompt + "\n"
	print("Sending message: ", message.strip_edges())
	
	# Send data with error checking
	var bytes_sent = _stream.put_data(message.to_utf8_buffer())
	if bytes_sent != message.length():
		print("Warning: Only sent %d/%d bytes" % [bytes_sent, message.length()])
		emit_signal("request_failed", "Partial data sent")

func _process(delta):
	if not _connected:
		return
	
	# Check for incoming data
	var available_bytes = _stream.get_available_bytes()
	if available_bytes > 0:
		print("Received %d bytes of data" % available_bytes)
		var data = _stream.get_utf8_string(available_bytes)
		
		if data == null:
			print("Error decoding UTF-8 data")
			return
			
		_response_buffer += data
		
		# Process all complete messages
		while "\n" in _response_buffer:
			var msg_end = _response_buffer.find("\n")
			var complete_msg = _response_buffer.substr(0, msg_end).strip_edges()
			_response_buffer = _response_buffer.substr(msg_end + 1)
			
			if complete_msg == "CONTEXT_OK":
				print("Context set successfully!")
				emit_signal("context_set_successful")
			else:
				emit_signal("response_received", complete_msg)

# Helper function to get a readable status string
func _get_status_string(status):
	match status:
		StreamPeerTCP.STATUS_NONE:
			return "STATUS_NONE (Not connected)"
		StreamPeerTCP.STATUS_CONNECTING:
			return "STATUS_CONNECTING (Connection in progress)"
		StreamPeerTCP.STATUS_CONNECTED:
			return "STATUS_CONNECTED (Connected)"
		StreamPeerTCP.STATUS_ERROR:
			return "STATUS_ERROR (Connection error)"
		_:
			return "UNKNOWN STATUS: " + str(status)

func set_context(context: String) -> void:
	if _connected:
		# Send context with "CONTEXT:" prefix to server
		var message = "CONTEXT:" + context + "\n"
		_stream.put_data(message.to_utf8_buffer())
		print("Context set: ", context)
