extends ColorRect
onready var Global = get_node("/root/Global")

var rng = RandomNumberGenerator.new()

var vindows 
onready var bgButton = $VBoxContainer/BG_b
var wpFiles: Array
const supportedFiles = ["png","jpg","jpeg"]

onready var TOM = get_parent().get_parent().get_node("TOM")

func _ready():
	dir_contents("res://Assets/Images/WallPapers/")
	rng.randomize()
	for i in get_tree().get_nodes_in_group("MenuButtons"):
		i.connect("button_down",self,"bt_down",[i.get_path()])
		i.connect("button_up",self,"bt_up",[i.get_path()])

var actions = {
	"BG_b":
		funcref(self,"switchWP"),
	"Desligar":
		funcref(self,"Desligar")
}

func Desligar():
	if !TOM.visible:
		TOM.show()
	else: TOM.hide()

func bt_down(node:String):
	get_node(node).modulate = Global.pressMod

func bt_up(node:String):
	get_node(node).modulate = Global.normalMod
	if actions[get_node(node).name] != null:
		actions[get_node(node).name].call_func()

func switchWP():
	var bg = get_node("../../../WallPaper")
	var wp = choose(wpFiles)
	if load(wp) != bg.texture:
		bg.texture = load(wp)
	else: switchWP()

func choose(arg: Array):
	var chooser = rng.randi()%len(arg)
	return arg[chooser-1]

func dir_contents(path:String):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() && file_name.get_extension() in supportedFiles:
				wpFiles.append(path+file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
