extends CharacterBody3D

@onready var camera: Camera3D = $Camera
@onready var agent: NavigationAgent3D = $NavigationAgent3D

@export var speed: float = 8.0
var navigation_target_position: Vector3 # Renamed to be more descriptive

func _ready() -> void:
	navigation_target_position = global_position
	agent.set_target_position(navigation_target_position)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		var mouse_pos = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_pos)
		var dir  = camera.project_ray_normal(mouse_pos)

		var ground_plane := Plane(Vector3.UP, 0.0)
		var intersection = ground_plane.intersects_ray(from, dir)

		if intersection != null:
			#print("Hit at: ", intersection)
			navigation_target_position = Vector3(intersection.x, global_position.y, intersection.z)
			agent.set_target_position(navigation_target_position)
			
	# Check if the navigation agent has a path and is not at its final target
	if not agent.is_navigation_finished():
		var current_agent_position = global_position
		var next_path_point = agent.get_next_path_position()
		
		var direction_to_next_point = (next_path_point - current_agent_position).normalized()

		velocity = direction_to_next_point * speed
	else:
		velocity = Vector3.ZERO
		
	move_and_slide()
