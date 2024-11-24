extends Node2D

@onready var transition: Control = $"Transition"
@onready var animation_player: AnimationPlayer = $"Transition/AnimationPlayer"


func _ready():
	if animation_player:
		animation_player.play("fade_in")
	else:
		print("Error: AnimationPlayer is null!")

#hellos
