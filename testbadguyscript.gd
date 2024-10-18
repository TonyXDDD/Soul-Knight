extends Area2D

#@onready var player: CharacterBody2D = $"../Player"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var collision_shape_2_dbody: CollisionShape2D = $"../CollisionShape2Dbody"

var player_in_area = false
var healthcheckerNUM = 100
var soul_active: bool = true  # To track whether Soulmode is active

# Method to check if Soulmode is activated or deactivated
func SoulmodeChecker() -> void:
	if Input.is_action_just_pressed("ui_toggle_control"):  # Toggle Soulmode with "Q"
		soul_active = not soul_active
		if soul_active:
			print("Soulmode activated!")
		else:
			print("Soulmode deactivated!")

# Called when the player enters the hitbox
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player entered hitchecker box")
		player_in_area = true
		print(healthcheckerNUM)
		



# Called when the player exits the hitbox
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player left hitchecker box")
		player_in_area = false
		healthcheckerNUM = 100  # Reset health when player exits

# Main process function, where the health checker logic is handled
func _process(delta: float) -> void:
	SoulmodeChecker()  # Continuously check if Soulmode is toggled

	if healthcheckerNUM > 0 and not soul_active:  # Only allow damage if Soulmode is not active
		if player_in_area and Input.is_action_just_pressed("left_mouse_click"):
			print("Player attack1")
			healthcheckerNUM -= 5
			print(healthcheckerNUM)
		
			if healthcheckerNUM <= 0:
				healthcheckerNUM = 0  # Ensure health cannot go below 0
				print("NO MORE HP")
				collision_shape_2d.disabled = true  # Disable collision if no more health
				animated_sprite_2d.visible = false
				collision_shape_2_dbody.disabled = true
		
		elif player_in_area and Input.is_action_just_pressed("right_mouse_click"):
			print("Player attack2")
			healthcheckerNUM -= 10
			print(healthcheckerNUM)
		
			if healthcheckerNUM <= 0:
				healthcheckerNUM = 0  # Ensure health cannot go below 0
				print("NO MORE HP")
				collision_shape_2d.disabled = true  # Disable collision if no more health
				animated_sprite_2d.visible = false
				collision_shape_2_dbody.disabled = true
