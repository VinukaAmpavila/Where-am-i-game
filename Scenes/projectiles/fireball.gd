extends Node2D

const SPEED: int = 300
@onready var hit_area = $HitDetection  # Make sure this matches your node name
@onready var effect = $AnimatedSprite2D

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
	effect.play("fireballs")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

# Make sure this function name exactly matches your signal connection
func _on_hit_detection_area_entered(area: Area2D) -> void:
	# Debug line to verify collision detection
	print("Fireball collided with: ", area.name)
	# Check if this is an enemy's hurtbox
	if area.get_parent().has_method("_on_hurtbox_area_entered"):
		# Instead of using groups, directly call the enemy's damage function
		# The area parameter will be the fireball itself
		area.get_parent()._on_hurtbox_area_entered($HitDetection)
	
	# Destroy fireball after any collision
	effect.stop()
	effect.play("fireball dead")
	queue_free()


func _on_hit_detection_body_entered(body: Node2D) -> void:
	effect.stop()
	effect.play("fireball dead")
	queue_free()
