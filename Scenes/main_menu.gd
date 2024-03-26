extends Control

# to store center coordinates 
var center : Vector2
@onready var controlnode = $Control
# Called when the node enters the scene tree for the first time.

func _ready():
	#calculate center of the screen 
	center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)

func _process(delta):
	var tween = controlnode.create_tween()
	#calculate the vector b/w mouse and center taking only 10% value 
	var offset = center - get_global_mouse_position() * 0.7
	# running tween to animate blocks position 
	tween.tween_property(controlnode,"position",offset,3)
	
func _on_item_rect():
	center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/map1.tscn")

func _on_options_button_pressed():
	pass # Replace with function body.

func _on_quit_button_pressed():
	get_tree().quit()
