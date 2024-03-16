extends RigidBody2D

var wheel = []
var speed = 30000
var max_speed = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	wheel = get_tree().get_nodes_in_group("wheel1_default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		for wheels in wheel:
			if wheels.angular_velocity < max_speed:
				wheels.apply_torque_impulse(speed * 60 * delta)

	#if Input.is_action_pressed("ui_left"):
		#for wheels in wheel:
			#if wheels.angular_velocity > -max_speed:
				#wheels.apply_torque_impulse(-speed * 60 * delta)
