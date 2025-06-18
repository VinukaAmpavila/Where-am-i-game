# Where-am-i
Where am I, is the very first game i created for my final year at uni. It involves a top-down style rpg game with an AI to talk with NPCs.

**About the project**

**I. General Description of the Project and Its Purpose**

This project is a 2D role-playing game (RPG) built with the Godot engine, featuring an AI-powered dialogue system for Non-Player Characters (NPCs). The goal is to create a more engaging and immersive experience by allowing NPCs to hold dynamic, context-aware conversations with the player.

The AI-driven dialogue system ensures that every interaction is unique, adapting to the player's choices and questions. This results in a playthrough that feels personal and responsive, making the game world feel truly alive.

**Accessing the Project**

To access and work with the project, import the project folder into the Godot Game Engine (version 4.3).

Open Godot, select "Import," and choose the project’s folder.

Once imported, you can explore, modify, or run the game directly from the Godot editor.

To run the server make sure you have python version 3.x, (Im using python v3.9) and in command prompt type pip install gpt4all. These are the dependencies.
Make a folder called models and download the Llama-3.2-3B-Instruct-Q4_0.gguf ai model into that folder, as the local server was built to run that model.

then using command prompt, navigate to the gpt4allChatbot folder or wherever the file gpt4all_server.py is located and run it by typing "py gpt4all_server.py" and leave the terminal open whlie playing the game.
