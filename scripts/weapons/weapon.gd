class_name Weapon
extends Node3D

const DEFAULT_WEAPON_COOLDOWN_S := 0.2

func fire() -> void:
	assert(false, "Fire function must be overriden by subclass!")

func get_weapon_cooldown_s() -> float:
	return DEFAULT_WEAPON_COOLDOWN_S
