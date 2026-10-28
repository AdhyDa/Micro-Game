extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -250.0
var is_on_ladder := false
var is_climbing := false
const CLIMB_SPEED = 150.0

# Variabel Serangan & Status
var is_attacking := false
var attack_damage := 25 
var hp := 100
var is_invincible := false 
var is_dead := false # <--- TAMBAHAN: Status untuk mendeteksi apakah player sudah mati


@onready var player: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_jump: AudioStreamPlayer2D = $SfxJump
@onready var sfx_run: AudioStreamPlayer2D = $SfxRun
@onready var hitbox: Area2D = $Hitbox
@onready var hp_bar: ProgressBar = get_node_or_null("ProgressBar")
@onready var backsound: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var sfx_death: AudioStreamPlayer2D = $SfxDeath

func _ready() -> void:
	add_to_group("player") 
	if hp_bar:
		hp_bar.max_value = hp
		hp_bar.value = hp

func _physics_process(delta: float) -> void:
	# <--- TAMBAHAN: Jika sudah mati, abaikan semua tombol dan hentikan pergerakan
	if is_dead:
		velocity.x = 0
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return

	if Input.is_action_just_pressed("attack") and not is_attacking:
		perform_attack()

	if is_attacking:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not is_climbing and not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return 
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sfx_jump.play()

	var direction := Input.get_axis("move_left", "move_right")
	var climb_direction := Input.get_axis("move_up", "move_down")
	
	if is_on_ladder and (Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down")):
		is_climbing = true
	
	if is_climbing:
		if climb_direction != 0:
			velocity.y = climb_direction * CLIMB_SPEED
		else:
			velocity += get_gravity() * delta
		if is_on_floor() and climb_direction > 0:
			is_climbing = false
		if not is_on_ladder:
			is_climbing = false
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta	

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

	if direction:
		player.flip_h = direction < 0
		velocity.x = direction * SPEED
		hitbox.position.x = -abs(hitbox.position.x) if direction < 0 else abs(hitbox.position.x)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

func perform_attack() -> void:
	is_attacking = true
	player.play("attack_player") 
	
	var overlapping_bodies = hitbox.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("enemy_kroco") and body.has_method("take_damage"):
			body.take_damage(attack_damage)
			
	await player.animation_finished
	is_attacking = false

func take_damage(amount: int) -> void:
	if is_invincible or is_dead: # Jangan terima damage lagi jika sudah mati
		return 
		
	hp -= amount
	if hp_bar:
		hp_bar.value = hp
		
	player.modulate = Color(1, 0, 0)
	var flash_tween = create_tween()
	flash_tween.tween_property(player, "modulate", Color(1, 1, 1), 0.2)
	
	show_floating_damage(amount)
	
	if hp <= 0:
		die()
	else:
		is_invincible = true
		await get_tree().create_timer(1.0).timeout
		is_invincible = false

func show_floating_damage(amount: int) -> void:
	var text_node = Label.new()
	text_node.text = str(amount)
	text_node.modulate = Color(1, 0, 0)
	text_node.position = Vector2(-10, -30)
	add_child(text_node)
	
	var float_tween = create_tween()
	float_tween.tween_property(text_node, "position", text_node.position + Vector2(0, -40), 0.5)
	float_tween.parallel().tween_property(text_node, "modulate:a", 0.0, 0.5)
	float_tween.tween_callback(text_node.queue_free)

# --- MODIFIKASI UTAMA PADA FUNGSI DIE ---
func die() -> void:
	is_dead = true # Kunci semua input dan pergerakan
	sfx_run.stop()
	backsound.stop()
	sfx_death.play()
	# Putar animasi kematian yang sudah kamu buat
	player.play("death_player")
	
	# Hentikan kecepatan horisontal agar langsung berhenti di tempat
	velocity.x = 0 
	
	# Buat jeda waktu (timer) selama 2 detik sebelum merestart game
	await get_tree().create_timer(2.0).timeout
	
	# Restart level dari awal
	get_tree().reload_current_scene()

func _on_tangga_body_entered(body: Node2D) -> void:
	if body == self:
		is_on_ladder = true

func _on_tangga_body_exited(body: Node2D) -> void:
	if body == self:
		is_on_ladder = false
		is_climbing = false

# Fungsi untuk menambah darah saat mengambil item
func heal(amount: int) -> void:
	# Batasi maksimal HP agar tidak melebihi 100 (atau sesuaikan batas maksimalmu)
	hp = min(hp + amount, 100) 
	
	if hp_bar:
		hp_bar.value = hp
		
	print("Player memakan apel! HP bertambah, sisa HP: ", hp)
	
	
