extends StaticBody2D

var player = null
const bow_speed = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player = body
		playerPowerup()
		await get_tree().create_timer(0.1).timeout
		self.queue_free()

func playerPowerup():
	player.bowSpeedPowerup(bow_speed)
