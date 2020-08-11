extends Spatial

var MAX_ROTATION = 1.4
var rot_x = 0
var rot_y = 0
var x_delta
var y_delta

onready var game = get_node("/root/Game")

func _input(event):
	if event is InputEventMouseMotion and !game.menu_opened:
		# reset rotation
		self.transform.basis = Basis()
		
		# calculate deltas
		x_delta = event.relative.y * game.mouse_sensitivity
		y_delta = event.relative.x * game.mouse_sensitivity
		
		# first rotate in Y
		rot_x += y_delta
		rotate_object_local(Vector3(0, -1, 0), rot_x)
		
		# then rotate in X
		if (rot_y + x_delta) < -MAX_ROTATION:
			rot_y = -MAX_ROTATION
		elif (rot_y + x_delta) > MAX_ROTATION:
			rot_y = MAX_ROTATION
		else:
			rot_y += x_delta
		rotate_object_local(Vector3(-1, 0, 0), rot_y)
		
		
