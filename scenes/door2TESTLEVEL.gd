extends Area2D

@onready var soul: CharacterBody2D = $"../Player/Soul"
@onready var testdoor: AnimatedSprite2D = $"../TESTDOOR2"
@onready var static_body_2d: StaticBody2D = $"../TESTDOOR2/StaticBody2D"
@onready var collision_shape_2d: CollisionShape2D = $"../TESTDOOR2/StaticBody2D/CollisionShape2D"

var soul_in_area2: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body == soul:
		print("Soul has entered the area.")
		soul_in_area2 = true



func _on_body_exited(body: Node2D) -> void:
	if body == soul:
		soul_in_area2 = false
		print("Soul has exited the area.")

func _process(delta: float) -> void:
	if soul_in_area2 and Input.is_action_just_pressed("interact_soul"):
		print("Soul interacts with the Area2Ddoor2!")
		# Play the door animation
		testdoor.play("notdef")
		# Hide the static body and disable the collision shape
		static_body_2d.visible = false
		collision_shape_2d.disabled = true
		start_countdown_and_show_collision_shape()

func start_countdown_and_show_collision_shape():
	print("Starting countdown...")
	await get_tree().create_timer(10.0).timeout  # Wait for 15 seconds
	print("Countdown finished. Making collision shape visible.")
	static_body_2d.visible = true  # Set the collision shape visible after 15 seconds
	collision_shape_2d.disabled = false
	testdoor.play("close")
	
