extends CharacterBody2D
signal mob_death

var health
var speed
var stunned = false
# Como não dá pra declarar delta, essa variável serve pra apontar para delta,
# pois têm funções que precisam dela
var deltaN

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 100
	speed = 200
	position = Vector2(1500, 500)
	$AnimatedSprite2D.play("walk")
	# Este signal faz o player avisar a sua posição para o mob a cada frame
	var player = get_node("/root/Main/Player_with_pistol/Player")
	player.player_position.connect(self._player_position)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deltaN = delta
	
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false


func _on_body_entered(body):
	# body nesse caso é a bullet, que deixa de existir quando atinge o mob
	if body is RigidBody2D:
		body.queue_free()
		health -= 25


	# A mecânica de stun pode ser melhorada
	if health <= 50 and health > 0:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("hurt")
		stunned = true
		$Stun_timer.start()


	# Se morrer:
	if health <= 0:
		$AnimatedSprite2D.stop()
		$LightOccluder2D.visible = false
		$AnimationPlayer.play("dying")
		$Area2D/Shot_hitbox.set_deferred("disabled", true)
		$World_hitbox.set_deferred("disabled", true)


func _on_dying_animation_finish(anim_name):
	if anim_name == "dying":
		$AnimationPlayer.stop()
		self.queue_free()
		mob_death.emit()


func _player_position(pos):
	if health > 0:
		if !stunned:
			var angle_to_player = self.get_angle_to(pos)
			velocity = Vector2(cos(angle_to_player), sin(angle_to_player))
			if velocity.length() > 0: 
				velocity = velocity.normalized()
			if deltaN is float:
				position += velocity * deltaN * speed


func _on_stun_timer_timeout():
	stunned = false
	if health > 0:
		$AnimatedSprite2D.play("walk")

