extends Area2D
class_name Player

var plBullet := preload("res://Bullet/Bullet.tscn")

onready var animatedSprite := $AnimatedSprite
onready var firingPositions := $FiringPositions
onready var fireDelayTimer := $FireDelayTimer
onready var invincibilityTimer := $InvincibilityTimer
onready var shieldSprite := $Shield

export var speed: float = 100
export var fireDelay: float = 0.15
export var life: int = 3
export var damageInvincibilityTimer := 2
var vel := Vector2(0,0)

func _ready():
	shieldSprite.visible = false
	Signals.emit_signal("on_player_life_changed", life)

func _process(delta):
	if vel.x < 0:
		animatedSprite.play("Left")
	elif vel.x > 0:
		animatedSprite.play("Right")
	else:
		animatedSprite.play("Straight")
	
	if Input.is_action_pressed("shoot") and fireDelayTimer.is_stopped():
		fireDelayTimer.start(fireDelay)
		for gun in firingPositions.get_children():
			var bullet := plBullet.instance()
			bullet.global_position = gun.global_position
			get_tree().current_scene.add_child(bullet)

func _physics_process(delta):
	var dirVec := Vector2(0,0)
	
	if Input.is_action_pressed("move_left"):
		dirVec.x = -1
	elif Input.is_action_pressed("move_right"):
		dirVec.x = 1
	if Input.is_action_pressed("move_up"):
		dirVec.y = -1
	elif Input.is_action_pressed("move_down"):
		dirVec.y = 1
	
	vel = dirVec.normalized() * speed	
	position += vel * delta
	
	var viewRect := get_viewport_rect()
#	position.x = clamp(position.x, 0, viewRect.size.x)
	position.x = clamp(position.x, viewRect.position.x, viewRect.end.x)
	position.y = clamp(position.y, viewRect.position.y, viewRect.end.y)

func damage(amount: int):
	if !invincibilityTimer.is_stopped():
		return
	invincibilityTimer.start(damageInvincibilityTimer)
	shieldSprite.visible = true
	life -= amount
	Signals.emit_signal("on_player_life_changed", life)
	if life <= 0:
		print("PLAYER DIED")
		queue_free()

func _on_InvincibilityTimer_timeout():
	shieldSprite.visible = false
