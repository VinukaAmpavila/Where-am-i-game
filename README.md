# Where-am-i
Where am I, is the very first game i created for my final year at uni. It involves a top-down style rpg game with an AI to talk with NPCs.

How to Play "Where am I?"

the godot version i used is 4.3

you would first need to download Llama-3.2-3B-Instruct-Q4_0.gguf model, I did through gpt4all app, 
Then you need to put it inside the model folder

What’s in this folder?
Where am i.exe — The game itself. Double-click to play!
Where am i.pck — Game data (don’t delete or move).
models/ — AI model files (needed for NPC chat).
setup/ — The AI chat server. Needed for talking to NPCs.


How to Start the Game
Step 1: Start the AI Chat Server
	Open the setup folder.

	Double-click mygame_server.exe.

	A black window will appear—leave it open while playing.

Step 2: Start the Game
	Go back to the main game folder.

	Double-click Where am i.exe to launch the game.

Step 3: Play!
	Talk to NPCs in the game. They’ll respond thanks to the AI chat server running in the background.



The game is still playable even if you dont run the server, the only thing that wont work is the AI NPC chat bot, 

Just letting you know, the AI is very slow, when i mean slow, like you will have to wait like 2 minutes or more for each response,
this is because partially due to developing it in my pc which is old and hardware is bad, so i can't really fix it, either it can be fast and nonsensical or slow and coherent.
Both are bad so its upto you to run the server

The server is fully offline, all it does is makes a local server in your machine that allows the game and AI to communicate and nothing else.

This project uses the Llama 3.2 3B Instruct model, licensed under the Llama 3.2 Community License, Copyright © Meta Platforms, Inc. All Rights Reserved.
