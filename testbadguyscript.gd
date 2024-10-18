extends Area2D

# Access the path to the camera using the global group: cameraKnightG
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var collision_shape_2_dbody: CollisionShape2D = $"../CollisionShape2Dbody"
@onready var camera_knight: Camera2D = get_tree().get_nodes_in_group("cameraKnightG")[0]
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


var player_in_area = false
var healthcheckerNUM = 100
var soul_active: bool = true  # To track whether Soulmode is active
var rumble_timer: float = 0.0
var rumble_intensity: float = 1.0
var rumble_duration: float = 0.2  # Duration of the rumble effect

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
		healthcheckerNUM = 100  # Reset health when player exits

# Main process function, where the health checker logic is handled
func _process(delta: float) -> void:
	SoulmodeChecker()  # Continuously check if Soulmode is toggled

	# Handle camera rumble effect
	if rumble_timer > 0:
		apply_camera_rumble(delta)
	
	if healthcheckerNUM > 0 and not soul_active:  # Only allow damage if Soulmode is not active
		if player_in_area and Input.is_action_just_pressed("left_mouse_click"):
			print("Player attack1")
			healthcheckerNUM -= 5
			print(healthcheckerNUM)
			start_camera_rumble()
		
			if healthcheckerNUM <= 0:
				healthcheckerNUM = 0  # Ensure health cannot go below 0
				print("NO MORE HP")
				audio_stream_player_2d.play()
				collision_shape_2d.disabled = true  # Disable collision if no more health
				animated_sprite_2d.visible = false
				collision_shape_2_dbody.disabled = true
		
		elif player_in_area and Input.is_action_just_pressed("right_mouse_click"):
			print("Player attack2")
			healthcheckerNUM -= 10
			print(healthcheckerNUM)
			start_camera_rumble()
		
			if healthcheckerNUM <= 0:
				healthcheckerNUM = 0  # Ensure health cannot go below 0
				print("NO MORE HP")
				audio_stream_player_2d.play()
				collision_shape_2d.disabled = true  # Disable collision if no more health
				animated_sprite_2d.visible = false
				collision_shape_2_dbody.disabled = true

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
