extends Camera

enum { FIRST_PERSON, THIRD_PERSON }
var camera_view = FIRST_PERSON

onready var screen_size_x = get_viewport().size.x
onready var screen_size_y = get_viewport().size.y
onready var crosshair = $Crosshair
onready var camera = self
		
func _process(delta):	
	if Input.is_action_just_pressed("toggle_camera"):
		toggle_camera_view()
		
	set_camera_location()

func set_crosshair_location():
	screen_size_x = get_viewport().size.x
	screen_size_y = get_viewport().size.y

	var crosshair_x_location = (screen_size_x / 2) - (crosshair.texture.get_size().x / 2)
	var crosshair_y_location = (screen_size_y / 2) - (crosshair.texture.get_size().y / 2)
	crosshair.set_position(Vector2(crosshair_x_location, crosshair_y_location))
	
func set_allow_movement(menu_opened):
	if menu_opened:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func toggle_camera_view():
	if camera_view == FIRST_PERSON:
		camera_view = THIRD_PERSON
	else:
		camera_view = FIRST_PERSON

func set_camera_location():
	if camera_view == FIRST_PERSON:
		camera.transform.origin.z = 0
	elif camera_view == THIRD_PERSON:
		camera.transform.origin.z = 10
