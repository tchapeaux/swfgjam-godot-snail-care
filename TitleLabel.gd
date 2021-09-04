extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start_fade_out():
	$Tween.interpolate_property(get_node('.'), "modulate",
		Color(1,1,1,1), Color(1,1,1,0), 2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 3)
	$Tween.start()
	
	yield(get_tree().create_timer(3), "timeout")
	$Area2D/CollisionShape2D.disabled = true

func _on_Tween_tween_all_completed():
	queue_free()
