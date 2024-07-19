extends Area2D

var speed = 200
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$player_skeleton/AnimationPlayer.play("walk", -1, 2.0)
	else:
		$player_skeleton/AnimationPlayer.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO + Vector2(200, 300), screen_size - (Vector2(200, 300)))
	
	if velocity.x != 0:
		pass
		#$player_skeleton/AnimationPlayer.play("walk", -1, 2.0)
		#$player_skeleton/AnimationPlayer.flip_v = false
		
		#if velocity.x < 0:
			#$player_skeleton/AnimationPlayer.flip_h = true
		#else:
			#$player_skeleton/AnimationPlayer.flip_h = false
	#elif velocity.y != 0:
		#$player_skeleton/AnimationPlayer.animation = "up"
		#if velocity.y > 0:
			#$player_skeleton/AnimationPlayer.flip_v = true
		#else:
			#$player_skeleton/AnimationPlayer.flip_v = false


func _on_body_entered(body):
	pass
