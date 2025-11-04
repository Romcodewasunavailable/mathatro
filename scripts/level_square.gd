@tool
class_name LevelButton
extends Button

@export var number := 1:
	set(value):
		number = value
		text = str(number)
@export var level_path := ""
@export var status := Level.Status.AVAILABLE:
	set(value):
		status = value
		disabled = status == Level.Status.LOCKED


func _init(number := 1, level_path := "") -> void:
	self.number = number
	self.level_path = level_path
