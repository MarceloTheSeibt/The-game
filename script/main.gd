extends Node
@export var mob_zombie_scene: PackedScene
@export var pistol_scene: PackedScene
@export var bouncy_bullets_scene: PackedScene
@export var sharp_bullets_scene: PackedScene


var score := 0
var bouncy_bullets_active := false  # Teste, deixar false depois
var sharp_bullets_active := false


func _ready():
	$Zombie_spawn_timer.start()


func _process(delta):

	if bouncy_bullets_active:
		$HUD/Bouncy_bullets.text = "Bouncy Bullets: " + str(snapped($Bouncy_bullets_duration.get_time_left(), 0))
	if sharp_bullets_active:
		$HUD/Sharp_bullets.text = "Sharp Bullets: " + str(snapped($Sharp_bullets_duration.get_time_left(), 0))
	
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
	var zombie: Node
	var mob_spawn_location = $MobPath/MobSpawnLocation
	# Escolhe um local aleatório de spawn
	mob_spawn_location.progress_ratio = randf()
	var zombie_new := mob_zombie_scene.instantiate()
	zombie_new.position = mob_spawn_location.position
	zombie_new.set_modulate(Color("#505050"))
	add_child(zombie_new)
	
	# Conecta cada o Main a cada um dos zombies 
	for z in get_tree().get_nodes_in_group("zombies"):
		zombie = z
	zombie.zombie_death.connect(self._on_mob_death)
	zombie.zombie_hits_player.connect(self._on_player_hit_by_zombie)




func _on_mob_death(points, zombie_pos):
	# A quantidade de pontos que cada mob dá está no script dele
	score += points
	drop_powerup(zombie_pos)
	#$Zombie_spawn_timer.start()


func _on_player_hit_by_zombie(damage):
	$Player.health -= damage
	$Player.set_modulate(Color("#620000"))
	$Player/Hit_highlight_timer.start()
	
	
func drop_powerup(pos):
	var number := randi_range(1, 10)
	if number > 8:
		var pow_bouncy := bouncy_bullets_scene.instantiate()
		pow_bouncy.set_global_position(pos)
		add_child(pow_bouncy)
		pow_bouncy.picked_up.connect(self._on_power_up_picked_up)
	elif number < 3:
		var pow_sharp := sharp_bullets_scene.instantiate()
		pow_sharp.set_global_position(pos)
		add_child(pow_sharp)
		pow_sharp.picked_up.connect(self._on_power_up_picked_up)


func _on_power_up_picked_up(power_up_name):
	if power_up_name == "bouncy_bullets":
		bouncy_bullets_active = true
		$Bouncy_bullets_duration.start()
		$HUD/Bouncy_bullets.show()
	if power_up_name == "sharp_bullets":
		sharp_bullets_active = true
		$Sharp_bullets_duration.start()
		$HUD/Sharp_bullets.show()


func _on_bouncy_bullets_duration_timeout():
	bouncy_bullets_active = false
	$HUD/Bouncy_bullets.hide()


func _on_sharp_bullets_duration_timeout():
	sharp_bullets_active = false
	$HUD/Sharp_bullets.hide()
