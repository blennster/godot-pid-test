extends "res://omnibot.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pendulum : Spatial
var P = 20
var I = 15
var D = 1.6

# Called when the node enters the scene tree for the first time.
func _ready():
	pendulum = get_node("../RigidBody2/Spatial")
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	proccess_x(delta)
	proccess_z(delta)

var cum_err_z: float = 0
var last_err_z: float = 0
var iter_z = 0
func proccess_z(delta):
	var rot = (global_transform.origin + Vector3(0, 1, 0)).direction_to(pendulum.global_transform.origin)
	
	# Error (distance to expected value)
	var err = rot.z
	
	# P factor
	var p = err * P
	
	# Integral (I factor)
	cum_err_z += err * I * delta
	
	# Derivate (D factor, not sure about this doe)
	var d = (last_err_z - err) * D
	last_err_z = err
	
	# Output value
	var cmpr = p + cum_err_z + d
	
	# Debugging
	iter_z += 1
	if iter_z % 10 == 0:
		print([p, cum_err_z, d, cmpr])

	# deadzone
	if abs(cmpr) > 0.15:
		move(delta, sign(cmpr)*Vector3(0, 0, 1))
	
	

var cum_err_x: float = 0
var last_err_x: float = 0
var iter_x = 0
func proccess_x(delta):
	var rot = (global_transform.origin + Vector3(0, 1, 0)).direction_to(pendulum.global_transform.origin)
	
	# Error (distance to expected value)
	var err = rot.x
	
	# P factor
	var p = err * P
	
	# Integral (I factor)
	cum_err_x += err * I * delta
	
	# Derivate (D factor, not sure about this doe)
	var d = (last_err_x - err) * D
	last_err_x = err
	
	# Output value
	var cmpr = p + cum_err_x + d
	
	# Debugging
	iter_x += 1
	if iter_x % 10 == 0:
		print([p, cum_err_x, d, cmpr])

	# Deadzone
	if abs(cmpr) > 0.1:
		move(delta, sign(cmpr)*Vector3(1, 0, 0))
	
	
