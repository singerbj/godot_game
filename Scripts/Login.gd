extends Control

onready var background = $Background
onready var title = $Title
onready var email = $Email
onready var password = $Password
onready var login = $Login

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var window_size = get_viewport().size
	var window_center = Vector2(window_size.x / 2, window_size.y / 2)
	
	background.set_size(Vector2(window_size.x, window_size.y))
	background.set_position(Vector2(0, 0))	
	
	title.set_size(Vector2(400, 30))
	title.set_position(Vector2(window_center.x - (title.get_rect().size.x / 2), window_center.y - 50))
	
	email.set_size(Vector2(400, 30))
	email.set_position(Vector2(window_center.x - (email.get_rect().size.x / 2), window_center.y))

	password.set_size(Vector2(400, 30))
	password.set_position(Vector2(window_center.x - (password.get_rect().size.x / 2), window_center.y + 50))	

	login.set_size(Vector2(200, 30))
	login.set_position(Vector2(window_center.x - (login.get_rect().size.x / 2), window_center.y + 100))	
