extends CharacterBody2D

@export var speed = 20
@export var limit = 1
@export var endPoint: Marker2D
@export var enemyhealth = 100
@export var playerdamage = 25
@export var firebdamage = 30
var knockback_active = false
var knockback_timer = 0.0
var knockback_duration = 0.15  # seconds
@onready var chase_timer = $chase_timer

@onready var animation = $AnimationPlayer
@onready var effect = $effect
@onready var hurtTimer = $hurtTimer
@onready var enemy_deathSound: AudioStreamPlayer = $EnemyDeath
@onready var deathsound: Timer = $deathsound

var target = Player
var player = null

enum State { PATROL, CHASE }
var state = State.PATROL

var startPosition
var endPosition

@onready var mplayer = $"../Player"


func _ready() -> void:
	add_to_group("enemies")
	$hurtbox.add_to_group("enemies")
	startPosition = position
	endPosition = endPoint.position
	effect.play("RESET")

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	match state:
		State.PATROL:
			var moveDirection = (endPosition - position)
			if moveDirection.length() < limit:
				changeDirection()
			velocity = moveDirection.normalized() * speed

		State.CHASE:
			if player:
				var moveDirection = (player.global_position - global_position)
				velocity = moveDirection.normalized() * speed


func updateAnimation():
	if velocity.length() == 0:
		if animation.is_playing():
			animation.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
		animation.play("walk" + direction)

func _physics_process(delta) -> void:
	if knockback_active:
		move_and_slide()
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback_active = false
			velocity = Vector2.ZERO
	else:
		updateVelocity()
		move_and_slide()
		updateAnimation()



func _on_slime_1_aware_area_entered(body) -> void:
	pass


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area == $hitBox: return
	if area == $slime1aware: return
	print("Slime hit")
	if area.name.begins_with("HitDetection"):
		# Fireball damage (can be different from sword damage)
		enemyhealth -= firebdamage
		print(enemyhealth)
	elif area.name.begins_with("swordstrike"):
		# Sword damage
		enemyhealth -= playerdamage
		print("Sword hit! Health: ", enemyhealth)
	effect.play("hurtblink")
	hurtTimer.start()
	await hurtTimer.timeout
	effect.play("RESET")
	if is_instance_valid(area) and area.name == "swordstrike1":  # Up
		velocity = Vector2(0, 120)
		knockback_active = true
		knockback_timer = knockback_duration
	elif is_instance_valid(area) and area.name == "swordstrike2":  # Right
		velocity = Vector2(-120, 0)
		knockback_active = true
		knockback_timer = knockback_duration
	elif is_instance_valid(area) and area.name == "swordstrike3":  # Down
		velocity = Vector2(0, -120)
		knockback_active = true
		knockback_timer = knockback_duration
	elif is_instance_valid(area) and area.name == "swordstrike4":  # Left
		velocity = Vector2(120, 0)
		knockback_active = true
		knockback_timer = knockback_duration
	if enemyhealth <= 0:
		deathsound.start()
		enemy_deathSound.play()
		await deathsound.timeout
		
		queue_free()

func knockback(playerPosition: Vector2, attackDirection: String, knockbackPower: float = 120.0):
	# Calculate knockback direction based on player position and attack direction
	var knockbackDir = Vector2.ZERO
	   
	match attackDirection:
		"down":
			knockbackDir = Vector2(0, 1)
		"up":
			knockbackDir = Vector2(0, -1)
		"left":
			knockbackDir = Vector2(-1, 0)
		"right":
			knockbackDir = Vector2(1, 0)
	
	# Make sure enemy moves away from player
	if (global_position - playerPosition).dot(knockbackDir) < 0:
		knockbackDir = -knockbackDir
	   
	# Apply knockback
	velocity = knockbackDir.normalized() * knockbackPower
	move_and_slide()
	  
	# Optional: add a timer to prevent movement during knockback
	$KnockbackTimer.start()


func _on_slime_1_aware_area_exited(body) -> void:
	pass

func _on_chase_timer_timeout():
	state = State.PATROL
	player = null


func _on_slime_1_aware_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): # Use groups for flexibility
		player = body
		state = State.CHASE
		chase_timer.stop() # Stop timer if running
		print("entered")


func _on_slime_1_aware_body_exited(body: Node2D) -> void:
	if body == player:
		chase_timer.start()
		await chase_timer.timeout
		state = State.PATROL
