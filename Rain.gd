extends Node2D


var gravity = 3000
var speed = Vector2.ZERO

var will_die = false


# Called when the node enters the scene tree for the first time.
func _ready():
	speed.x = rand_range(500, 750)
	speed.y = 755


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed.y += gravity * delta
	
	position.x += speed.x * delta
	position.y += speed.y * delta
	
	rotation = speed.angle()


func _on_Area2D_area_entered(area):
	if not will_die:
		will_die = true
		gravity = 0
		speed = Vector2.ZERO
		$Area2D.collision_layer = 0
		$Area2D.collision_mask = 0
		rotation = 0
		$ColorRect.hide()
		$CPUParticles2D.emitting = true
		yield(get_tree().create_timer(2), "timeout")
		queue_free()
