extends Area2D
@export var pistol_scene: PackedScene
@export var smg_scene: PackedScene

# Para que a arma que está segurando saiba a posição do player
signal arm_left_position
signal player_position
signal player_death

var health = 100
var on_death = true  # Controle da função de morte
var speed = 275
var screen_size
var weapon_equipped = "none"
var weapon_new

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position = Vector2(800, 500)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	var walk
	var idle
	var arm_left_pos = $arm_left.position  # Posição relativa
	arm_left_position.emit(arm_left_pos)
	
	if health > 0:
		# Posição absoluta
		$arm_left.set_global_position($player_skeleton/Skeleton2D/hip/body/arm_left.get_global_position())
		$arm_right.set_global_position($player_skeleton/Skeleton2D/hip/body/arm_right.get_global_position())
		
		# Snapped serve para arredondar float
		var arm_left_to_mouse = snapped($arm_left.get_angle_to(get_global_mouse_position()), 0.01)

		
		
		# Rotaciona os braços, seguindo o mouse
		if arm_left_to_mouse != 0.00:
			if weapon_equipped == "pistol":
				$arm_left.rotate(arm_left_to_mouse)
				$arm_right.hide()
			else:
				$arm_left.rotate(arm_left_to_mouse)
				$arm_right.show()
				$arm_right.set_global_rotation($arm_left.get_global_rotation())
		
		
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
		
		# Este signal faz o player avisar a sua posição para o mob a cada frame
		player_position.emit($player_skeleton.get_global_position())
		
	elif health <= 0 and on_death:
		on_death = false
		$player_skeleton/CollisionShape2D.set_deferred("disabled", true)
		$arm_left.hide()
		$arm_right.hide()
		$player_skeleton/polygons/arm_left.show()
		$player_skeleton/polygons/arm_right.show()
		$player_skeleton/AnimationPlayer.stop()
		$player_skeleton/AnimationPlayer.play("dying")
		player_death.emit($player_skeleton.get_global_position())
		if weapon_new != null:
			weapon_new.queue_free()
		else:
			pass


func add_pistol():
	# Se não tiver nenhuma arma: adiciona a escolhida
	# Se já tiver uma: deleta a atual e adiciona a nova
	# *Sujeito a alterações futuras*
	if weapon_equipped != "none":
		if weapon_new != null:
			weapon_new.queue_free()
			weapon_new = pistol_scene.instantiate()
			add_child(weapon_new)
	else:
		weapon_new = pistol_scene.instantiate()
		add_child(weapon_new)
		weapon_equipped = "pistol"


func add_smg():
	# Se não tiver nenhuma arma: adiciona a escolhida
	# Se já tiver uma: deleta a atual e adiciona a nova
	# *Sujeito a alterações futuras*
	if weapon_equipped != "none":
		if weapon_new != null:
			weapon_new.queue_free()
			weapon_new = smg_scene.instantiate()
			add_child(weapon_new)
	else:
		weapon_new = smg_scene.instantiate()
		add_child(weapon_new)
		weapon_equipped = "smg"



func _on_hit_highlight_timer_timeout():
	self.set_modulate(Color("#505050"))
