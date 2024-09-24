extends CharacterBody2D

const SPEED = 180.0
const JUMP_VELOCITY = -400.0
const OFFSET_Y = -50  # Adjust this value to position the Soul above the Knight's head

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $".."


var is_playable: bool = false  # Variable to track if the character is playable
var is_exiting: bool = false  # Variable to track if the character is exiting
var waiting_for_idle: bool = false  # Variable to track if we should play "idle" after "enter"
var reset_position: Vector2  # Variable to store the reset position

func _ready() -> void:
	# Set visibility to false at the start
	animated_sprite_2d.visible = false
	print("Soul character ready and visibility set to false.")

func _process(delta: float) -> void:
	# Toggle control when Q is pressed
	if Input.is_action_just_pressed("ui_toggle_control"):  # Custom action for Q
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
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Allow floating in the vertical direction (up/down)
	var vertical_direction := Input.get_axis("soul_up", "soul_down")
	velocity.y = vertical_direction * SPEED

	move_and_slide()

	# Play the correct animation based on movement only if not exiting
	if is_playable and not is_exiting:
		if velocity.length() > 0:
			animated_sprite_2d.play("float")
		else:
			if waiting_for_idle:
				# Wait for the "enter" animation to finish before playing "idle"
				if not animated_sprite_2d.is_playing():
					animated_sprite_2d.play("idle")
					waiting_for_idle = false
					print("Playing idle animation.")
