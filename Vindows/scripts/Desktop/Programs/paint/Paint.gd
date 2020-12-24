extends Node

onready var Global = get_node("/root/Global")

onready var canvas = $Window/Canvas
onready var window = $Window
onready var close_bt = $Window/Close_BT

var on_canvas:bool
var actions = {
	"Close_BT":
		funcref(self,"close")
}
func close():
	get_node("../../").hide()
	
	queue_free()

func menuSignal():
	if canvas.mouse_filter == canvas.MOUSE_FILTER_PASS:
		set_process(false)
		canvas.mouse_filter = canvas.MOUSE_FILTER_IGNORE
	else:
		set_process(true)
		canvas.mouse_filter = canvas.MOUSE_FILTER_PASS

func _ready():
	get_tree().get_root().get_node("Desktop").connect("menuSignal",self,"menuSignal")
	close_bt.connect("button_down",self,"bt_down",[close_bt])
	close_bt.connect("button_up",self,"bt_up",[close_bt])
	canvas.connect("mouse_entered",self,"on_canvas_control",[true])
	canvas.connect("mouse_exited",self,"on_canvas_control",[false])


func bt_down(node:CanvasItem):
	node.modulate = Global.pressMod

func bt_up(node:CanvasItem):
	node.modulate = Global.normalMod
	if actions[node.name] != null:
		actions[node.name].call_func()

func on_canvas_control(state:bool):
	on_canvas = state
