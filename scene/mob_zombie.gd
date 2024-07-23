extends Area2D
signal mob_death

var health

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 100
	position = Vector2(1500, 500)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	# body nesse caso é a bullet
	body.queue_free()
	health -= 25
	# Se morrer:
	if health <= 0:
		mob_death.emit()
		self.queue_free()
