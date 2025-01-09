extends Node3D

@onready var machine_gun := $MachineGun
@onready var rocket := $Rocket
@onready var sniper := $Sniper

@export var projectile_origin: Marker3D
@export var weapons: Array[Weapon]
var active_weapon_index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:		
	assert(projectile_origin != null, "Projectile Origin Not set for weapon manager!")
	for weapon in weapons:
		weapon.visible = false
		if weapon is ProjectileWeapon:
			weapon.projectile_origin = projectile_origin
	swap_weapon(active_weapon_index)

func swap_weapon(weapon_index: int) -> void:		
	for i in range(0, weapons.size()):
		weapons[i].visible = true if i == weapon_index else false		
	active_weapon_index = weapon_index
					
func next_weapon() -> void:
	swap_weapon((active_weapon_index + 1) % weapons.size())

func prev_weapon() -> void:
	swap_weapon((active_weapon_index - 1) % weapons.size())
		
func get_active_weapon() -> Weapon:
	return weapons[active_weapon_index]
