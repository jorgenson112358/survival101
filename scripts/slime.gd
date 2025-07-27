extends CharacterBody2D

var speed = 400
var health = 100
var dead = false
var player_in_area = false
var player

@onready var slime = $slime_collectible
@export var itemRes: InvItem

func _ready():
	dead = false
	
func _physics_process(delta):
	if !dead:
		$detection_area/CollisionShape2D.disabled = false
		if player_in_area:
			position += (player.position - position) / speed
			$AnimatedSprite2D.play("move")
		else:
			$AnimatedSprite2D.play("idle")
	else:
		$detection_area/CollisionShape2D.disabled = true
		

func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body


func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false


func _on_hitbox_area_entered(area):
	var damage
	if area.has_method("arrow_deal_damage"):
		# print("hitbox of slime entered")
		damage = 50
		take_damage(damage)
		area.destroyed()


func take_damage(dmg):
	health = health - dmg
	if health <= 0 and !dead:
		slime_death()

func slime_death():
	dead = true
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	drop_slime_collectible()
	
	$AnimatedSprite2D.visible = false
	$hitbox/CollisionShape2D.disabled = true
	$detection_area/CollisionShape2D.disabled = true
	
func drop_slime_collectible():
	slime.visible = true
	$area_init_player/CollisionShape2D.disabled = false
	slime_collect()
	
func slime_collect():
	await get_tree().create_timer(1.5).timeout
	slime.visible = false
	player.collect(itemRes)
	queue_free()



func _on_area_init_player_body_entered(body):
	if body.has_method("player"):
		player = body
		
