extends KinematicBody

export var speed = 10
export var acceleration = 5
export var gravity = 0.98
export var jump_y_power = 100 #35
export var jump_x_power = 1000 #35

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
	
	
	var temp_speed = speed
	if Input.is_action_just_pressed("jump") and is_on_floor() and !game.menu_opened:
		velocity.y += jump_y_power
#		temp_speed += jump_x_power #TODO: THIS DOESNT WORK
			
	velocity = velocity.linear_interpolate(direction * temp_speed, acceleration * delta)
	velocity.y -= gravity
	
	velocity = move_and_slide(velocity, Vector3.UP)
	


