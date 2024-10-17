extends Area2D

@onready var player: CharacterBody2D = $"../Player"
@onready var soul: CharacterBody2D = $"../Player/Soul"
@onready var testdoor: AnimatedSprite2D = $"../TESTDOOR3"
@onready var static_body_2d: StaticBody2D = $"../TESTDOOR3/StaticBody2D"
@onready var collision_shape_2d: CollisionShape2D = $"../TESTDOOR3/StaticBody2D/CollisionShape2D"
@onready var key: Sprite2D = $"../key"

var soul_in_areaKEY: bool = false



func _on_body_entered(body: Node2D) -> void:
	if body == soul:
		print("Soul has entered the areaKEY.")
		soul_in_areaKEY = true





func _on_body_exited(body: Node2D) -> void:
	if body == soul:
		soul_in_areaKEY = false
		print("Soul has exited the areaKEY.")
		

func _process(delta: float) -> void:
	if soul_in_areaKEY and key.visible == false and Input.is_action_just_pressed("interact_soul"):
		print("Soul interacts with the Area2D!")
		# Play the door animation
		testdoor.play("notdef")
		# Hide the static body and disable the collision shape
		static_body_2d.visible = false
		collision_shape_2d.disabled = true
