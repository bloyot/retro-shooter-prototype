class_name Weapon
extends Node3D

const hit_decal: PackedScene = preload("res://scenes/weapons/hit_decal.tscn")
const ray_range = 2000

@export var weapon_resource: WeaponResource

var projectile_origin: Marker3D

func init(_projectile_origin: Marker3D) -> void:
	self.projectile_origin = _projectile_origin	

func fire() -> void:
	var raycast_result := camera_raycast()
	if weapon_resource.type == "Hitscan":
		raycast_fire(raycast_result)
	elif weapon_resource.type == "Projectile":
		projectile_fire(raycast_result)

func get_weapon_cooldown_s() -> float:
	return weapon_resource.cooldown_s

func raycast_fire(raycast_result: Array) -> void:
	var collider = raycast_result[0]
	if collider != null:		
		spawn_decal(raycast_result[1], raycast_result[2])

func projectile_fire(raycast_result: Array) -> void:	
	Projectile.new_projectile(
		weapon_resource.projectile_scene, 
		projectile_origin.global_position,
		raycast_result[1], 
		weapon_resource.projectile_speed,
		get_tree().current_scene,
		weapon_resource.projectile_duration_s
	)	

# returns the collision dictionary from the ray intersection starting from the camera
func camera_raycast() -> Array:
	var center = get_viewport().get_size() / 2
	var ray_origin = get_viewport().get_camera_3d().project_ray_origin(center)
	var ray_end = ray_origin + get_viewport().get_camera_3d().project_ray_normal(center) * ray_range
	
	var raycast_params = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	raycast_params.collide_with_areas = true
	var intersection = get_world_3d().direct_space_state.intersect_ray(raycast_params)
	if not intersection.is_empty():
		return [intersection.collider, intersection.position, intersection.normal]
	else:
		return [null, ray_end, null]
		
func spawn_decal(position: Vector3, normal: Vector3) -> void:
	var decal = hit_decal.instantiate()
	get_tree().get_root().add_child(decal)
	decal.global_translate(position+(normal*.01))
