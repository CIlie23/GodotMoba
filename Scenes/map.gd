extends Node3D

@onready var wp_1: Marker3D = $TopLane/Tower/WP1
@onready var tower_2: StaticBody3D = $BotLane/Tower2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("killTowers"):
		delete_two_nodes()

func delete_two_nodes():
	wp_1.queue_free()
	print("wp 1 deleted")
