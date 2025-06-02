from flask import Flask, request, jsonify
from gpt4all import GPT4All
import os

app = Flask(__name__)

# Global model reference
model = None

@app.route('/load', methods=['POST'])
def load_model():
    global model
    
    try:
        data = request.json
        model_path = data.get('path', '')
        
        # Determine correct path based on whether it's relative or absolute
        if not os.path.isabs(model_path):
            # If using relative path from Godot, convert it
            base_dir = os.path.dirname(os.path.abspath(__file__))
            model_path = os.path.join(base_dir, model_path)
        
        # Load model
        model = GPT4All(model_path)
        return jsonify({"status": "model_loaded"})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

@app.route('/generate', methods=['POST'])
def generate():
    global model
    
    if model is None:
        return jsonify({"status": "error", "message": "Model not loaded"})
    
    try:
        data = request.json
        prompt = data.get('prompt', '')
        max_tokens = data.get('max_tokens', 256)
        temperature = data.get('temperature', 0.7)
        
        # Generate response
        response = model.generate(prompt, max_tokens=max_tokens, temp=temperature)
        
        return jsonify({"status": "success", "generated_text": response})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)