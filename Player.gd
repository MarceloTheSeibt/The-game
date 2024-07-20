extends Area2D

var speed = 200
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	var walk
	var idle
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:  # Animação "walk"
		velocity = velocity.normalized() * speed
		idle = false
		if walk == false:
			$player_skeleton/AnimationPlayer.stop()  # Stop na animação de "idle"
			walk = true
		if velocity.x != 0 or velocity.y != 0:
			$player_skeleton/AnimationPlayer.play("walk", -1, 2.0)
	elif velocity.length() == 0:  # Animação "idle"
		walk = false
		if idle == false:
			$player_skeleton/AnimationPlayer.seek(0.0, true)
			$player_skeleton/AnimationPlayer.stop()  # Stop na animação de "walk"
			idle = true
		$player_skeleton/AnimationPlayer.play("idle", -1, 1.0)
	print(velocity)
		
		
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO + Vector2(200, 300), screen_size - (Vector2(200, 300)))
	
	var mouse_pos = get_viewport().get_mouse_position()  # Posição do mouse em relação ao (0, 0) da tela
	
	
	var arm_left_to_mouse = snapped($arm_left.get_angle_to(mouse_pos), 0.01)
	var arm_right_to_mouse = snapped($arm_right.get_angle_to(mouse_pos), 0.01)
	# Snapped serve para arredondar float
	
	
	# Rotaciona os braços, seguindo o mouse
	if arm_left_to_mouse != 0.00:
		$arm_left.rotate( arm_left_to_mouse)

	if arm_right_to_mouse != 0.00:
		$arm_right.rotate(arm_left_to_mouse)
		
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
