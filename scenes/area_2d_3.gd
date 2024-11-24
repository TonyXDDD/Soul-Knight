extends Area2D

@onready var player: CharacterBody2D = $"../Player"

var damage_amount = 1000  # Damage amount to the player

func _ready():
	# Connect the body_entered signal to the function
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	# Check if the body is the player instance
	if body == player:
		# Apply 1000 damage to the player when entering the trigger
		apply_damage_to_player()

func apply_damage_to_player():
	# Apply damage to the player if the method exists
	if player.has_method("take_damage"):
		player.take_damage(damage_amount)
	else:
		print("Warning: 'take_damage' method not found in the Player script")
