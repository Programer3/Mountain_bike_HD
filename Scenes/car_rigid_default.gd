extends RigidBody2D

var wheels = []
var speed = 100000
var max_speed = 80
# Called when the node enters the scene tree for the first time.
func _ready():
	wheels = get_tree().get_nodes_in_group("Wheel1_default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		for wheellooper in wheels:
			if wheellooper.angular_velocity < max_speed:
				wheellooper.apply_torque_impulse(speed * 60 * delta)
				
	#if Input.is_action_pressed("ui_left"): # for debugging onlynot for final games
		#for wheellooper in wheels:
			#if wheellooper.angular_velocity > -max_speed:
				#wheellooper.apply_torque_impulse(-speed * 60 * delta)
	
	
