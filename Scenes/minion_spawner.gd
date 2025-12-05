extends Node3D

@onready var spawn_timer: Timer = $SpawnTimer
@onready var time_between_spawn: Timer = $TimeBetweenSpawn

#@export var lane_path: Node3D  
@export var tower: Marker3D
@export var nexus: Marker3D
@export var isSpanwerOn: bool
var towerPath: Array[Vector3] = []
#const MINION_BLU = preload("uid://bbquuf8db7bxa")
@export var minion: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	towerPath = [
		#$"../TopLane/Tower/WP1".global_position
		tower.global_position,
		nexus.global_position
	]
	#print("Minion spawner's alive")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_time_between_spawn_timeout() -> void:
	if isSpanwerOn == true:
		var minion_instance = minion.instantiate()
		add_child(minion_instance)
		minion_instance.set_waypoints(towerPath)
		
