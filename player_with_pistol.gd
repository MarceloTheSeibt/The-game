extends Node2D
var pistol_flipped = false 


func _ready():
	pass



func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()  # Posição do mouse em relação ao (0, 0) da tela
	
	
	var arm_left_to_mouse = snapped($Player/arm_left.get_angle_to(mouse_pos), 0.01)
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



