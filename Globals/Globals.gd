extends Node

const SAVE_PATH = "user://APA_save.cnfg"
var save_path = SAVE_PATH

#what is unlocked?
#T1 = 0, T2 = 1, T3 = 2, L1 = 3, L2 = 4, L3 = 5
var progression:int = 0


func save_data():
	var config = ConfigFile.new()
	
	config.set_value("progress", "amount", progression)
	
	config.save(save_path)


func load_data():
	var config = ConfigFile.new()
	var error = config.load(save_path)
	if error != OK:
		return
	
	progression = config.get_value("progress", "amount", 0)
