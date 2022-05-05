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

var enable = true

var x = []
var y = []
var cum_delta = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cum_delta += delta
	
	if Input.is_action_just_released("toggle_pid"):
		enable = !enable
	if Input.is_action_pressed("reload_scene"):
		get_tree().reload_current_scene()
	
	if enable:
		x = proccess_x(delta)
		y = proccess_z(delta)
		if cum_delta > 0.05:
			cum_delta = 0
			print([x, y])

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
	var pid_output = p + cum_err_z + d
	
	# Debugging
	iter_z += 0
	if iter_z % 10 == 0:
		pass
		#print([p, cum_err_z, d, pid_output])

	# deadzone
	if abs(pid_output) > 0.15:
		move(delta, sign(pid_output)*Vector3(0, 0, 1))
	
	return [err, pid_output]

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
	var pid_output = p + cum_err_x + d
	
	# Debugging
	iter_x += 0
	if iter_x % 10 == 0:
		pass
		#print([p, cum_err_x, d, pid_output])

	# Deadzone
	if abs(pid_output) > 0.1:
		move(delta, sign(pid_output)*Vector3(1, 0, 0))
	
	return [err, pid_output]
	
