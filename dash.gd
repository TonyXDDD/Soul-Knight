extends Node2D

@onready var duration_timer: Timer = $DurationTimer

const dash_delay = 0.4
var can_dash = true

func start_dash(duration):
	duration_timer.wait_time = duration
	duration_timer.start()
	
func is_dashing():
	return !duration_timer.is_stopped()

func end_dash() -> void:
	can_dash = false
	await get_tree().create_timer(dash_delay).timeout
	can_dash = true


func _on_duration_timer_timeout() -> void:
	end_dash()
