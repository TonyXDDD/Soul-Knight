extends Area2D

# Access the path to the camera using the global group: cameraKnightG
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var collision_shape_2_dbody: CollisionShape2D = $"../CollisionShape2Dbody"
@onready var camera_knight: Camera2D = get_tree().get_nodes_in_group("cameraKnightG")[0]
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var player_in_area = false
var healthcheckerNUM = 50
var soul_active: bool = true  # To track whether Soulmode is active
var rumble_timer: float = 0.0
var rumble_intensity: float = 1.0
var rumble_duration: float = 0.2  # Duration of the rumble effect

var death_animation_timer: float = 0.0  # Timer for the death animation visibility
var is_visible_after_death: bool = false  # Flag to track visibility state

# Method to check if Soulmode is activated or deactivated
func SoulmodeChecker() -> void:
	if Input.is_action_just_pressed("ui_toggle_control"):  # Toggle Soulmode with "Q"
		soul_active = not soul_active
		if soul_active:
			print("Soulmode activated!")
		else:
			print("Soulmode deactivated!")

# Called when the player enters the hitbox
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player entered hitchecker box")
		player_in_area = true
		print(healthcheckerNUM)

# Called when the player exits the hitbox
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player left hitchecker box")
		player_in_area = false

# Main process function, where the health checker logic is handled
func _process(delta: float) -> void:
	SoulmodeChecker()  # Continuously check if Soulmode is toggled

	# Handle camera rumble effect
	if rumble_timer > 0:
		apply_camera_rumble(delta)

	# Check if the visibility after death needs to be processed
	if is_visible_after_death:
		death_animation_timer -= delta  # Decrease the timer by the delta time
		if death_animation_timer <= 0:
			animated_sprite_2d.visible = false  # Hide the sprite after the timer ends
			is_visible_after_death = false  # Reset the flag

	if healthcheckerNUM > 0 and not soul_active:  # Only allow damage if Soulmode is not active
		if player_in_area and Input.is_action_just_pressed("left_mouse_click"):
			print("Player attack1")
			healthcheckerNUM -= 5
			#animated_sprite_2d.play("hit")
			print(healthcheckerNUM)
			start_camera_rumble()

			if healthcheckerNUM <= 0:
				handle_death()

		elif player_in_area and Input.is_action_just_pressed("right_mouse_click"):
			print("Player attack2")
			healthcheckerNUM -= 10
			#animated_sprite_2d.play("hit")
			print(healthcheckerNUM)
			start_camera_rumble()

			if healthcheckerNUM <= 0:
				handle_death()

# Function to handle the death logic
func handle_death() -> void:
	healthcheckerNUM = 0  # Ensure health cannot go below 0
	print("NO MORE HP")
	audio_stream_player_2d.play()
	#animated_sprite_2d.play("death")
	collision_shape_2d.disabled = true  # Disable collision if no more health
	animated_sprite_2d.visible = true  # Make sprite visible for death animation
	collision_shape_2_dbody.disabled = true
	
	death_animation_timer = 3.0  # Set the timer for 3 seconds
	is_visible_after_death = true  # Set the flag to indicate visibility

# Start the camera rumble effect
func start_camera_rumble() -> void:
	rumble_timer = rumble_duration

# Apply the camera rumble effect
func apply_camera_rumble(delta: float) -> void:
	if camera_knight:
		rumble_timer -= delta
		# Generate random offsets for camera shake
		var offset_x = randf_range(-rumble_intensity, rumble_intensity)
		var offset_y = randf_range(-rumble_intensity, rumble_intensity)
		camera_knight.offset = Vector2(offset_x, offset_y)

		if rumble_timer <= 0:
			camera_knight.offset = Vector2(0, 0)  # Reset camera position after shaking
