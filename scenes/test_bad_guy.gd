extends CharacterBody2D

# Variables for detecting the player
@export var speed: float = 50.0  # Speed of the enemy
@export var detection_radius: float = 100.0
var minimum_detection_radius: float = 20.0  # Minimum detection radius
var chase_detection_radius: float = 800.0   # Increased detection radius while chasing
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2

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

# Called when the node enters the scene tree for the first time
func _ready():
	# Find the player in the Player group
	player = get_player_in_group()
	original_color = animated_sprite_2d.modulate  # Save the original color

func _physics_process(delta: float):
	# Update attack cooldown timer
	if attack_timer > 0:
		attack_timer -= delta

	# Update movement timeout timer
	if movement_timeout_timer > 0:
		movement_timeout_timer -= delta
		# While in timeout, play idle animation
		play_animation("idle")
		velocity.x = 0  # Stop movement

	if movement_timeout_timer <= 0:
		# Check if the player is within detection range and not a ghost
		if player and is_player_in_range() and not player.is_in_group("GhostGroup"):
			is_chasing_player = true
		else:
			# Set to false if player is out of the chase detection range
			is_chasing_player = is_chasing_player and is_player_in_chase_range()

		if is_chasing_player:
			if is_player_in_attack_animation_range() and attack_timer <= 0:
				attack_player()
			else:
				chase_player(delta)
		else:
			# Stay still if not chasing
			velocity.x = 0
			move_and_slide()
			play_animation("idle")  # Play idle animation

	# Gravity effect
	if not is_on_ground:
		velocity.y += gravity * delta  # Apply gravity

	# Check for ground collision
	is_on_ground = is_on_floor()
	if is_on_ground:
		if velocity.y > 0:
			velocity.y = 0  # Reset vertical velocity if on ground

	# Move the enemy and apply the calculated velocity
	move_and_slide()

	# Check for mouse button clicks when the player is very close
	if is_player_very_close():
		if Input.is_action_just_pressed("left_mouse_click"):
			health -= 5  # Decrease health by 5 for left click
			flash_effect()  # Trigger flash effect
		elif Input.is_action_just_pressed("right_mouse_click"):
			health -= 10  # Decrease health by 10 for right click
			flash_effect()  # Trigger flash effect

	# Check if health is 0 or below and play death animation if true
	if health <= 0:
		audio_stream_player_2d_2.play()
		await play_death_animation()  # Play death animation

	# Handle flashing effect
	if is_flashing:
		flash_timer -= delta
		if flash_timer <= 0:
			is_flashing = false
			animated_sprite_2d.modulate = original_color  # Reset color to original
		else:
			# Alternate between original color and red
			if int(flash_timer * 10) % 2 == 0:
				animated_sprite_2d.modulate = Color(1, 0, 0)  # Flash red
			else:
				animated_sprite_2d.modulate = original_color  # Reset to original

# Function to trigger the flash effect
func flash_effect():
	is_flashing = true
	flash_timer = flash_duration  # Reset the flash timer

# Function to check if the player is in the initial detection range
func is_player_in_range() -> bool:
	# Ensure detection radius is above the minimum threshold
	var actual_radius = max(detection_radius, minimum_detection_radius)
	return position.distance_to(player.position) <= actual_radius

# Function to check if the player is in the chase detection range
func is_player_in_chase_range() -> bool:
	return position.distance_to(player.position) <= chase_detection_radius

# Function to check if the player is in the attack animation range
func is_player_in_attack_animation_range() -> bool:
	return position.distance_to(player.position) <= attack_animation_radius

# Function to check if the player is in the damage range
func is_player_in_damage_range() -> bool:
	return position.distance_to(player.position) <= damage_radius

# Function to check if the player is very close to the enemy
func is_player_very_close() -> bool:
	var very_close_distance = 50.0  # Set a distance to consider the player "very close"
	return position.distance_to(player.position) <= very_close_distance

# Function to chase the player
func chase_player(delta: float):
	if is_hitting or is_attacking or movement_timeout_timer > 0:
		# If in hitting, attacking, or timeout state, do not change velocity
		move_and_slide()
		return

	if player.position.x > position.x:
		velocity.x = speed * 1.5  # Move right faster than patrol speed
		animated_sprite_2d.flip_h = false  # Face right
	else:
		velocity.x = -speed * 1.5  # Move left faster than patrol speed
		animated_sprite_2d.flip_h = true  # Face left

	move_and_slide()
	play_animation("run")  # Play running animation

# Function to attack the player
func attack_player():
	if not is_attacking:  # Check if not already attacking
		is_attacking = true  # Set the attack state to true
		velocity.x = 0  # Stop movement during attack
		play_animation("attack")  # Play attack animation
		
		# Wait for attack animation to finish
		await animated_sprite_2d.animation_finished 
		
		# After animation, check if the player is within damage range
		if is_player_in_damage_range():
			player.take_damage(30)  # Apply damage only if player is in damage range

		# Start cooldown timer
		attack_timer = attack_cooldown  
		movement_timeout_timer = movement_timeout  # Start movement timeout after attack

		is_attacking = false  # Reset attack state
		# Go back to idle state after attacking
		if not is_chasing_player:
			play_animation("idle")
		else:
			chase_player(get_process_delta_time())  # Resume chasing if still in chase mode

# Function to play the specified animation
func play_animation(animation_name: String):
	if animated_sprite_2d.animation != animation_name:
		animated_sprite_2d.play(animation_name)

# Function to play the death animation
func play_death_animation():
	velocity = Vector2.ZERO  # Stop any movement
	set_physics_process(false)  # Disable physics updates (stops gravity and movement)
	play_animation("death")  # Play death animation

	# Optionally play the death sound effect
	# audio_stream_player_2d_2.play()  # Uncomment if you want to play death sound

	await animated_sprite_2d.animation_finished  # Wait for death animation to finish

	# After death animation finishes, remove the enemy from the scene
	queue_free()  # Free the enemy node from the scene

# Helper function to find the player in the 'Player' group
func get_player_in_group() -> Node2D:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		return players[0]  # Assuming there's only one player in the group
	return null
