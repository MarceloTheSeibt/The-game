extends Node
@export var mob_zombie_scene: PackedScene
@export var pistol_scene: PackedScene


var zombie_scene
var pistol_new
var score = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Zombie_spawn_timer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$HUD/Player_health.text = str($Player.health)
	if $Player.health <= 0:
		$HUD/Player_health.hide()
		$HUD/Score.hide()
	# Se o player estiver na hitbox de compra da pistola:
	if $Room/Buy_pistol.overlaps_body($Player/player_skeleton):
		$HUD/Buy_pistol.show()
		if Input.is_action_just_pressed("interact"):
			$Player.add_pistol()

	else:
		$HUD/Buy_pistol.hide()
		
	if $Room/Buy_smg.overlaps_body($Player/player_skeleton):
		$HUD/Buy_smg.show()
		if Input.is_action_just_pressed("interact"):
			$Player.add_smg()
	else:
		$HUD/Buy_smg.hide()
		
	$HUD/Score.text = str(score)


func _on_zombies_spawn_timer_timeout():
	var zombie
	var mob_spawn_location = $MobPath/MobSpawnLocation
	# Escolhe um local aleatório de spawn
	mob_spawn_location.progress_ratio = randf()
	var zombie_new = mob_zombie_scene.instantiate()
	zombie_new.position = mob_spawn_location.position
	zombie_new.set_modulate(Color("#505050"))
	add_child(zombie_new)
	
	# Conecta cada o Main a cada um dos zombies 
	for z in get_tree().get_nodes_in_group("zombies"):
		zombie = z
	zombie.zombie_death.connect(self._on_mob_death)
	zombie.zombie_hits_player.connect(self._on_player_hit_by_zombie)




func _on_mob_death(points):
	# A quantidade de pontos que cada mob dá está no script dele
	score += points
	#$Zombie_spawn_timer.start()


func _on_player_hit_by_zombie(damage):
	$Player.health -= damage
	$Player.set_modulate(Color("#620000"))
	$Player/Hit_highlight_timer.start()
