extends ColorRect

var points:PoolVector2Array

func _ready():
	update()
func _process(delta):
	if Input.is_action_pressed("click"):
		points.append(get_global_mouse_position())
		print("ponto")
		update()

"""
func _input(event):
	if event is InputEventMouseButton && event.get_button_index() == 1 && event.is_pressed():
		if !event.position in points:
			print("ponto")
			points.append(event.position)
"""
func _draw():
	draw_set_transform(-rect_position,-rect_rotation,rect_scale)
	draw_circle(Vector2(50,50),10,Color.black)
	for c in len(points):
		draw_circle(points[c], 1, Color.black)
		if c-1 >= 0:
			draw_line(points[c-1],points[c],Color.black,1)
