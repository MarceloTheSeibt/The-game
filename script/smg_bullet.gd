extends RigidBody2D

var screen_size: Vector2
var mob_hit: Node
var velocity := Vector2.ZERO
var collided := false
var damage := 15
var main: Node


func _ready():
	main = get_node("/root/Main")
	screen_size = get_viewport_rect().size
	$Despawn_no_hit_timer.start()
	if main.sharp_bullets_active:
		set_collision_layer_value(2, true)
		$Trail_bullet.set_default_color(Color(255, 0, 0))


func _physics_process(delta):

	var collision_info := move_and_collide(velocity * delta)
	if collision_info:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal())
		
		if linear_velocity.x < 0:
			self.scale.x = - scale.x
		# Rotacionar a bala: (arco tangente)
		set_global_rotation(atan(linear_velocity.y / linear_velocity.x))
		
		if collision_info.get_collider().get_class() == "CharacterBody2D":
			mob_hit = get_node("/root/Main/" + str(collision_info.get_collider().get_name()))
			if mob_hit.health > 0:
				mob_hit.health -= damage
				
		if !main.bouncy_bullets_active:
			self.queue_free()  # Caso não esteja ativo o powerup




func _mob_hit():
	pass


# Caso não colida com nada
func _on_despawn_no_hit_timer_timeout():
	self.queue_free()
