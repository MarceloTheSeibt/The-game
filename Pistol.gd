extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Garante que sempre começará pelo primeiro sprite (vazio)
	$pistol_skeleton/muzzle_smoke.set_frame_and_progress(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if Input.is_action_pressed("shoot"):
		$pistol_skeleton/AnimationPlayer.play("shoot")

