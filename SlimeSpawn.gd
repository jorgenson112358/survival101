extends Node2D

@onready var enemy = preload("res://Scenes/slime.tscn")
var currentCount = 0
var maxCount = 50

func _on_timer_timeout():
	var en = enemy.instantiate()
	en.position = position
	get_parent().add_child(en)
	currentCount += 1
	
	if currentCount >= maxCount:
		$Timer.stop()
