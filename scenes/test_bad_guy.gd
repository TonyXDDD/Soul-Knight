extends CharacterBody2D

# Variables for detecting the player
@export var speed: float = 50.0  # Speed of the enemy
@export var detection_radius: float = 100.0
var minimum_detection_radius: float = 20.0  # Minimum detection radius
var chase_detection_radius: float = 800.0   # Increased detection radius while chasing
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var texture_progress_bar: TextureProgressBar = $Control/TextureProgressBar

var is_chasing_player: bool = false
var is_hitting: bool = false  # Flag to track if the hit animation is playing
var is_attacking: bool = false  # Flag to track if the attack animation is playing

# Reference to the player node
var player: Node2D

# HP reference
var health: int = 50  # Health variable for the enemy

# Attack ranges
@export var attack_animation_radius: float = 55.0  # Distance to trigger attack animation
@export var damage_radius: float = 80.0  # Distance to apply damage to the player

var attack_cooldown: float = 2.0  # Cooldown period between attacks
var attack_timer: float = 1.5  # Timer to track the cooldown
var movement_timeout: float = 1.5  # Time to remain idle after attacking
var movement_timeout_timer: float = 0.0  # Timer for the movement timeout

# Flashing variables
var is_flashing: bool = false  # Flag to indicate if flashing
var flash_duration: float = 0.5  # Duration of the flash effect
var flash_timer: float = 0.0  # Timer for flashing
var original_color: Color  # Store the original color

# Gravity variables
@export var gravity: float = 400.0  # Gravity strength
var is_on_ground: bool = false  # Check if the enemy is on the ground

# Cooldown timers for mouse damage
var left_mouse_cooldown: float = 0.3  # 0.5 seconds for left mouse button
var left_mouse_timer: float = 0.0  # Timer to track left mouse cooldown
var right_mouse_cooldown: float = 0.5  # 1 second for right mouse button
var right_mouse_timer: float = 0.0  # Timer to track right mouse cooldown

# Called when the node enters the scene tree for the first time
func _ready():
	player = get_player_in_group()
	original_color = animated_sprite_2d.modulate  # Save the original color
	texture_progress_bar.max_value = health
	texture_progress_bar.value = health

func _physics_process(delta: float):
	# Update attack cooldown timer
	if attack_timer > 0:
		attack_timer -= delta

	# Update movement timeout timer
	if movement_timeout_timer > 0:
		movement_timeout_timer -= delta
		play_animation("idle")
		velocity.x = 0

	# Update cooldown timers for mouse damage
	if left_mouse_timer > 0:
		left_mouse_timer -= delta
	if right_mouse_timer > 0:
		right_mouse_timer -= delta

	if movement_timeout_timer <= 0:
		if player and is_player_in_range() and not player.is_in_group("GhostGroup"):
			is_chasing_player = true
		else:
			is_chasing_player = is_chasing_player and is_player_in_chase_range()

		if is_chasing_player:
			if is_player_in_attack_animation_range() and attack_timer <= 0:
				attack_player()
			else:
				chase_player(delta)
		else:
			velocity.x = 0
			move_and_slide()
			play_animation("idle")

	# Gravity effect
	if not is_on_ground:
		velocity.y += gravity * delta

	is_on_ground = is_on_floor()
	if is_on_ground and velocity.y > 0:
		velocity.y = 0

	move_and_slide()

	# Check for mouse button clicks when the player is very close
	if is_player_very_close():
		if Input.is_action_just_pressed("left_mouse_click") and left_mouse_timer <= 0:
			health -= 10  # Decrease health by 10 for left click
			flash_effect()
			left_mouse_timer = left_mouse_cooldown  # Reset left mouse cooldown
		elif Input.is_action_just_pressed("right_mouse_click") and right_mouse_timer <= 0:
			health -= 15  # Decrease health by 15 for right click
			flash_effect()
			right_mouse_timer = right_mouse_cooldown  # Reset right mouse cooldown

		texture_progress_bar.value = health

	# Check if health is 0 or below and play death animation if true
	if health <= 0:
		audio_stream_player_2d_2.play()
		await play_death_animation()

	# Handle flashing effect
	if is_flashing:
		flash_timer -= delta
		if flash_timer <= 0:
			is_flashing = false
			animated_sprite_2d.modulate = original_color
		else:
			if int(flash_timer * 10) % 2 == 0:
				animated_sprite_2d.modulate = Color(1, 0, 0)
			else:
				animated_sprite_2d.modulate = original_color

# Function to trigger the flash effect
func flash_effect():
	is_flashing = true
	flash_timer = flash_duration

func is_player_in_range() -> bool:
	var actual_radius = max(detection_radius, minimum_detection_radius)
	return position.distance_to(player.position) <= actual_radius

func is_player_in_chase_range() -> bool:
	return position.distance_to(player.position) <= chase_detection_radius

func is_player_in_attack_animation_range() -> bool:
	return position.distance_to(player.position) <= attack_animation_radius

func is_player_in_damage_range() -> bool:
	return position.distance_to(player.position) <= damage_radius

func is_player_very_close() -> bool:
	var very_close_distance = 70.0
	return position.distance_to(player.position) <= very_close_distance

func chase_player(delta: float):
	if is_hitting or is_attacking or movement_timeout_timer > 0:
		move_and_slide()
		return

	if player.position.x > position.x:
		velocity.x = speed * 1.5
		animated_sprite_2d.flip_h = false
	else:
		velocity.x = -speed * 1.5
		animated_sprite_2d.flip_h = true

	move_and_slide()
	play_animation("run")

func attack_player():
	if not is_attacking:
		is_attacking = true
		velocity.x = 0
		play_animation("attack")

		await animated_sprite_2d.animation_finished

		if is_player_in_damage_range():
			player.take_damage(30)

		attack_timer = attack_cooldown
		movement_timeout_timer = movement_timeout
		is_attacking = false

		if not is_chasing_player:
			play_animation("idle")
		else:
			chase_player(get_process_delta_time())

func play_animation(animation_name: String):
	if animated_sprite_2d.animation != animation_name:
		animated_sprite_2d.play(animation_name)

func play_death_animation():
	velocity = Vector2.ZERO
	set_physics_process(false)
	play_animation("death")

	await animated_sprite_2d.animation_finished
	player.heal(20)
	queue_free()

func get_player_in_group() -> Node2D:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		return players[0] as Node2D
	return null
