extends Node2D

@onready var transition: Control = $"Transition"
@onready var animation_player: AnimationPlayer = $"Transition/AnimationPlayer"
#@onready var damage_timer: Timer = $DamageTimer  # Reference to the Timer node

# Damage-related variables
@export var player_damage_amount: int = 7  # Amount of damage to apply every 3 seconds
var player: Node2D  # Reference to the player node

# Manual timer variables
var damage_interval: float = 3.0  # Interval in seconds for damaging the player
var time_since_last_damage: float = 0.0  # Tracks time since last damage

func _ready():
	if animation_player:
		animation_player.play("fade_in")
	else:
		print("Error: AnimationPlayer is null!")
	
	# Initialize the player reference
	player = get_player_in_group()

func _process(delta: float) -> void:
	# Update the timer for damaging the player
	time_since_last_damage += delta
	if time_since_last_damage >= damage_interval:
		damage_player()
		time_since_last_damage = 0.0  # Reset the timer

# Function to apply damage to the player
func damage_player():
	if player:
		player.take_damage(player_damage_amount)  # Apply damage to the player
	else:
		print("Error: Player not found!")

# Function to find the player in the scene by checking a specific group
func get_player_in_group() -> Node2D:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		return players[0] as Node2D
	return null
