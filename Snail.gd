extends Node2D

signal hit
signal win

export var min_speed = -25
export var max_speed = 70

var speed = Vector2.ZERO;
var viewport_rec
var has_emitted_win = false

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_rec = get_viewport_rect().size
	position.x = 0
	speed.x = 0
	$AnimatedSprite.animation = "idle"
	$AnimatedSprite.speed_scale = 1

func start_or_restart():
	print("ok let's go")
	position.x = 0
	speed.x = 0
	$AnimatedSprite.animation = "idle"
	$AnimatedSprite.speed_scale = 1
	$AnimatedSprite.flip_h = false
	$NewBehaviorTimer.start(5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_in_safe_zone():
		if (not has_emitted_win):
			speed.x = 0
			$AnimatedSprite.animation = "sleep"
			$AnimatedSprite.speed_scale = .7
			return make_win()
	else:
		position.x += speed.x * delta
		position.x = max(0, position.x)

func is_in_safe_zone():
	return position.x > viewport_rec.x * .95

func make_win():
	emit_signal("win")
	has_emitted_win = true

func _on_Area2D_area_entered(area):
	print(area)
	if area.is_in_group("drops"):
		print("!hit")
		$ItHurtsFx.stop()
		$ItHurtsFx.play(0.07)
		if not is_in_safe_zone():
			emit_signal("hit")
			start_or_restart()
	else:
		print("not a drop")


func _on_NewBehaviorTimer_timeout():
	print("new behavior timeout!")
	if $AnimatedSprite.animation == "idle":
		# Choose a new direction/speed
		print("=> Go for it")
		var lower_bound = min_speed
		if position.x < viewport_rec.x / 4 or position.x > viewport_rec.x * 3 /4:
			# Don't go backwards if close to the start or the finish
			lower_bound = 0
		speed.x = rand_range(lower_bound, max_speed)
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.speed_scale = 4
		$AnimatedSprite.flip_h = speed.x < 0
		var walkDuration = rand_range(2, 5)
		$NewBehaviorTimer.start(walkDuration)
	
	elif $AnimatedSprite.animation == "walk":
		# Stop a bit
		print("=> Wait a bit")
		speed.x = 0
		$AnimatedSprite.animation = "idle"
		$AnimatedSprite.speed_scale = 1
		var waitDuration = rand_range(1, 2)
		$NewBehaviorTimer.start(waitDuration)

