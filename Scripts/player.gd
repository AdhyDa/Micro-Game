extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -250.0
var is_on_ladder := false
var is_climbing := false
const CLIMB_SPEED = 150.0

# Variabel Serangan
var is_attacking := false
var attack_damage := 25 # Jumlah damage yang diberikan ke musuh

@onready var player: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_jump: AudioStreamPlayer2D = $SfxJump
@onready var sfx_run: AudioStreamPlayer2D = $SfxRun
@onready var hitbox: Area2D = $Hitbox # Pastikan nama node sama dengan yang dibuat di langkah 2

func _physics_process(delta: float) -> void:
	
	# Handle Attack (Serangan)
	if Input.is_action_just_pressed("attack") and not is_attacking:
		perform_attack()

	# Jika sedang menyerang, hentikan pergerakan agar tidak meluncur kaku (Opsional)
	if is_attacking:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not is_climbing and not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return # Jangan jalankan kode jalan/lompat saat animasi serang berlangsung
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sfx_jump.play()

	# Get input direction
	var direction := Input.get_axis("move_left", "move_right")
	var climb_direction := Input.get_axis("move_up", "move_down")
	
	# Handle Climb
	if is_on_ladder and (Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down")):
		is_climbing = true
	
	if is_climbing:
		velocity.y = climb_direction * CLIMB_SPEED
		if is_on_floor() and climb_direction > 0:
			is_climbing = false
		if not is_on_ladder:
			is_climbing = false
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Handle Animation & Sfx
	if not is_climbing:
		if is_on_floor():
			if direction == 0:
				player.play("idle_player")
				sfx_run.stop()
			else:
				player.play("run_player")
				if not sfx_run.playing:
					sfx_run.pitch_scale = randf_range(0.8, 1.2)
					sfx_run.play()
		else:
			player.play("jump_player")
			sfx_run.stop()
	else:
		player.play("idle_player") 
		sfx_run.stop()

	# Handle flip karakter dan flip arah Hitbox
	if direction:
		player.flip_h = direction < 0
		velocity.x = direction * SPEED
		# Membalikkan posisi hitbox ke kiri atau ke kanan mengikuti arah hadap pemain
		hitbox.position.x = -abs(hitbox.position.x) if direction < 0 else abs(hitbox.position.x)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()


func _on_tangga_body_entered(body: Node2D) -> void:
	if body == self:
		is_on_ladder = true

func _on_tangga_body_exited(body: Node2D) -> void:
	if body == self:
		is_on_ladder = false
		is_climbing = false

func perform_attack() -> void:
	is_attacking = true
	player.play("attack_player") # Ganti dengan nama animasi seranganmu jika berbeda
	
	# Mendapatkan semua objek yang bersentuhan dengan Hitbox pemain
	var overlapping_bodies = hitbox.get_overlapping_bodies()
	for body in overlapping_bodies:
		# Jika yang disentuh masuk grup "enemy" dan punya fungsi take_damage
		if body.is_in_group("enemy") and body.has_method("take_damage"):
			print("Berhasil menyentuh anggota grup enemy!")
			if body.has_method("take_damage"):
				body.take_damage(attack_damage)
				print("Damage berhasil dikirim!")
			else:
				print("ERROR: Musuh tersentuh, tapi ia tidak punya script yang berisi fungsi take_damage().")
			
	# Tunggu sampai animasi serangan selesai sebelum bisa bergerak/menyerang lagi
	await player.animation_finished
	is_attacking = false
