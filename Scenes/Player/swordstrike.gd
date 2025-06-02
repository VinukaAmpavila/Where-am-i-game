extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("enemies") or body.has_method("knockback"):
		# Call the enemy's knockback function
		var player = get_parent()  # Assuming swordstrike is child of player
		body.knockback(player.global_position, player.current_dir, 120.0)
		
