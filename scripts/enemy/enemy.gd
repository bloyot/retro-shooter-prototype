class_name Enemy extends AnimatedSprite3D

@export var enemy_resource: EnemyResource

@onready var player: Player = get_tree().get_first_node_in_group("game").player
var active_direction: String = "s"
var active_anim_name: String = "walk"
var curr_health: float

func _ready() -> void:
	curr_health = enemy_resource.health
	animation_finished.connect(on_animation_finished)

func _process(delta: float) -> void:		
	# forward vector for the enemy
	var enemy_facing = Vector2(global_basis.z.x, global_basis.z.z)
	
	# vector from enemy to player
	var player_vec = (player.global_position - global_position)
	var player_vec_2d = Vector2(player_vec.x, player_vec.z)
	var angle = rad_to_deg(enemy_facing.angle_to(player_vec_2d))
	var direction = angle_to_direction(angle)	
	if active_direction != direction:
		active_direction = direction
		play(active_anim_name + "_" + active_direction)	
		
	
	
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
	curr_health -= weapon_resource.damage
	if curr_health < 0:
		active_anim_name = "falling"		

func on_animation_finished() -> void:
	if active_anim_name == "falling":
		queue_free()
