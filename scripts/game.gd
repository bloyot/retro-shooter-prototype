class_name Game extends Node3D

# should only ever be one player in the scene
@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var player_spawns: Array = get_tree().get_nodes_in_group("player_spawn")

var active_spawn: Marker3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(player_spawns.size() > 0, "Must set at least one player spawn")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	active_spawn = player_spawns[0] as Marker3D
	player.global_position = active_spawn.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("exit"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("reset"):
		reset()
		
	if Input.is_action_pressed("spawn_1"):
		active_spawn = player_spawns[0]
		reset()
		
	if Input.is_action_pressed("spawn_2") and player_spawns.size() > 1:
		active_spawn = player_spawns[1]
		reset()
		
	if Input.is_action_pressed("spawn_3") and player_spawns.size() > 2:
		active_spawn = player_spawns[2]
		reset()

func reset() -> void:
	player.global_position = active_spawn.global_position		
	player.global_rotation = Vector3.ZERO
	player.camera.rotation = Vector3.ZERO
