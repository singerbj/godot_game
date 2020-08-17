class_name Character
extends KinematicBody

signal spawned

enum States { ON_GROUND, IN_AIR }

export var speed = 4
export var sprint_speed = 6
export var acceleration = 10
export var gravity = 0.98
export var jump_y_power = 32.5

var color := Color.white #setget _set_color
var state: int = States.ON_GROUND

var velocity := Vector3.ZERO
var dir := Vector3.ZERO
var username := "" setget _set_username
var last_position := Vector3.ZERO
var last_input := Vector3.ZERO
var next_position := Vector3.ZERO
var next_input := Vector3.ZERO
var next_jump := false
# var rot_x = 0
# var y_delta

onready var tween := Tween.new()
onready var game = get_node("/root/Game")
onready var anim = $AnimationPlayer

func _ready():
	add_child(tween)

# func _input(event):
# 	if event is InputEventMouseMotion and !game.menu_opened:
# 		# reset rotation
# 		self.transform.basis = Basis()
# 		# calculate y delta
# 		y_delta = event.relative.x * game.mouse_sensitivity
# 		# rotate in Y
# 		rot_x += y_delta
# 		rotate_object_local(Vector3(0, -1, 0), rot_x)
				
func _physics_process(delta):
	move(delta)

	match state:
		States.ON_GROUND:
			if not is_on_floor():
				state = States.IN_AIR
		States.IN_AIR:
			if is_on_floor():
				state = States.ON_GROUND
	
	set_anim()
	
	
func move(delta: float) -> void:
	dir = dir.normalized()
	velocity = velocity.linear_interpolate(dir * speed, acceleration * delta)
	velocity.y -= gravity
	velocity = move_and_slide(velocity, Vector3.UP)
	
func jump() -> void:
	velocity.y -= jump_y_power
	state = States.IN_AIR

func set_anim():
	# TODO: set_anim
	if anim and anim.current_animation and anim.current_animation != 'idle':
		anim.play("idle", game.anim_blend);

	# var current = anim.current_animation
	# if !game.menu_opened and Input.is_action_just_pressed("jump"):
	# 	if current != 'jump':
	# 		anim.play("jump", game.anim_blend);
	# elif is_on_floor():
	# 	if dir == Vector2(0, 0) and current != 'idle':
	# 		anim.play("idle", game.anim_blend);
	# 	elif dir == Vector2(0, 1) :
	# 		if Input.is_action_pressed("sprint") and current != 'run':
	# 			anim.play("run", game.anim_blend);
	# 		elif !Input.is_action_pressed("sprint") and current != 'walk_f':
	# 			anim.play("walk_f", game.anim_blend);
	# 	elif dir == Vector2(1, 1) and current != 'walk_f_l':
	# 		anim.play("walk_f_l", game.anim_blend);
	# 	elif dir == Vector2(-1, 1) and current != 'walk_f_r':
	# 		anim.play("walk_f_r", game.anim_blend);
	# 	elif dir == Vector2(1, 0) and current != 'walk_l':
	# 		anim.play("walk_l", game.anim_blend);
	# 	elif dir == Vector2(-1, 0) and current != 'walk_r':
	# 		anim.play("walk_r", game.anim_blend);
	# 	elif dir == Vector2(0, -1) and current != 'walk_f':
	# 		anim.play("walk_f", game.anim_blend);
	# 	elif dir == Vector2(1, -1) and current != 'walk_f_r':
	# 		anim.play("walk_f_r", game.anim_blend);
	# 	elif dir == Vector2(-1, -1) and current != 'walk_f_l':
	# 		anim.play("walk_f_l", game.anim_blend);
		
func spawn() -> void:
	emit_signal("spawned")

func despawn() -> void:
	queue_free()

func update_state() -> void:
	if next_jump:
		jump()
		next_jump = false

	print(global_transform.origin.distance_squared_to(last_position))
	
#	if global_transform.origin.distance_squared_to(last_position) > 10000:
#		tween.interpolate_property(self, "global_transform", global_transform.origin, last_position, 0.2)
#		tween.start()
#	else:
	var anticipated := last_position + velocity * 0.2
	tween.interpolate_method(self, "do_state_update_move", global_transform.origin, anticipated, 0.2)
	tween.start()

	dir = last_input

	last_input = next_input
	last_position = next_position

func do_hide() -> void:
	hide()


func do_show() -> void:
	show()

func _set_username(value: String) -> void:
	username = value
	# id_label.text = username #TODO: add a label

func _set_color(value: Color) -> void:
	print("_set_color")
	#TODO set color of character via mesh or texture or something

func do_state_update_move(new_position: Vector3) -> void:
	var distance := new_position - global_transform.origin
	move_and_slide(distance, Vector3.UP)
