extends CanvasLayer

@onready var pause_menu: Control = $Pause_menu  # Reference to the pause menu
var paused = false  # Track whether the game is paused

# Automatically hide the pause menu when the scene is loaded
func _ready() -> void:
	pause_menu.hide()  # Hide the pause menu initially

func _process(delta):
	# Check if the pause action is pressed
	if Input.is_action_just_pressed("pause_menu"):
		pauseMenu()  # Call the function to toggle the pause menu

func pauseMenu():
	if paused:
		pause_menu.hide()  # Hide the pause menu
		Engine.time_scale = 1  # Resume game time
	else:
		pause_menu.show()  # Show the pause menu
		Engine.time_scale = 0  # Pause game time
	
	paused = !paused  # Toggle the paused state
