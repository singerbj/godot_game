extends Spatial

var MAX_ROTATION = 1.4
var rot_y = 0
var x_delta

onready var game = get_node("/root/Game")
onready var player = get_node("/root/Game/Player")

func _input(event):
	if event is InputEventMouseMotion and !game.menu_opened:
		# reset rotation
		self.transform.basis = Basis()
		# calculate x delta
		x_delta = event.relative.y * game.mouse_sensitivity
		# rotate in X
		if (rot_y + x_delta) < -MAX_ROTATION:
			rot_y = -MAX_ROTATION
		elif (rot_y + x_delta) > MAX_ROTATION:
			rot_y = MAX_ROTATION
		else:
			rot_y += x_delta
		rotate_object_local(Vector3(-1, 0, 0), rot_y)
		
		
