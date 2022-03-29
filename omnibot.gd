extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var vectScale = 1000
var manual_scale = 2

func _process(delta):
	if Input.is_action_pressed("move_left"):
		move(delta, manual_scale*Vector3(-1,0,0))
	if Input.is_action_pressed("move_right"):
		move(delta, manual_scale*Vector3(1,0,0))
	if Input.is_action_pressed("move_forward"):
		move(delta, manual_scale*Vector3(0,0,1))
	if Input.is_action_pressed("move_backwards"):
		move(delta, manual_scale*Vector3(0,0,-1))

func move(delta: float, direction: Vector3):
	add_force(vectScale*delta*direction, Vector3(0,0,0))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
