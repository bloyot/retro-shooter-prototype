class_name WeaponResource extends Resource

@export_enum("Projectile", "Hitscan") var type: String = "Hitscan"
@export var cooldown_s: float
@export var range: float
@export var damage: float

@export_category("Projectile")
@export_group("Projectile")
@export var projectile_speed: float
@export var projectile_scene: PackedScene
@export var projectile_duration_s: float
