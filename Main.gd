extends Control

onready var Clean = $CleanBtn
onready var DL = $DirectoryLocation
onready var CD = $ConfirmationDialog
onready var CF = $CheckedFiles

var pathdirectory: String
var savePath: String

# Called when the node enters the scene tree for the first time.
func _ready():
	DL.connect("text_changed", self, "_on_text_changed")
	Clean.connect("pressed", self, "_on_clean_pressed")
	CD.connect("confirmed", self, "_on_confirmation_to_save")
	$Error.text = ""
	CF.text = ''
	
	# move files to dir based on extension
func dir_contents(path):
	if path == '':
		$Error.text = 'please set the directory path before cleaning'
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "" :
			if dir.current_is_dir():
				CF.add_text("Skipping " + file_name + " folder")
				CF.newline()
				CF.newline()
			else:
				dir.make_dir(str(file_name.get_extension()))
				dir.copy(path + '/' + file_name, path + '/' + str(file_name.get_extension()) + '/' + file_name)
				dir.remove(path + '/' + file_name)
				CF.add_text('Moving ' + file_name + ' to ' + path + '/' + str(file_name.get_extension()))
				CF.newline()
				CF.newline()
			file_name = dir.get_next()
		CD.popup_centered()
	else:
		$Error.text = 'An error occurred when trying to access the path'
		OS.alert("Directory does not exist, check path", 'Error') # two parameter: 1st is description, 2nd is Title
		
	
	#set directory to be cleaned	
func _on_text_changed(new_text):
	pathdirectory = new_text
	savePath = new_text + "/Moved_Files.txt"
	pass
	
	# clean it
func _on_clean_pressed():
	CF.text = ''
	$Error.text = ''
	dir_contents(pathdirectory)
	
	#confirmation to save 
func _on_confirmation_to_save():
	save(savePath)

	# track the record and save the text file of moved file
func save(path):
	var file = File.new()
	file.open(path, 2)
	file.store_string(CF.text)
	file.close()
	pass
