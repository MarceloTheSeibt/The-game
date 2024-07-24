extends Node
@export var mob_zombie_scene: PackedScene

var zombie_scene
# Called when the node enters the scene tree for the first time.
func _ready():
	$Zombie_spawn_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_zombies_spawn_timer_timeout():
	var zombie_new = mob_zombie_scene.instantiate()
	add_child(zombie_new)
	
	# Conexão do signal do mob_zombie com o main via código, pois cada mob é
	# instanciado durante o tempo de execução, não antes.
	var zombie = get_node("mob_zombie")
	zombie.mob_death.connect(self._on_mob_death)

func _on_mob_death():
	$Zombie_spawn_timer.start()