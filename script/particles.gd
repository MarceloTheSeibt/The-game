extends CPUParticles2D


func _ready():
	self.emitting = true
	var bullet = self.get_parent()
	$Lifetime_timer.start()


func _process(delta):
	pass


func _on_lifetime_timer_timeout():
	self.queue_free()
