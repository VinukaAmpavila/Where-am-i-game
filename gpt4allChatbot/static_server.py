import socket
import threading
from gpt4all import GPT4All

# Configure these settings
HOST = '127.0.0.1'
PORT = 8081
MODEL_PATH = "G:/0Godot/Projects/practicerun/models/Llama-3.2-3B-Instruct-Q4_0.gguf"

# Load the model once
print(f"Loading model from {MODEL_PATH}...")
model = GPT4All(MODEL_PATH, allow_download=False, device="cpu", verbose=False)
print("Model loaded successfully!")

current_context = ""

def handle_client(client_socket):
    global current_context
    print("New client connected")
    
    try:
        buffer = ""
        while True:
            data = client_socket.recv(1024).decode('utf-8')
            if not data:
                print("Client disconnected - no data")
                break
                
            buffer += data
            
            while '\n' in buffer:
                message, buffer = buffer.split('\n', 1)
                
                if message.startswith("CONTEXT:"):
                    current_context = message[8:]
                    print(f"Context set: {current_context}")
                    client_socket.sendall(b"CONTEXT_OK\n")
                    continue
                
                print(f"Processing message: {message}")
                
                try:
                    # Format prompt with proper conversation tokens
                    full_prompt = f"{current_context}\n<|im_start|>user\n{message}<|im_end|>\n<|im_start|>assistant\n"
                    
                    # Generate response with controlled parameters
                    response = model.generate(
                        full_prompt,
                        max_tokens=150,    # Keep responses short
                        temp=0.7,         # Control randomness (0-1)
                        top_k=40          # Focus on top probable tokens
                    )
                    
                    # Manually handle stopping at conversation markers
                    stop_phrases = ["<|im_start|>", "<|im_end|>", "\nUser:"]
                    for phrase in stop_phrases:
                        if phrase in response:
                            response = response.split(phrase)[0]
                            break
                    
                    # Send cleaned response
                    client_socket.sendall((response + "\n").encode('utf-8'))
                    print(f"Sent response: {response}")
                    
                except Exception as e:
                    print(f"Error generating response: {e}")
                    client_socket.sendall(b"ERROR: Failed to generate response\n")
                    
    except Exception as e:
        print(f"Connection error: {e}")
    finally:
        client_socket.close()
        print("Client disconnected")

# Server setup
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server.bind((HOST, PORT))
server.listen(5)
print(f"Server listening on {HOST}:{PORT}")

try:
    while True:
        client, addr = server.accept()
        client_thread = threading.Thread(target=handle_client, args=(client,))
        client_thread.daemon = True
        client_thread.start()
except KeyboardInterrupt:
    print("Server shutting down")
    server.close()
