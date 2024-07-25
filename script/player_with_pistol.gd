extends Node2D
@export var bullet_scene: PackedScene
signal shot

var pistol_flipped = false 
# Como não dá pra declarar delta, essa variável serve pra apontar para delta,
# pois têm funções que precisam dela
var deltaN  

func _ready():
	$fire_delay.start()

func _process(delta):
	deltaN = delta
	var arm_left_to_mouse = snapped($Player/arm_left.get_angle_to(get_global_mouse_position()), 0.01)
	# Snapped serve para arredondar float
	
	
	# Rotaciona os braços, seguindo o mouse
	# Ambos usam como parâmetro o mesmo braço, por questões de performance e
	# evita esquisitices causadas por ângulos
	if arm_left_to_mouse != 0.00:
		$Player/arm_left.rotate(arm_left_to_mouse)
		#$arm_right.rotate(arm_left_to_mouse)
		
		
	# Usa o mesmo ângulo do braço utilizado. Como é uma pistola, só um braço se move.
	$Player/Pistol.set_rotation($Player/arm_left.get_rotation())
	
	if !pistol_flipped:
		# gun_point é a posição desejada da pistola
		# existe 1 para versão flipada da pistola e 1 para não flipada
		$Player/Pistol.set_global_position($Player/arm_left/gun_point.get_global_position())
		# Enquanto não estiver flipada, se o ângulo for maior que 90 graus para a outra direção x:
		if $Player/Pistol.get_global_rotation() >= PI / 2 or $Player/Pistol.get_global_rotation() <= - PI / 2:
			# scale negativo é uma gambiarra para flipar o corpo, já que flip_v
			# só funciona em sprites
			$Player/Pistol.set_scale(Vector2($Player/Pistol.get_scale()[0], - $Player/Pistol.get_scale()[1]))
			pistol_flipped = true

	elif pistol_flipped:
		$Player/Pistol.set_global_position($Player/arm_left/gun_point2.get_global_position())
		# Enquanto estiver flipada, se o ângulo for maior que 90 graus para a outra direção x:
		if $Player/Pistol.get_global_rotation() <= PI / 2 and $Player/Pistol.get_global_rotation() >= - PI / 2:
			$Player/Pistol.set_scale(Vector2($Player/Pistol.get_scale()[0], - $Player/Pistol.get_scale()[1]))
			pistol_flipped = false


func _on_fire_delay_timeout():
	$Player/Pistol/pistol_skeleton/AnimationPlayer.play("shoot")
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	shot.emit(bullet)


func _on_pistol_shot(bullet):
	var pos = $Player/Pistol/bullet_point.get_global_position()
	var rot = $Player/Pistol/bullet_point.get_global_rotation()
	var bullet_speed = 500000
	bullet.set_global_position(pos)
	bullet.set_global_rotation(rot)
	# Direção da bala
	var bullet_direction = Vector2(cos(rot), sin(rot))
	bullet.apply_central_impulse(bullet_direction * bullet_speed * deltaN) 


