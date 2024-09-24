class_name MainMenu
extends Control

@onready var start_b: Button = $MarginContainer/HBoxContainer/VBoxContainer/StartB as Button
@onready var quit_b: Button = $MarginContainer/HBoxContainer/VBoxContainer/QuitB as Button
@onready var start_level = preload("res://scenes/game.tscn") as PackedScene

func _ready():
	start_b.button_down.connect(on_start_pressed)
	quit_b.button_down.connect(on_exit_pressed)


func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_exit_pressed() -> void:
	get_tree().quit()
