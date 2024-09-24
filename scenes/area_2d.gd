extends Area2D

@onready var player: CharacterBody2D = $"../Player"
@onready var transition: Control = $"../Transition" # Fade control (a ColorRect or Control node)
@onready var animation_player: AnimationPlayer = $"../Transition/AnimationPlayer" # Animation player for fade animations

var next_level_scene = "res://scenes/level_1TEST.tscn"

func _ready():
	# Connect the body_entered signal to the function
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	# Ensure the transition control is hidden initially
	transition.visible = false

func _on_body_entered(body):
	# Check if the body is the player instance
	if body == player:
		# Start fade out (to black), then transition to the next level
		start_fade_out()

func start_fade_out():
	# Make the transition control visible for the fade
	transition.visible = true
	
	# Play the fade-out animation (fade to black)
	animation_player.play("fade_out")
	
	# Connect to animation_finished and handle transition when animation is done
	animation_player.connect("animation_finished", Callable(self, "on_fade_out_complete").bind())

func on_fade_out_complete(animation_name: String) -> void:
	# After fade-out completes, transition to the next level
	transition_to_next_level()

func transition_to_next_level():
	# Load the next level
	var error = get_tree().change_scene_to_file(next_level_scene)
	if error != OK:
		print("Error loading the next level: ", error)

# Fade in handling in the next scene (for the next level):
