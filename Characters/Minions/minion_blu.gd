extends CharacterBody3D

@onready var agent: NavigationAgent3D = $NavigationAgent3D

# to do, make spawn locations assignable 

var speed: int = 3
var target: Vector3

var waypoints: Array[Vector3] = []
var current_wp := 0

func _ready() -> void:
	#target = Vector3(10, 0, 10)
	updateTargetLocation(target)

func _physics_process(delta: float) -> void:
	look_at(target)
	rotation.x = 0
	rotation.y = 0
	
	if waypoints.is_empty(): 
		return

	if agent.is_navigation_finished():
		current_wp += 1
		if current_wp >= waypoints.size():
			queue_free() # reached the end
		else:
			set_target(waypoints[current_wp])
			
	if position.distance_to(target) > 0.5:
		var curLoc = global_transform.origin
		var nextLoc = agent.get_next_path_position()
		var newVal = (nextLoc - curLoc).normalized() * speed
		velocity = newVal
		move_and_slide()
	
func updateTargetLocation(taget):
	agent.set_target_position(target)

func set_target(pos: Vector3) -> void:
	target = pos
	agent.target_position = pos
	
func set_waypoints(list: Array[Vector3]):
	waypoints = list
	current_wp = 0
	set_target(waypoints[0])
