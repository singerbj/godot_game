class_name Player
extends Character

var input_locked := false
var accel := Vector3.ZERO
var last_direction := Vector3.ZERO
var y_delta = 0
var rot_x = 0

var is_active := true setget set_is_active

onready var timer: Timer = $Timer
# onready var camera_2d: Camera2D = $Camera2D #TODO: do i need to manage the camera here?

func _ready() -> void:
	timer.connect("timeout", self, "_on_Timer_timeout")
#	hide()
	
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
	dir = _get_direction()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and state == States.ON_GROUND:
		jump()
	
func setup(username: String, color: Color, position: Vector3) -> void:
	self.username = username
	self.color = color
	global_transform.origin = position
	spawn()
	set_process(true)
	show()

func spawn() -> void:
	set_process_unhandled_input(false)
	.spawn()
	yield(self, "spawned")
	set_process_unhandled_input(true)

func jump() -> void:
	.jump()
	ServerConnection.send_jump()

func set_is_active(value: bool) -> void:
	is_active = value
	set_process(value)
	set_process_unhandled_input(value)
	timer.paused = not value


func _get_direction() -> Vector3:
#	if not is_processing_unhandled_input():
#		return Vector3.ZERO

	# var new_direction := Vector3(
	# 	Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 0
	# )
	# if new_direction != last_direction:
	# 	ServerConnection.send_direction_update(new_direction.x)
	# 	last_direction = new_direction
	# return new_direction

	var head_basis = self.get_global_transform().basis
	var new_direction = Vector3()
	
	if !game.menu_opened:
		if Input.is_action_pressed("move_foward"):
			new_direction -= head_basis.z
		if Input.is_action_pressed("move_backward"):
			new_direction += head_basis.z
		if Input.is_action_pressed("move_left"):
			new_direction -= head_basis.x
		if Input.is_action_pressed("move_right"):
			new_direction += head_basis.x

	new_direction = new_direction.normalized()
	# TODO: figure out how to fit sprint into this

	if new_direction != last_direction:
		ServerConnection.send_direction_update(new_direction, head_basis)
		last_direction = new_direction
	return new_direction


func _on_Timer_timeout() -> void:
	ServerConnection.send_position_update(global_transform.origin)


func _on_GameUI_chat_edit_started() -> void:
	self.is_active = false


func _on_GameUI_chat_edit_ended() -> void:
	self.is_active = true


func _on_GameUI_color_changed(new_color: Color) -> void:
	self.color = new_color
	self.is_active = true
