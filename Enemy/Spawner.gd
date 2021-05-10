extends Node2D

const MIN_SPAWN_TIME = 1.0

var preloadedEnemies := [
	preload("res://Enemy/FastEnemy.tscn"),
	preload("res://Enemy/SlowShooterEnemy.tscn"),
	preload("res://Enemy/BouncerEnemy.tscn")
]
var plMeteor := preload("res://Meteor/Meteor.tscn")

onready var spawnTimer := $SpawnTimer

var nextSpawnTime := 5.0

func _ready():
	randomize()
	spawnTimer.start(nextSpawnTime)

func _on_SpawnTimer_timeout():
	var viewRect := get_viewport_rect()
	var xPos := rand_range(viewRect.position.x, viewRect.end.x)
	
	if randf() < 0.2:
		var meteor: Meteor = plMeteor.instance()
		meteor.position = Vector2(xPos, position.y)
		get_tree().current_scene.add_child(meteor)
	else:
		var enemyPreload = preloadedEnemies[randi() % preloadedEnemies.size()]
		var enamy: Enemy = enemyPreload.instance()
		enamy.position = Vector2(xPos, position.y)
		get_tree().current_scene.add_child(enamy)
	
	if nextSpawnTime > MIN_SPAWN_TIME:
		nextSpawnTime -= 0.1
	spawnTimer.start(nextSpawnTime)
