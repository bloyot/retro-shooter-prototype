class_name HUD extends Node

@onready var game: Game = get_parent()
@onready var health_value: RichTextLabel = %HealthValue	

func _process(delta: float) -> void:
	health_value.text = str(game.player.curr_health)
