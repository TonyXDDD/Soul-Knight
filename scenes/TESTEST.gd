extends Area2D

@onready var player: CharacterBody2D = $"../Player"

@onready var soul: CharacterBody2D = $"../Player/Soul"

var soul_in_area: bool = false

# Function called when a body enters the Area2D
func _on_body_entered(body: Node2D) -> void:
	if body == soul:
		print("Soul has entered the area.")
		soul_in_area = true
		



func _process(delta: float) -> void:
	if soul_in_area and Input.is_action_just_pressed("interact_soul"):
		print("Soul interacts with the Area2D!")


func _on_body_exited(body: Node2D) -> void:
	if body == soul:
		soul_in_area = false
		print("Soul has exited the area.")
