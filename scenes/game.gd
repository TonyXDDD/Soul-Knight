extends Node2D

@onready var transition: Control = $"Transition2"
@onready var animation_player: AnimationPlayer = $"Transition2/AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready():
	if animation_player:
		animation_player.play("fade_in")
	else:
		print("Error: AnimationPlayer is null!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
