extends CharacterBody3D

@onready var agent: NavigationAgent3D = $NavigationAgent3D
@onready var health_bar: ProgressBar = $SubViewport/ProgressBar
@onready var animation: AnimationPlayer = $AnimationPlayer

# TO DO
# After they reach the point, they then pathfind to the nexus
# which is good but we want to do that after the tower falls
# which means that we'll prolly have to do a state machine that
# tells the fellas to enter attack mode once they reach the tower

#---------------------------------------------------------------
# MINION STATS
#---------------------------------------------------------------
var max_minionHealth: int = 100
var minionHealth: int = max_minionHealth
var speed: int = 3

enum Team {BLUE, RED}
@export var team: Team = Team.BLUE

# MINION TARGETING
var target: Vector3
var waypoints: Array[Vector3] = []
var current_wp := 0
var enemy_target: Node3D = null

# STATES
enum minionStates {IDLE, MOVE, CHASE, ATTACK, DEAD}
var current_state = minionStates.IDLE
#---------------------------------------------------------------

func _ready() -> void:
	minionHealth = max_minionHealth
	if not waypoints.is_empty():
		set_target(waypoints[current_wp])
	updateTargetLocation(target)

func _process(delta: float) -> void:
			
	health_bar.max_value = max_minionHealth
	health_bar.value = minionHealth

# needed this so the minions know which team theyre part of
func get_team() -> Team: 
	return team
	
func _physics_process(delta: float) -> void:
	match current_state:
		minionStates.IDLE:
			idleState()
		minionStates.MOVE:
			moveState()
		minionStates.CHASE:
			chaseState()
		minionStates.ATTACK:
			attackState()
		minionStates.DEAD:
			deadState()
			
	if is_instance_valid(enemy_target):
		agent.target_position = enemy_target.global_position
		target = enemy_target.global_position
	else:
		handle_waypoints()
		
	if position.distance_to(target) > 0.5:
		var curLoc = global_transform.origin
		var nextLoc = agent.get_next_path_position()
		var newVal = (nextLoc - curLoc).normalized() * speed
		velocity = newVal
		move_and_slide()
		
		look_at(target)
		rotation.x = 0
		rotation.y = 0
		
#---------------------------------------------------------------
# STATE FUNCTIONS
#---------------------------------------------------------------
func idleState():
	animation.play("attack_anim")

func moveState():
	pass
	
func chaseState():
	pass

func attackState():
	pass

func deadState():
	pass

#---------------------------------------------------------------
# WAYPOINTS AND TARGETING
#---------------------------------------------------------------

func handle_waypoints():
	if waypoints.is_empty(): 
		return

	if agent.is_navigation_finished():
		current_wp += 1
		if current_wp >= waypoints.size():
			queue_free() # reached the end
		else:
			set_target(waypoints[current_wp])
	
func updateTargetLocation(taget):
	agent.set_target_position(target)

func set_target(pos: Vector3) -> void:
	target = pos
	agent.target_position = pos
	
func set_waypoints(list: Array[Vector3]):
	waypoints = list
	current_wp = 0
	set_target(waypoints[0])

#---------------------------------------------------------------
#
#---------------------------------------------------------------
func _on_minion_range_area_body_entered(body: Node3D) -> void:
	if body.has_method("get_team"):
		var entering_team = body.get_team()
		
		if entering_team != team:
			if not is_instance_valid(enemy_target) or position.distance_to(body.global_position) < position.distance_to(enemy_target.global_position):
				enemy_target = body
		
func _on_minion_range_area_body_exited(body: Node3D) -> void:
	if body == enemy_target:
		enemy_target = null

	if not waypoints.is_empty():
		set_target(waypoints[current_wp])
