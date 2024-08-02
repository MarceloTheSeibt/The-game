extends Node2D
@export var bullet_scene: PackedScene
signal shot

var pistol_flipped := false 
# Como não dá pra declarar delta, essa variável serve pra apontar para delta,
# pois têm funções que precisam dela
var deltaN: float  
var player: Node
var player_arm_left: Node
var player_gun_point_1: Node
var player_gun_point_2: Node


func _ready():
	$Fire_delay.start()
	player = get_node("/root/Main/Player")
	player_arm_left = get_node("/root/Main/Player/arm_left")
	player_gun_point_1 = get_node("/root/Main/Player/arm_left/gun_point")
	player_gun_point_2 = get_node("/root/Main/Player/arm_left/gun_point2")


func _process(delta):
	deltaN = delta

	# Usa o mesmo ângulo do braço utilizado. Como é uma pistola, só um braço se move.
	self.set_rotation(player_arm_left.get_rotation())
	
	if !pistol_flipped:
		# gun_point é a posição desejada da pistola
		# existe 1 para versão flipada da pistola e 1 para não flipada
		self.set_global_position(player_gun_point_1.get_global_position())
		# Enquanto não estiver flipada, se o ângulo for maior que 90 graus para a outra direção x:
		if self.get_global_rotation() >= PI / 2 or self.get_global_rotation() <= - PI / 2:
			# scale negativo é uma gambiarra para flipar o corpo, já que flip_v
			# só funciona em sprites
			self.set_scale(Vector2(self.get_scale()[0], - self.get_scale()[1]))
			pistol_flipped = true

	elif pistol_flipped:
		self.set_global_position(player_gun_point_2.get_global_position())
		# Enquanto estiver flipada, se o ângulo for maior que 90 graus para a outra direção x:
		if self.get_global_rotation() <= PI / 2 and self.get_global_rotation() >= - PI / 2:
			self.set_scale(Vector2(self.get_scale()[0], - self.get_scale()[1]))
			pistol_flipped = false


func _on_fire_delay_timeout():
	$pistol_skeleton/AnimationPlayer.play("shoot")
	var bullet := bullet_scene.instantiate()
	add_child(bullet)
	shot.emit(bullet)


func _on_pistol_shot(bullet):
	var pos: Vector2 = $bullet_point.get_global_position()
	var rot: float = $bullet_point.get_global_rotation()
	var bullet_speed := 600000
	bullet.set_global_position(pos)
	bullet.set_global_rotation(rot)
	# Direção da bala
	var bullet_direction := Vector2(cos(rot), sin(rot))
	bullet.apply_central_impulse(bullet_direction * bullet_speed * deltaN) 




