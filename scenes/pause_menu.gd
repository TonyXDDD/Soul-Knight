extends Control

# Preload the main menu scene
@onready var main_menu_scene = "res://scenes/main_menu.tscn"  # Use string path directly for change_scene_to_file()

# Button variables
@onready var continue_button: Button = $MarginContainer/VBoxContainer/continue_button
@onready var main_menu_button: Button = $MarginContainer/VBoxContainer/main_menu_button
@onready var quit_button: Button = $MarginContainer/VBoxContainer/quit_button

# Reference to the CanvasLayer for managing pause
@onready var canvas_layer: CanvasLayer = get_parent() as CanvasLayer

# Called when the 'Continue' button is pressed
func _on_continue_button_pressed() -> void:
	# Resume game and hide pause menu
	Engine.time_scale = 1  # Resume the game time manually
	self.hide()  # Hide the pause menu
	print("Continue button works")  # Debug message

# Called when the 'Main Menu' button is pressed
func _on_main_menu_button_pressed() -> void:
	# Unpause the game and load the main menu scene
	Engine.time_scale = 1  # Ensure the game is unpaused
	get_tree().change_scene_to_file(main_menu_scene)  # Load the main menu scene using string path
	print("Main menu button works")  # Debug message

# Called when the 'Quit' button is pressed
func _on_quit_button_pressed() -> void:
	# Quit the game
	get_tree().quit()
	print("Quit button works")  # Debug message
