extends KinematicBody

export var speed = 10
export var acceleration = 5
export var gravity = 0.98
export var jump_power = 40

onready var game = get_node("/root/Game")
onready var head = $Head
onready var camera = $Head/Camera

var velocity = Vector3()
		
func _physics_process(delta):
	var head_basis = head.get_global_transform().basis
	
	var direction = Vector3()
	if !game.menu_opened:
		if Input.is_action_pressed("move_foward"):
			direction -= head_basis.z
		if Input.is_action_pressed("move_backward"):
			direction += head_basis.z
		if Input.is_action_pressed("move_left"):
			direction -= head_basis.x
		if Input.is_action_pressed("move_right"):
			direction += head_basis.x
		
	direction = direction.normalized()
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y -= gravity
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if !game.menu_opened:
			velocity.y += jump_power
	
	velocity = move_and_slide(velocity, Vector3.UP)
	


