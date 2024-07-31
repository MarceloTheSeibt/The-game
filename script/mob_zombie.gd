extends CharacterBody2D
signal zombie_death(score: int, position: Vector2)
signal mob_hit
signal zombie_hits_player(damage: float)

var health
var prev_health  # Vida no frame anterior
var speed
var trying_to_get_in = true
var score_to_player = 100
var damage_to_player = 20
var hit_on_cooldown = false
# Início das variáveis de controle do engatinhar do zombie:
# As hitboxes se movem junto das animações.
var crawl_speed = null
var crawl_timer_off = true
var getting_up
# Fim das variáveis de controle do engatinhar do zombie
var stunned = false
# Como não dá pra declarar delta, essa variável serve pra apontar para delta,
# pois têm funções que precisam dela
var deltaN

func _ready():
	health = 100
	prev_health = health
	speed = 100
	$AnimatedSprite2D.play("walk")
	# Este signal faz o player avisar a sua posição para o mob a cada frame
	var player = get_node("/root/Main/Player")
	player.player_position.connect(self._player_position)
	# Este é para os mobs saberem a posição da(s) entrada(s)
	var room = get_node("/root/Main/Room")
	room.window_pos.connect(self._window_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	deltaN = delta
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
	var collision_info = move_and_collide(velocity * delta)
	
	if health < prev_health:
		# Efeito "tomou um hit"
		self.set_modulate(Color("#620000"))
		$Hit_highlight_timer.start()
		if health <= 50 and health > 0:
			$AnimatedSprite2D.stop()
			$AnimatedSprite2D.play("hurt")
			stunned = true
			$Stun_timer.start()


		# Se morrer:
		if health <= 0:
			# 100 pontos por kill
			zombie_death.emit(score_to_player, self.get_global_position())
			$zombie_skeleton.visible = false
			$AnimatedSprite2D.visible = true
			$zombie_skeleton/AnimationPlayer2.stop()
			$AnimatedSprite2D.stop()
			$LightOccluder2D.visible = false
			$AnimationPlayer.play("dying")
			$Shot_hitbox.set_deferred("disabled", true)
			$World_hitbox.set_deferred("disabled", true)
		prev_health = health


	if collision_info:
		#print(collision_info.get_collider().get_name())
		# Se o zombie colidir com a hitbox da janela:
		if collision_info.get_collider().get_name() == "Hitbox_mob_in":
		# Gambiarra alert: quando o zombie deita para engatinhar, na verdade é outro corpo,
		# mas continua sendo o mesmo objeto então não tem problema
			if trying_to_get_in:
				$zombie_skeleton.visible = true
				$AnimatedSprite2D.visible = false
				self.set_collision_layer_value(8, false)
				self.set_collision_mask_value(8, false)
				$zombie_skeleton/AnimationPlayer2.play("lay_down")
				trying_to_get_in = false
		# Se colidir com o player: causa o dano especificado e entra em cooldown
		if !hit_on_cooldown:
			if collision_info.get_collider().get_name() == "player_skeleton":
				$Hit_cooldown.start()
				zombie_hits_player.emit(damage_to_player)
				hit_on_cooldown = true
			

func _on_dying_animation_finish(anim_name):
	if anim_name == "dying":
		$AnimationPlayer.stop()
		self.queue_free()



func _player_position(pos):
	# O código abaixo tem que ser refatorado, tá uma bagunça
	if health > 0:

		# Se não estiver stunado e já estiver na casa, segue o player e se move
		if !stunned and !trying_to_get_in:
			var angle_to_player = self.get_angle_to(pos)
			velocity = Vector2(cos(angle_to_player), sin(angle_to_player))
			if velocity.length() > 0: 
				velocity = velocity.normalized()
				
			# deltaN no primeiro frame é null, por isso esse if
			if deltaN is float:
				# crawl_speed = null quando está de pé
				if crawl_speed is int:
					position += velocity * deltaN * crawl_speed
				# Pra não ficar resetando o timer:
				if crawl_speed is int and crawl_timer_off:
					$zombie_skeleton/Crawl_timer.start()
					crawl_timer_off = false
				# Pra quando não estiver engatinhando:
				elif !crawl_speed is int:  # else não funciona aqui por algum motivo
					position += velocity * deltaN * speed


func _on_stun_timer_timeout():
	stunned = false
	if health > 0:
		$AnimatedSprite2D.play("walk")


func _on_animation_player_2_animation_finished(anim_name):
	if anim_name == "lay_down" and !getting_up:
		crawl_speed = 10
		$zombie_skeleton/AnimationPlayer2.stop()
		$zombie_skeleton/AnimationPlayer2.play("crawl")
	elif anim_name == "lay_down" and getting_up:
		$zombie_skeleton.visible = false
		$AnimatedSprite2D.visible = true


func _on_crawl_timer_timeout():
	$Reenable_world_hitbox_timer.start()
	# Para parar de engatinhar:
	crawl_speed = null
	$zombie_skeleton/AnimationPlayer2.stop()
	# A animação de se levantar é a de deitar tocado ao contrário
	$zombie_skeleton/AnimationPlayer2.play_backwards("lay_down")
	# Variável para saber se está deitando ou levantando
	getting_up = true


# Para evitar de colidir várias vezes com a mesma hitbox (pensar em alternativas)
func _on_reenable_world_hitbox_timer_timeout():
	$World_hitbox.set_deferred("disabled", false)


func _window_position(win_pos):
	# Se o zombie estiver vivo, não stunado e do lado de fora:
	if trying_to_get_in and !stunned and health > 0:
		if deltaN is float:
			var angle_to_in = self.get_angle_to(win_pos)
			velocity = Vector2(cos(angle_to_in), sin(angle_to_in))
			if velocity.length() > 0: 
				velocity = velocity.normalized()
				position += velocity * deltaN * speed


func _on_hit_highlight_timer_timeout():
	# Cor padrão para o level teste
	self.set_modulate(Color("#505050"))

# Cooldown para cada hit do zombie
func _on_hit_cooldown_timeout():
	hit_on_cooldown = false

