extends Area2D

@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var healheartscript: Area2D = $"."  # Assuming this is the correct node

var players: Node2D = null  # Placeholder for the player node
var soul_in_area: bool = false

# Variables for moving the sprite up and down
var speed: float = 10  # Speed of movement
var amplitude: float = 10.0  # How far it moves up and down
var time_passed: float = 0.0  # Tracks the time

# Function called when a body enters the Area2D
func _on_body_entered(body: Node2D) -> void:
	# Check if the body is in the "GhostGroup" or "Player" group
	if body.is_in_group("GhostGroup"):
		print("Soul has entered the area.")
		soul_in_area = true

	# Get player when the ghost (soul) enters the area
	players = get_player_in_group()

# Function called when a body exits the Area2D
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("GhostGroup"):
		soul_in_area = false
		print("Soul has exited the area.")

# Process function checks for interaction and moves the sprite up and down
func _process(delta: float) -> void:
	# Handle sprite movement (up and down)
	time_passed += delta  # Increment the time with each frame
	var y_offset = sin(time_passed * speed) * amplitude  # Calculate vertical offset
	sprite_2d.position.y += y_offset * delta  # Update sprite position for vertical movement
	
	# Handle interaction logic
	if soul_in_area and Input.is_action_just_pressed("interact_soul"):
		print("Soul interacts with the Area2D!")
		if players != null:
			players.heal(25)  # Ensure the player has a heal() method
		collision_shape_2d.disabled = true
		sprite_2d.visible = false

# Function to get the first player in the "Player" group
func get_player_in_group() -> Node2D:
	var player_list = get_tree().get_nodes_in_group("Player")
	if player_list.size() > 0:
		return player_list[0] as Node2D  # Return the first player in the group
	return null
