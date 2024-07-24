extends RigidBody2D

var screen_size
var velocity = Vector2(200, 200)
var collided = false
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info and !collided:
		$Change_layer_timer.start()
		$Despawn_timer.start()
		collided = true

# Tempo para desaparecer
func _on_despawn_timer_timeout():
	self.queue_free()


# Para as balas ricocheteadas não acertarem os mobs
func _on_change_layer_timer_timeout():
	self.set_collision_layer_value(3, false)
