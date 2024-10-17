extends CharacterBody2D

const SPEED = 80.0
const JUMP_VELOCITY = -400.0
const OFFSET_Y = -50  # Adjust this value to position the Soul above the Knight's head
const CIRCLE_RADIUS = 125  # Adjust the radius for the movement constraint

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $".."

var is_playable: bool = false  # Variable to track if the character is playable
var is_exiting: bool = false  # Variable to track if the character is exiting
var waiting_for_idle: bool = false  # Variable to track if we should play "idle" after "enter"
var reset_position: Vector2  # Variable to store the reset position

# Circle constraint variables
var circle_center: Vector2  # Will store the initial spawn position
var circle_radius: float = CIRCLE_RADIUS  # Radius for movement limitation
var at_boundary: bool = false  # Track if the character is at the boundary

# Variable to track the facing direction (-1 for left, 1 for right)
var facing_direction: int = 1

func _ready() -> void:
	# Set visibility to false at the start
	animated_sprite_2d.visible = false
	print("Soul character ready and visibility set to false.")

	# Set collision layer and mask
	set_collision_layer(3)  # Set to Layer 3
	set_collision_mask(0)    # No collisions with other layers

	# Simulate pressing Q at the start to make the character playable
	_toggle_control()

func _toggle_control() -> void:
	if is_playable:
		# If currently playable, play exit animation
		is_playable = false
		is_exiting = true
		waiting_for_idle = false
		animated_sprite_2d.play("exit")
		print("Playing exit animation.")
	else:
		# If currently not playable, update reset position and play enter animation
		is_playable = true
		is_exiting = false
		waiting_for_idle = true
		reset_position = player.global_position + Vector2(0, OFFSET_Y)  # Update reset position based on Knight's position
		animated_sprite_2d.play("enter")
		animated_sprite_2d.visible = true  # Show character when entering
		print("Playing enter animation and character is now visible. Reset position updated to: ", reset_position)

		# Set the circle center to the current position when becoming playable
		circle_center = global_position
		print("Circle center set to: ", circle_center)

func _process(delta: float) -> void:
	# Check for control toggle input
	if Input.is_action_just_pressed("ui_toggle_control"):  # Custom action for Q
		_toggle_control()

	# Check if we need to reset the position when exiting
	if is_exiting and not animated_sprite_2d.is_playing():
		# If the exit animation is done, hide the character and reset its position to the stored reset position
		animated_sprite_2d.visible = false
		global_position = reset_position  # Use global_position to reset position
		is_exiting = false
		print("Exit animation finished, hiding character and resetting position.")

func _physics_process(delta: float) -> void:
	if not is_playable:
		return  # Do not allow movement if the character is not playable

	# Handle movement when the character is playable
	var direction := Input.get_axis("soul_left", "soul_right")
	if direction != 0:
		velocity.x = direction * SPEED

		# Flip the sprite based on the direction (-1 for left, 1 for right)
		if direction < 0:
			facing_direction = -1
		elif direction > 0:
			facing_direction = 1

		# Apply the flip to the sprite
		animated_sprite_2d.flip_h = facing_direction == -1  # Flip if moving left
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Allow floating in the vertical direction (up/down)
	var vertical_direction := Input.get_axis("soul_up", "soul_down")
	velocity.y = vertical_direction * SPEED

	# Calculate the new position after movement
	var new_position = global_position + velocity * delta

	# Check if the new position is within the circular constraint
	if new_position.distance_to(circle_center) <= circle_radius:
		# Move freely within the circle
		global_position = new_position
		at_boundary = false  # Not at the boundary
	else:
		# Restrict movement to the circle boundary
		var direction_to_center = (new_position - circle_center).normalized()
		global_position = circle_center + direction_to_center * circle_radius
		print("Restricted movement to the edge of the circle.")
		at_boundary = true  # At the boundary

	# Apply the movement
	move_and_slide()

	# Play the correct animation based on movement only if not exiting
	if is_playable and not is_exiting:
		if at_boundary:
			# Play the cantReach animation if the character is at the boundary
			if animated_sprite_2d.animation != "cantReach":
				animated_sprite_2d.play("cantReach")
				print("Playing cantReach animation.")
		elif velocity.length() > 0:
			# Play the float animation when moving within the circle
			animated_sprite_2d.play("float")
		else:
			if waiting_for_idle:
				# Wait for the "enter" animation to finish before playing "idle"
				if not animated_sprite_2d.is_playing():
					animated_sprite_2d.play("idle")
					waiting_for_idle = false
					print("Playing idle animation.")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_soul") and is_playable:
		print("Pressing 'E' to interact!")
