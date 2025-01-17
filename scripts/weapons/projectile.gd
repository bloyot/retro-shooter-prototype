class_name Projectile extends RigidBody3D

@onready var area := $Area3D
@onready var duration_timer: Timer = Timer.new()

var duration_s: float

static func new_projectile(
		scene: PackedScene, 
		starting_position: Vector3, 
		target_point: Vector3, 
		projectile_speed: float, 
		parent: Node3D,
		duration_s: float) -> Projectile:
		
	var projectile: Projectile = scene.instantiate()	
	parent.add_child(projectile)
	projectile.gravity_scale = 0
	projectile.position = starting_position
	projectile.look_at(target_point)
	projectile.linear_velocity = (target_point - starting_position).normalized() * projectile_speed
	projectile.duration_s = duration_s
	return projectile

func _ready() -> void:	
	area.area_entered.connect(on_area_entered)
	body_entered.connect(on_body_entered)
	
	add_child(duration_timer)
	duration_timer.start(duration_s)		
	duration_timer.timeout.connect(func(): queue_free())	
	
	
func on_area_entered(_area: Area3D) -> void:	
	if "player" not in area.get_parent().get_groups():
		queue_free()

func on_body_entered(body: Node) -> void: 
	queue_free()
