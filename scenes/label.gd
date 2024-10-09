extends Label

var move_speed = 2.0  # Speed of the movement
var move_range = 10.0  # How far up and down the label moves
var initial_position = Vector2.ZERO  # Store the initial position
var y_offset = 100.0  # Offset to make the label start a bit lower

func _ready() -> void:
	initial_position = position + Vector2(0, y_offset)  # Save the starting position with an offset

func _process(delta: float) -> void:
	# Create a smooth up and down movement using sine wave
	position.y = initial_position.y + sin(Time.get_ticks_msec() / 1000.0 * move_speed) * move_range
