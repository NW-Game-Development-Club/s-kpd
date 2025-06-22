extends Node3D

var taskTypes = ["Photograph", "Retrieve", "Destroy", "Capture", "Analyze"]
var subject = ""
var envMeasurements = ["Atmospheric Conditions", "Temperature", "Humidity", "Particulate Amount", "Radiation", "Magnetic fields", "Vibrations", "Background Audio"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var taskList = []
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var taskAmount = rng.randi_range(3, 5)  # Random int from 1 to 100 (inclusive)
	for i in range(taskAmount):
		taskList.append(gen_task())
	print(taskList)


var photoSpots = ["Coolent Tanks", "Engines", "Lab Setup", "Medical Stations", "Hull Breach"]
var items = ["Black Box", "Prototype X4", "Alien Artifact", "Prototype AR9", "Chief Officers Laptop"]
var substances = ["Syn Fluid", "Alien Substance", "Xenon", "Substance 429", "Substance 298"]
var dataPorts = ["Science Data", "Engineering Data", "Security Data", "Medical Data", "Navigation Data"]
var creatures = ["Projectionist", "Stalker", "Cropper", "Unknown Entity", "Coercer"]
var rooms = ["Engineering", "Labs", "Deck", "Medical", "Storage Bay"]


func gen_task():
	var env = ""
	randomize()  # Seed the random number generator
	var random_index = randi() % taskTypes.size()
	var task = taskTypes.pick_random()
	if task == "Photograph":
		subject = (photoSpots + items + substances + creatures + rooms).pick_random()
		return task + " " + subject
	elif task == "Retrieve":
		subject = (items + substances + dataPorts).pick_random()
		return task + " " + subject
	elif task == "Destroy":
		subject = (items + substances + dataPorts).pick_random()
		return task + " " + subject + " (Collect proof of destruction)"
	elif task == "Capture":
		subject = creatures.pick_random()
		return task + " " + subject
	elif task == "Analyze":
		subject = rooms.pick_random()
		env = envMeasurements.pick_random() 
		return task + " " + subject + " " + env	
		
