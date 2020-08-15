extends Spatial

onready var screen_size_x = get_viewport().size.x
onready var screen_size_y = get_viewport().size.y

export var menu_opened = false
export var login_opened = false
export var mouse_sensitivity = 0.0005
export var anim_blend = 0.2
var title = "Game v0.1"

onready var camera = $Player/Head/Camera
onready var hud = $HUD
onready var fps_label = $HUD/FPSLabel

#func _ready():
#	OS.window_fullscreen = true
				
func _process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.is_key_pressed(KEY_SHIFT):
			get_tree().quit()
		else:
			toggle_menu_opened()
	camera.set_allow_movement(menu_opened)
	camera.set_crosshair_location()
	
	hud.set_position(Vector2(0, 0))
	hud.set_size(Vector2(get_viewport().size.x, get_viewport().size.y))
	
	fps_label.set_position(Vector2(0, 10))
	fps_label.set_size(Vector2(get_viewport().size.x - 10, 50))
	fps_label.bbcode_text = "[right][b]" + str(Engine.get_frames_per_second()) + " fps[/b][/right]"
	
		
func toggle_menu_opened():
	menu_opened = !menu_opened
	
