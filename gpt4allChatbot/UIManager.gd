extends Node

# Signal that gets emitted when an NPC is interacted with
signal npc_interaction_requested(npc_data)

# Function to request chat UI to open
func request_npc_chat(npc_data):
	emit_signal("npc_interaction_requested", npc_data)
