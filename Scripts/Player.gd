extends KinematicBody

export var speed = 4
export var sprint_speed = 6
export var acceleration = 10
export var gravity = 0.98
export var jump_y_power = 32.5

onready var game = get_node("/root/Game")
onready var head = $Head
onready var camera = $Head/Camera
onready var anim = get_node("/root/Game/Player/CharacterMesh/AnimationPlayer")

var velocity = Vector3()
var rot_x = 0
var y_delta

func _input(event):
	if event is InputEventMouseMotion and !game.menu_opened:
		# reset rotation
		self.transform.basis = Basis()
		# calculate y delta
		y_delta = event.relative.x * game.mouse_sensitivity
		# rotate in Y
		rot_x += y_delta
		rotate_object_local(Vector3(0, -1, 0), rot_x)
				
func _physics_process(delta):
	var head_basis = self.get_global_transform().basis
	var dir = Vector3()
	var control_dir = Vector2()
	
	if !game.menu_opened:
		if Input.is_action_pressed("move_foward"):
			dir -= head_basis.z
			control_dir.y += 1
		if Input.is_action_pressed("move_backward"):
			dir += head_basis.z
			control_dir.y -= 1
		if Input.is_action_pressed("move_left"):
			dir -= head_basis.x
			control_dir.x += 1
		if Input.is_action_pressed("move_right"):
			dir += head_basis.x
			control_dir.x -= 1

	set_anim(control_dir)
		
	dir = dir.normalized()
	
	if Input.is_action_just_pressed("jump") and is_on_floor() and !game.menu_opened:
		velocity.y += jump_y_power
	
	var tempSpeed = speed
	if control_dir == Vector2(0, 1) and Input.is_action_pressed("sprint"):
		tempSpeed = sprint_speed
		
	velocity = velocity.linear_interpolate(dir * tempSpeed, acceleration * delta)
		
	velocity.y -= gravity
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
func set_anim(dir):
	var current = anim.current_animation
	if Input.is_action_just_pressed("jump"):
		if current != 'jump':
			anim.play("jump", game.anim_blend);
	elif is_on_floor():
		if dir == Vector2(0, 0) and current != 'idle':
			anim.play("idle", game.anim_blend);
		elif dir == Vector2(0, 1) :
			if Input.is_action_pressed("sprint") and current != 'run':
				anim.play("run", game.anim_blend);
			elif !Input.is_action_pressed("sprint") and current != 'walk_f':
				anim.play("walk_f", game.anim_blend);
		elif dir == Vector2(1, 1) and current != 'walk_f_l':
			anim.play("walk_f_l", game.anim_blend);
		elif dir == Vector2(-1, 1) and current != 'walk_f_r':
			anim.play("walk_f_r", game.anim_blend);
		elif dir == Vector2(1, 0) and current != 'walk_l':
			anim.play("walk_l", game.anim_blend);
		elif dir == Vector2(-1, 0) and current != 'walk_r':
			anim.play("walk_r", game.anim_blend);
		elif dir == Vector2(0, -1) and current != 'walk_f':
			anim.play("walk_f", game.anim_blend);
		elif dir == Vector2(1, -1) and current != 'walk_f_r':
			anim.play("walk_f_r", game.anim_blend);
		elif dir == Vector2(-1, -1) and current != 'walk_f_l':
			anim.play("walk_f_l", game.anim_blend);
		
