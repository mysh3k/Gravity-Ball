extends Control

const LEVEL_BTN = preload("res://GUI/LevelButton.tscn")

@export_dir var levels_dir

@onready var grid = $MarginContainer/VBoxContainer/GridContainer

func _ready():
	get_levels(levels_dir)

func get_levels(path) -> void:
	var dir = DirAccess.open(path)
	print(dir.get_current_dir())
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			# Need to find better way of getting a path
			
			create_level_button(path +'/'+ file_name, file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Can't open path.")
		
func create_level_button(lvl_path: String, lvl_name) -> void:
	var btn = LEVEL_BTN.instantiate()
	btn.text = lvl_name
	btn.level_path = lvl_path
	grid.add_child(btn)
	
