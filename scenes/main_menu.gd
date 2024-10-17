class_name MainMenu
extends Control
#repo try
@onready var start_b: Button = $MarginContainer/HBoxContainer/VBoxContainer/StartB as Button
@onready var quit_b: Button = $MarginContainer/HBoxContainer/VBoxContainer/QuitB as Button
@onready var tutrl: Button = $MarginContainer/HBoxContainer/VBoxContainer/tutrl as Button
@onready var start_level = preload("res://scenes/game.tscn") as PackedScene
@onready var start_levelT = preload("res://scenes/tutorial_level.tscn") as PackedScene
@onready var transition: Control = $"Transition"
@onready var animation_player: AnimationPlayer = $"Transition/AnimationPlayer"

func _ready():
	start_b.button_down.connect(on_start_pressed)
	quit_b.button_down.connect(on_exit_pressed)
	tutrl.button_down.connect(on_tutrl_pressed)
	animation_player.play("fade_in")

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_tutrl_pressed() -> void:
	get_tree().change_scene_to_packed(start_levelT)

func on_exit_pressed() -> void:
	get_tree().quit()
