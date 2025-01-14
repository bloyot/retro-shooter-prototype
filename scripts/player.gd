class_name Player
extends CharacterBody3D

const SPEED = 10.0
const DECELERATION = 0.5
const JUMP_VELOCITY = 7
const MOUSE_SENSITIVITY = .1

@onready var camera: Camera3D = $Camera
@onready var projectiles_container := get_tree().current_scene.get_node("Game/ProjectilesContainer")	
@onready var projectile_origin := $Camera/ProjectileOrigin
@onready var shoot_cooldown_timer := $ShootCooldown
@onready var weapon_manager := $Camera/WeaponManager

var shoot_cooldown := false

func _ready() -> void:
	shoot_cooldown_timer.timeout.connect(on_shoot_cooldown_timer)	

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_shooting()
	handle_weapon_swap()
	
func handle_movement(delta: float) -> void: 
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
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
			
			
