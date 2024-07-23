extends Area2D
# Para que a arma que está segurando saiba a posição do player
signal arm_left_position(pos: Vector2)

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
	var arm_left_pos = $arm_left.position
	arm_left_position.emit(arm_left_pos)
	
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
		
		
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO + Vector2(200, 300), screen_size - (Vector2(200, 300)))
	






func _on_body_entered(body):
	pass
