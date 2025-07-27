extends Panel

@onready var item_display: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_display: Label = $CenterContainer/Panel/Label

func update(slot: InvSlot):
	if !slot:
		item_display.visible = false
		amount_display.visible = false
	else:				
		if !slot.item:
			item_display.visible = false
			amount_display.visible = false
		else:
			item_display.texture = slot.item.texture
			item_display.visible = true
			if slot.amount > 1:
				amount_display.text = str(slot.amount)
				amount_display.visible = true
