extends Area2D

@onready var soul: CharacterBody2D = $"../Player/Soul"
@onready var PuzzleDoor1: AnimatedSprite2D = $"../PuzzleDoor2"
@onready var static_body_2d: StaticBody2D = $"../PuzzleDoor2/StaticBody2D"
@onready var collision_shape_2d: CollisionShape2D = $"../PuzzleDoor2/StaticBody2D/CollisionShape2D"
@onready var button_sound: AudioStreamPlayer2D = $"../buttonSOUND"

var soul_in_area: bool = false

# Function called when a body enters the Area2D
func _on_body_entered(body: Node2D) -> void:
	if body == soul:
		print("Soul has entered the area.")
		soul_in_area = true

# Function called when a body exits the Area2D
func _on_body_exited(body: Node2D) -> void:
	if body == soul:
		soul_in_area = false
		print("Soul has exited the area.")

# Process function checks for interaction
func _process(delta: float) -> void:
	if soul_in_area and Input.is_action_just_pressed("interact_soul"):
		print("Soul interacts with the Area2D!")
		button_sound.play()
		# Play the door animation
		PuzzleDoor1.play("notdef")
		# Hide the static body and disable the collision shape
		static_body_2d.visible = false
		collision_shape_2d.disabled = true
