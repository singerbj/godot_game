extends Spatial

onready var screen_size_x = get_viewport().size.x
onready var screen_size_y = get_viewport().size.y

export var menu_opened = false
export var mouse_sensitivity = 0.005

onready var camera = $Player/Head/Camera

func _ready():
	camera.set_crosshair_location()
				
func _process(delta):	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.is_key_pressed(KEY_SHIFT):
			get_tree().quit()
		else:
			toggle_menu_opened()
	camera.set_allow_movement(menu_opened)
	camera.set_crosshair_location()
		
func toggle_menu_opened():
	menu_opened = !menu_opened
	
