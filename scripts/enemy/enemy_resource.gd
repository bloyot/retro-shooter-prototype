class_name EnemyResource extends Resource

enum TYPE { MELEE, RANGED, BOSS }

@export var health: float
@export var move_speed: float
# how much damage to take if you run into the enemy
@export var melee_damage: float
# if the player is within this range, aggro
@export var aggro_range: float
@export var type: TYPE = TYPE.MELEE
@export var behavior: PackedScene

@export_category("Ranged Attributes")
@export var shooting_range: float
@export var projectile_speed: float
@export var projectile_scene: PackedScene
