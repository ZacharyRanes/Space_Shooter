extends Area2D
class_name Enemy

var plBullet := preload("res://Bullet/EnemyBullet.tscn")
var plEnemyExplosion := preload("res://Enemy/EnemyExplosion.tscn")

onready var firingPositions := $FiringPositions

export var verticalSpeed := 10.0
export var health: int = 10

onready var points: int = 1

var playerInArea: Player = null

func _ready():
	add_to_group("damageable")

func _process(delta):
	if playerInArea != null:
		playerInArea.damage(1)

func _physics_process(delta):
	position.y += verticalSpeed * delta

func damage(amount: int):
	if health <= 0:
		return
	health -= amount
	if health <= 0:
		var effect := plEnemyExplosion.instance()
		effect.global_position = global_position
		get_tree().current_scene.add_child(effect)
		Signals.emit_signal("on_score_increment", points)
		queue_free()

func fire():
	for gun in firingPositions.get_children():
		var bullet := plBullet.instance()
		bullet.global_position = gun.global_position
		get_tree().current_scene.add_child(bullet)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Enemy_area_entered(area):
	if area is Player:
		playerInArea = area

func _on_Enemy_area_exited(area):
	if area is Player:
		playerInArea = null
