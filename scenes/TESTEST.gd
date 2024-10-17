extends Area2D

@onready var player: CharacterBody2D = $"../Player"
@onready var soul: CharacterBody2D = $"../Player/Soul"
@onready var testdoor: AnimatedSprite2D = $"../TESTDOOR"
@onready var static_body_2d: StaticBody2D = $"../TESTDOOR/StaticBody2D"
@onready var collision_shape_2d: CollisionShape2D = $"../TESTDOOR/StaticBody2D/CollisionShape2D"

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
		# Play the door animation
		testdoor.play("notdef")
		# Hide the static body and disable the collision shape
		static_body_2d.visible = false
		collision_shape_2d.disabled = true
