class_name Enemy extends CharacterBody3D

@export var enemy_resource: EnemyResource
@export var is_patrol: bool
@export var patrol_marker: Marker3D

@onready var player: Player = get_tree().get_first_node_in_group("game").player
@onready var sprite: AnimatedSprite2D = %EnemySprite
@onready var damage_flash_timer: Timer = %DamageFlashTimer
@onready var flash_shader: ShaderMaterial = sprite.material
@onready var shoot_cooldown_timer: Timer = %ShootCooldownTimer

var start_point: Vector3
var target_position: Vector3

var active_direction: String = "s"
var active_anim_name: String = "idle"
var curr_health: float

func _ready() -> void:
	# set variables
	curr_health = enemy_resource.health
	
	# connect signals
	sprite.animation_finished.connect(on_animation_finished)
	damage_flash_timer.timeout.connect(on_damage_flash_timeout)
	
	# initialize patrol settings
	start_point = global_position
	target_position = start_point
	if is_patrol and patrol_marker != null:
		active_anim_name = "walk"
		look_at(patrol_marker.global_position, Vector3.UP, true)
		
	# initiate our behavior and add it to the scene
	add_child(enemy_resource.behavior.instantiate())

func _process(delta: float) -> void:		
	if !target_position.is_equal_approx(global_position) and active_anim_name != "die":
		if active_anim_name != "walk":
			change_animation("walk")
		rotate_towards(target_position)
		velocity = (target_position - global_position).normalized() * enemy_resource.move_speed
	set_facing()
	move_and_slide()
		
func set_facing() -> void:
	# forward vector for the enemy
	var enemy_facing = Vector2(global_basis.z.x, global_basis.z.z)
	
	# vector from enemy to player
	var player_vec = (player.global_position - global_position)
	var player_vec_2d = Vector2(player_vec.x, player_vec.z)
	var angle = rad_to_deg(enemy_facing.angle_to(player_vec_2d))
	var direction = angle_to_direction(angle)	
	if active_direction != direction:
		active_direction = direction
		change_animation(active_anim_name, true)
		
func rotate_towards(pos: Vector3) -> void:
	var direction = (pos - global_position).normalized()
	var angle = atan2(direction.x, direction.z)
	global_rotation.y = lerp_angle(global_rotation.y, angle, .05)		
	
# return true if facing towards the position (within 22.5 degress on either side
func is_facing_player() -> bool:	
	return active_direction == "s"

func angle_to_direction(angle: float) -> String:
	if angle > -22.5 and angle < 22.5:
		return "s"
	elif angle > 22.5 and angle < 67.5:
		return "se"
	elif angle > 67.5 and angle < 112.5:
		return "e"
	elif angle > 112.5 and angle < 157.5:
		return "ne"
	elif angle > 157.5 or angle < -157.5:
		return "n"
	elif angle > -157.5 and angle < -112.5:
		return "nw"
	elif angle > -112.5 and angle < -67.5:
		return "w"
	elif angle > -67.5 and angle < -22.5: 
		return "sw"	
	else:
		return "bad!!"
	
func on_hit(weapon_resource: WeaponResource) -> void:
	damage_flash()
	curr_health -= weapon_resource.damage
	if curr_health <= 0 and !active_anim_name.begins_with("die"):
		die()

func on_animation_finished() -> void:
	if active_anim_name == "die":
		queue_free()

func change_animation(anim_name: String, maintain_progress: bool = false) -> void:
	var curr_frame = sprite.frame
	var curr_progress = sprite.frame_progress
	sprite.play(anim_name + "_" + active_direction)
	
	# when changing viewed direction, maintain the current frame and progress of the animation,
	# otherwise the animation resets
	if maintain_progress:
		sprite.set_frame_and_progress(curr_frame, curr_progress)	
		
func damage_flash() -> void:
	if damage_flash_timer.is_stopped() and active_anim_name != "die":
		damage_flash_timer.start()		
		flash_shader.set_shader_parameter("active", true)		
		
func on_damage_flash_timeout() -> void:
	flash_shader.set_shader_parameter("active", false)		
	
func die() -> void:
	active_anim_name = "die"		
	change_animation("die")
	is_patrol = false
	EventManager.publish(GlobalUtils.EventType.ENEMY_DEATH, [])

func shoot(target_position: Vector3) -> void: 			
	var projectile = Projectile.new_projectile(
		enemy_resource.projectile_scene, 
		global_position + global_basis.z,
		target_position, 
		enemy_resource.projectile_speed,
		get_tree().current_scene,
		5
	)		
	shoot_cooldown_timer.start()	

func can_shoot() -> bool: 
	return shoot_cooldown_timer.is_stopped()
