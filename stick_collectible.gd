extends StaticBody2D

@export var item: InvItem
var player = null

# you left off on y-sorting of trees if you care
# about that or just skip ahead

func _on_pickable_area_body_entered(body):
	if body.has_method("player"):
		player = body
		playercollect()
		await get_tree().create_timer(0.1).timeout
		self.queue_free()

func playercollect():
	player.collect(item)
