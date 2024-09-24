extends AudioStreamPlayer2D

# This function is called when the node enters the scene tree for the first time.
func _ready():
	# Ensure the audio is set to loop
	stream.set_loop(true)
	# Play the audio
	play()
