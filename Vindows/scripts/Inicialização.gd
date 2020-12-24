extends Node

func _ready():
	var animation
	if name == "Iniciar":
		animation = $"Inicialização/AnimationPlayer"
		animation.play("Inicialização")
	else:
		animation = $"Encerramento/AnimationPlayer"
		animation.play("Encerramento")

func _on_AnimationPlayer_animation_finished(anim_name):
	if name == "Encerrar":
		get_tree().quit()
	else:
		$Timer.start()

func _on_Timer_timeout():
	get_tree().change_scene_to(preload("res://scenes/Desktop.tscn"))
