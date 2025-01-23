class_name Enemy extends Sprite3D

@export var enemy_resource: EnemyResource
@export var is_patrol: bool
@export var patrol_marker: Marker3D

@onready var player: Player = get_tree().get_first_node_in_group("game").player
@onready var sprite: AnimatedSprite2D = %EnemySprite
@onready var damage_flash_timer: Timer = %DamageFlashTimer
@onready var flash_shader: ShaderMaterial = sprite.material

var start_point: Vector3
var move_towards_patrol: bool = true
var speed = 3

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
	if is_patrol and patrol_marker != null:
		active_anim_name = "walk"
		look_at(patrol_marker.global_position, Vector3.UP, true)

func _process(delta: float) -> void:		
	if is_patrol and patrol_marker != null:
		if move_towards_patrol: 
			position = position.move_toward(patrol_marker.global_position, speed * delta)								
			if global_position.is_equal_approx(patrol_marker.global_position):
				move_towards_patrol = false
				look_at(start_point, Vector3.UP, true)
		else:
			position = position.move_toward(start_point, speed * delta)
			if position.is_equal_approx(start_point):
				move_towards_patrol = true
				look_at(patrol_marker.global_position, Vector3.UP, true)
		
	set_facing()
		
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
		active_anim_name = "die"		
		change_animation("die")
		is_patrol = false

func on_animation_finished() -> void:
	if active_anim_name == "die":
		queue_free()

func change_animation(anim_name: String, maintain_progress: bool = false) -> void:
	var curr_frame = frame
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
	
