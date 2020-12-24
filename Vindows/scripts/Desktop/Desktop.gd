extends Node

const SAVE : String = "user://save.data"
onready var Global = get_node("/root/Global")

onready var TOM = get_node("CanvasLayer/TOM")

var hold = null
var double = null

signal menuSignal

var UpActions = {
	"Vindows":
		funcref(self,"Vindows"),
	"TurnOff":
		funcref(self,"TurnOff"),
	"Cancel":
		funcref(self,"shutDownCancel"),
}
var DoubleActions = {
	"PaintButton":
		funcref(self,"OpenPaint")
}

func bt_down(node:String):
	get_node(node).modulate = Global.pressMod
	
	if DoubleActions.has(get_node(node).name):
		hold = get_node(node)
		set_process(true)
		if double == null:
			double = get_node(node)
			$DoubleClickTimer.start()
		else:
			double = null
			DoubleActions[get_node(node).name].call_func()
	

func bt_up(node:String):
	get_node(node).modulate = Global.normalMod
	if UpActions.has(get_node(node).name):
		UpActions[get_node(node).name].call_func()
	hold = null
	set_process(false)

#################################UpActions#################################
func TurnOff():
	Save_Datas()
	get_tree().change_scene_to(load("res://scenes/encerramento.tscn"))

func shutDownCancel():
	TOM.hide()

func Vindows():
	emit_signal("menuSignal")
	var menu = $CanvasLayer/HotBar/Menu
	if !menu.visible:
		menu.show_behind_parent = true
		menu.show()
	else: menu.hide()
#################################DoubleClickAction#################################
func OpenPaint():
	var paint = preload("res://scenes/Programs/Paint/Paint.tscn").instance()
	$Windows/ViewportContainer/Viewport.add_child(paint)
	$Windows/ViewportContainer.show()
###################################################################################

func _ready():
	Load_Datas()
	for i in get_tree().get_nodes_in_group("DeskButtons"):
		i.connect("button_down",self,"bt_down",[i.get_path()])
		i.connect("button_up",self,"bt_up",[i.get_path()])

func _process(_delta):
	if hold != null:
		var pos = (get_viewport().get_mouse_position()-hold.rect_size/4)/16
		var gridPos = Vector2(int(pos.x),int(pos.y))
		hold.rect_position = gridPos * 16

func Save_Datas():
	var file = File.new()
	var error = file.open(SAVE,File.WRITE)
	
	var data = {"Wallpaper":$WallPaper.texture.resource_path}
	if !error:
		file.store_var(data)
	else: print("erro ao salvar")
	
	file.close()

func Load_Datas():
	var file = File.new()
	var error = file.open(SAVE,File.READ)
	
	if !error:
		var saved_datas = file.get_var()
		$WallPaper.texture = load(saved_datas["Wallpaper"])
	else: print("erro ao carregar")
	
	file.close()


func _on_DoubleClickTimer_timeout():
	double = null
