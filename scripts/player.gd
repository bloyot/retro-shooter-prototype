class_name Player
extends CharacterBody3D

const SPEED = 10.0
const DECELERATION = 0.5
const JUMP_VELOCITY = 7
const MOUSE_SENSITIVITY = .1

@onready var camera: Camera3D = $Camera
@onready var projectiles_container := get_tree().current_scene.get_node("Game/ProjectilesContainer")	
@onready var projectile_origin := $Camera/ProjectileOrigin
@onready var weapon_manager := $Camera/WeaponManager
@onready var hitbox:= $Hitbox

# timers
@onready var shoot_cooldown_timer := $ShootCooldown
@onready var coyote_time:= $CoyoteTime
@onready var damage_invuln_timer:= $CoyoteTime

var shoot_cooldown := false
var coyote_time_eligible:= true
var damange_invlun_cooldown = 1
var max_health = 100
var curr_health = max_health

# track the list of things we're colliding with (mainly enemies) for persistent damage
var colliding_objects: Array = []

func _ready() -> void:
	shoot_cooldown_timer.timeout.connect(on_shoot_cooldown_timer)		
	hitbox.area_entered.connect(on_area_entered)
	hitbox.area_exited.connect(on_area_exited)

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_shooting()
	handle_weapon_swap()
	handle_collisions()
	
func handle_movement(delta: float) -> void: 
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if coyote_time.is_stopped() and coyote_time_eligible:
			coyote_time.start()
			coyote_time_eligible = false
	else:
		coyote_time_eligible = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and can_jump():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)

	move_and_slide()
	
func handle_shooting() -> void:
	if Input.is_action_pressed("primary_fire") and not shoot_cooldown:
			shoot_cooldown = true
			shoot_cooldown_timer.start(weapon_manager.get_active_weapon().get_weapon_cooldown_s())
			weapon_manager.get_active_weapon().fire()

func handle_weapon_swap() -> void:
	if Input.is_action_just_pressed("next_weapon"):
		weapon_manager.next_weapon()
	if Input.is_action_just_pressed("prev_weapon"):
		weapon_manager.prev_weapon()	

func handle_collisions() -> void: 
	for obj in colliding_objects:
		if obj is Enemy:
			take_damage(obj.enemy_resource.melee_damage)

#### event callbacks #####
func on_shoot_cooldown_timer() -> void:
	shoot_cooldown = false

# handle camera rotation and other specific input events
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY))
		# rotate the player rather than the camera, to keep the orientations separate and correct
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -89.9, 89.9)
	if event is InputEventKey:
		if event.keycode == Key.KEY_1:
			weapon_manager.swap_weapon(0)
		if event.keycode == Key.KEY_2:
			weapon_manager.swap_weapon(1)
		if event.keycode == Key.KEY_3:
			weapon_manager.swap_weapon(2)

func die() -> void:
	reset()
	EventManager.publish(GlobalUtils.EventType.PLAYER_DEATH, [])	
	
func reset() -> void:
	curr_health = max_health
	colliding_objects = []
	
func on_area_entered(area: Area3D):
	if area.is_in_group("killbox"):
		die()
	if area.get_parent().is_in_group("enemy"):
		colliding_objects.push_back(area.get_parent())

func on_area_exited(area: Area3D):	
	if area.get_parent().is_in_group("enemy"):		
		colliding_objects.erase(area.get_parent())
		
func can_jump() -> bool:
	# currently just check if we are on the floor (or were within the last few frames)
	return is_on_floor() or !coyote_time.is_stopped()
			
func take_damage(damage: float) -> void:	
	if damage_invuln_timer.is_stopped():
		curr_health -= damage
		damage_invuln_timer.start(damange_invlun_cooldown)
		EventManager.publish(GlobalUtils.EventType.PLAYER_DAMAGE, [damage])	
		if curr_health <= 0:			
			die()
