extends CharacterBody2D

var speed = 100
var player_state
var is_bow_equipped = false
var bow_cooldown = true
var bow_cooldown_time = 0.4
var arrow = preload("res://Scenes/arrow.tscn")
var mouse_location_from_player = null
var multi_arrow_spread_count = 4
var multi_arrow_spread_angle = 5
@export var inv: GameInv

func _physics_process(delta):
	mouse_location_from_player = get_global_mouse_position() - self.position
	# print(mouse_location_from_player)
	
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
	
	velocity = direction * speed
	move_and_slide()
	
	if Input.is_action_just_pressed(("e")):
		if is_bow_equipped:
			is_bow_equipped = false
		else:
			is_bow_equipped = true
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	if Input.is_action_just_pressed("leftmouse") and is_bow_equipped and bow_cooldown:
		bow_cooldown = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		add_child(arrow_instance)
		
		for i in multi_arrow_spread_count:
			var angle = multi_arrow_spread_angle
			if i > 0 and i % 2 == 1:
				angle = angle * -1
			
			if i > 1:
				angle = multi_arrow_spread_angle * ( (i / 2) + 1)
				print(i)
				print((i/2) + 1)
			
			var arrow_instance2 = arrow.instantiate()
			arrow_instance2.rotation_degrees = $Marker2D.rotation_degrees + angle
			arrow_instance2.global_position = $Marker2D.global_position
			add_child(arrow_instance2)

		await get_tree().create_timer(bow_cooldown_time).timeout
		bow_cooldown = true
	
	play_anim(direction)
	
func play_anim(dir):
	if !is_bow_equipped:
		if player_state == "idle":
			$AnimatedSprite2D.play("idle")
		if player_state == "walking":
			if dir.y == -1:
				$AnimatedSprite2D.play("n-walk")
			if dir.x == 1:
				$AnimatedSprite2D.play("e-walk")
			if dir.y == 1:
				$AnimatedSprite2D.play("s-walk")
			if dir.x == -1:
				$AnimatedSprite2D.play("w-walk")
				
			if dir.x > 0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("ne-walk")
			if dir.x > 0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("se-walk")
			if dir.x < -0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("sw-walk")
			if dir.x < -0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("nw-walk")
	else:
		if mouse_location_from_player.x >= -25 and mouse_location_from_player.x <= 25 and mouse_location_from_player.y < 0:
			$AnimatedSprite2D.play("n-attack")
		if mouse_location_from_player.y >= -25 and mouse_location_from_player.y <= 25 and mouse_location_from_player.x > 0:
			$AnimatedSprite2D.play("e-attack")
		if mouse_location_from_player.x >= -25 and mouse_location_from_player.x <= 25 and mouse_location_from_player.y > 0:
			$AnimatedSprite2D.play("s-attack")
		if mouse_location_from_player.y >= -25 and mouse_location_from_player.y <= 25 and mouse_location_from_player.x < 0:
			$AnimatedSprite2D.play("w-attack")
			
		if mouse_location_from_player.x >= 25 and mouse_location_from_player.y <= -25:
			$AnimatedSprite2D.play("ne-attack")
		if mouse_location_from_player.x >= 15 and mouse_location_from_player.y >= 25:
			$AnimatedSprite2D.play("se-attack")
		if mouse_location_from_player.x <= -15 and mouse_location_from_player.y >= 25:
			$AnimatedSprite2D.play("sw-attack")
		if mouse_location_from_player.x <= -25 and mouse_location_from_player.y <= -25:
			$AnimatedSprite2D.play("nw-attack")

# this is a simple object used in apple tree
# to check if player has entered or left the pickable_area
# there's probably some metadata we can mark up the player
# game object with to make it the player and check that but this
# appears to work too
func player():
	pass

func collect(item):
	inv.insert(item)

func bowSpeedPowerup(newSpeed):
	bow_cooldown_time = 0.1
