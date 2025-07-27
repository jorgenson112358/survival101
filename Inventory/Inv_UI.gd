extends Control

@onready var inv: GameInv = preload("res://Inventory/PlayerInventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
var is_open = false

# We are at 11:45 of inventory part 1

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()
	
func update_slots():
	# print(inv.slots.size())
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
	
func _process(delta):
	if Input.is_action_just_pressed("i"):
		if is_open:
			close()
		else:
			open()
	
func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
