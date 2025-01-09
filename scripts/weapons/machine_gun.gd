extends ProjectileWeapon

func fire() -> void:
	var bullet := Bullet.new_bullet()	
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = projectile_origin.global_position
	bullet.global_rotation = projectile_origin.global_rotation
