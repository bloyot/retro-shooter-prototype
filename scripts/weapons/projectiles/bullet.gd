class_name Bullet
extends Projectile

const bullet_scene: PackedScene = preload("res://scenes/weapons/projectiles/bullet.tscn")

static func new_bullet() -> Bullet:
	var bullet: Bullet = bullet_scene.instantiate()	
	return bullet
