extends Spatial

onready var screen_size_x = get_viewport().size.x
onready var screen_size_y = get_viewport().size.y

export var menu_opened = false

onready var camera = $Player/Head/Camera

func _ready():
	camera.set_crosshair_location()
		
func _process(delta):	
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_menu_opened()
	camera.set_allow_movement(menu_opened)
	camera.set_crosshair_location()
		
func toggle_menu_opened():
	menu_opened = !menu_opened
	
