extends Area2D

export var verticalSpeed := 10.0
export var health: int = 10

func _ready():
	add_to_group("damageable")
	
func _physics_process(delta):
	position.y += verticalSpeed * delta

func damage(amount: int):
	health -= amount
	if health <= 0:
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
