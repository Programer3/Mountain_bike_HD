# https://youtu.be/nKBhz6oJYsc <- reference
extends Node2D

@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d = $StaticBody2D/CollisionPolygon2D/Polygon2D
@onready var static_body_2d = $StaticBody2D
@onready var car_rigid_default = $car_rigid_default
@onready var camera_2d = $Camera2D

var screen_size : Vector2i

func _ready():
	polygon_2d.polygon = collision_polygon_2d.polygon
	#screen_size = get_window().size
	
#func _process(delta):
	##update ground position
	##print(car_rigid_default.position.x)
	#if car_rigid_default.position.x > screen_size.x * 7.795: # as 14975.5 / 1920
		#static_body_2d.append(static_body_2d) # we have to append another static body 2d and remove previous one after some time (for now)
