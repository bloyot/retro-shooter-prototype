class_name Game extends Node3D

@export var player_scene: PackedScene

# should only ever be one player in the scene
#@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var player_spawns: Array = get_tree().get_nodes_in_group("player_spawn")

var active_spawn: Marker3D
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(player_spawns.size() > 0, "Must set at least one player spawn")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	active_spawn = player_spawns[0] as Marker3D
	player = spawn_player(active_spawn)
	
	EventManager.subscribe(GlobalUtils.EventType.PLAYER_DEATH, on_player_death)

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
	player.global_rotation = active_spawn.global_rotation
	player.camera.rotation = Vector3.ZERO
	
func spawn_player(spawn_position: Marker3D) -> Player:
	var player := player_scene.instantiate() as Player
	add_child(player)
	player.global_position = spawn_position.global_position
	player.global_rotation = spawn_position.global_rotation
	return player
	
func on_player_death(args: Array[Variant]) -> void:
	reset()
