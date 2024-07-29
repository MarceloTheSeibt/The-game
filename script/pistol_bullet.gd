extends RigidBody2D

var screen_size
var mob_hit
var velocity = Vector2.ZERO
var collided = false
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		if collision_info.get_collider().get_class() == "CharacterBody2D":
			mob_hit = get_node("/root/Main/" + str(collision_info.get_collider().get_name()))
			if mob_hit.health > 0:
				mob_hit.health -= 25
			self.queue_free()


		if !collided:
			$Change_layer_timer.start()
			$Despawn_timer.start()
			collided = true

# Tempo para desaparecer
func _on_despawn_timer_timeout():
	self.queue_free()

# Para as balas ricocheteadas não acertarem os mobs
func _on_change_layer_timer_timeout():
	self.set_collision_layer_value(2, false)

func _mob_hit():
	pass
