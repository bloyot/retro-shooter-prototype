extends Sprite3D

@onready var despawn_timer: Timer = $DespawnTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	despawn_timer.timeout.connect(func(): queue_free())
