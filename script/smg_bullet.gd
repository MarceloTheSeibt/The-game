extends RigidBody2D

var screen_size
var mob_hit
var velocity = Vector2.ZERO
var collided = false
var main
# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_node("/root/Main")
	screen_size = get_viewport_rect().size
	$Despawn_no_hit_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	#$Tracer.scale.x += (abs(linear_velocity.x) + abs(linear_velocity.y)) / 10000
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal())
		
		if linear_velocity.x < 0:
			self.scale.x = - scale.x
		# Rotacionar a bala: (arco tangente)
		set_global_rotation(atan(linear_velocity.y / linear_velocity.x))
		
		#$Tracer.scale.x = 0.1
		if collision_info.get_collider().get_class() == "CharacterBody2D":
			mob_hit = get_node("/root/Main/" + str(collision_info.get_collider().get_name()))
			if mob_hit.health > 0:
				mob_hit.health -= 15
			self.queue_free()  # Caso atinja um zombie
		if !main.bouncy_bullets_active:
			self.queue_free()  # Caso não esteja ativo o powerup




func _mob_hit():
	pass


# Caso não colida com nada
func _on_despawn_no_hit_timer_timeout():
	self.queue_free()
