extends CharacterBody2D

class_name Player

signal healthChanged(health:float)

#animation and movement
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var effect = $effects
@onready var hurtTimer = $hurtTimer
@onready var hurtBox = $hurtBox
var speed = 120
var direction = Vector2.ZERO
var current_dir
var is_moving:bool = false
var enemyCollisions = []
var can_move = true

#sound
@onready var sstrikesound: AudioStreamPlayer = $SwordStrikesound
@onready var pickupsound: AudioStreamPlayer = $Pickupsound
@onready var hurtsound: AudioStreamPlayer = $hurtsound

#Health stuff
@export var maxHealth: float = 4.0
@onready var currentHealth: float = maxHealth
var isHurt: bool = false

#knockback
@export var knockbackPower: int = 500


func _ready() -> void:
	effect.play("RESET")
	add_to_group("player")

func _physics_process(delta: float) -> void:
	playermove()
	move_and_slide()
	play_anim()


func playermove():
	if not can_move:
		return  # Skip movement code if movement is disabled
	
	var mov_y = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	if Input.get_action_raw_strength("thekeyk"):
		print("hello")
	direction = Vector2(mov_x,mov_y).normalized()
	
	velocity = direction * speed
	
	is_moving = direction != Vector2.ZERO
	
	
	if direction == Vector2(1,0):
		current_dir = "right"
	elif direction == Vector2(-1,0):
		current_dir = "left"
	elif direction == Vector2(0,1):
		current_dir = "down"
	elif direction == Vector2(0,-1):
		current_dir = "up"
	
	elif direction == Vector2(1,1):
		current_dir = "right"
	elif direction == Vector2(1,-1):
		current_dir = "right"
		
	elif direction == Vector2(-1,1):
		current_dir = "left"
	elif direction == Vector2(-1,-1):
		current_dir = "left"
		
	elif direction == Vector2(1,1):
		current_dir = "right"
	elif direction == Vector2(1,-1):
		current_dir = "right"
		
	elif direction == Vector2(1,1):
		current_dir = "left"
	elif direction == Vector2(1,-1):
		current_dir = "left"



var is_attacking :bool = false

func play_anim():
	$swordstrike1/CollisionShape2D.set_deferred("disabled", true)
	$swordstrike2/CollisionShape2D.set_deferred("disabled", true)
	$swordstrike3/CollisionShape2D.set_deferred("disabled", true)
	$swordstrike4/CollisionShape2D.set_deferred("disabled", true)
	if Input.is_action_just_pressed("attack"):
		
		
		if current_dir == "down":
			is_attacking = true
			anim.stop()
			anim.play("down atk")
			sstrikesound.play()
			$swordstrike1/CollisionShape2D.set_deferred("disabled", false)
			await anim.animation_finished
			$swordstrike1/CollisionShape2D.set_deferred("disabled", true)
			is_attacking = false
		if current_dir == "up":
			is_attacking = true
			anim.stop()
			anim.play("up atk")
			sstrikesound.play()
			$swordstrike2/CollisionShape2D.set_deferred("disabled", false)
			await anim.animation_finished
			$swordstrike2/CollisionShape2D.set_deferred("disabled", true)
			is_attacking = false
		if current_dir == "left":
			is_attacking = true
			anim.stop()
			anim.flip_h = true
			anim.play("side atk")
			sstrikesound.play()
			$swordstrike3/CollisionShape2D.set_deferred("disabled", false)
			await anim.animation_finished
			$swordstrike3/CollisionShape2D.set_deferred("disabled", true)
			is_attacking = false
		if current_dir == "right":
			is_attacking = true
			anim.stop()
			anim.play("side atk")
			sstrikesound.play()
			$swordstrike4/CollisionShape2D.set_deferred("disabled", false)
			await anim.animation_finished
			$swordstrike4/CollisionShape2D.set_deferred("disabled", true)
			is_attacking = false
	if is_attacking: return
	else:
		if is_moving == true:
			if current_dir =="left":
				anim.flip_h = true
				anim.play("side walk")
			if current_dir =="right":
				anim.flip_h = false
				anim.play("side walk")
			if current_dir == "up":
				anim.play("up walk")
			if current_dir == "down":
				anim.play("down walk")
		else:
			if current_dir =="left":
				anim.flip_h = true
				anim.play("side idle")
			if current_dir =="right":
				anim.flip_h = false
				anim.play("side idle")
			if current_dir == "up":
				anim.play("up idle")
			if current_dir == "down":
				anim.play("idle")

func attack_box():
	if current_dir =="left":
		anim.flip_h = true
		anim.play("side idle")
	if current_dir =="right":
		anim.flip_h = false
		anim.play("side idle")
	if current_dir == "up":
		anim.play("up idle")
	if current_dir == "down":
		anim.play("idle")

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area is HitBox:
		enemyCollisions.append(area)
		var damage = area.damage
		currentHealth -= damage
		print("After damage: ", currentHealth)
		if currentHealth < 0:
			get_node("/root/World/UImenu").get_node("LoseMenu").open()
		healthChanged.emit(currentHealth)
		isHurt = true
		hurtsound.play()
		knockback(area.get_parent().velocity)
		effect.play("hurtBlink")
		hurtTimer.start()
		await hurtTimer.timeout
		effect.play("RESET")
		isHurt = false
	if is_instance_valid(area) and area.has_method("collect"):
		pickupsound.play()
		area.collect()
	if is_instance_valid(area) and area is Medic:
		var heal = area.heal
		currentHealth = currentHealth + heal
		if currentHealth >= maxHealth:
			currentHealth = maxHealth
		healthChanged.emit(currentHealth)


func knockback(enemyVelocity: Vector2):
	var knockbackDir = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDir
	move_and_slide()
