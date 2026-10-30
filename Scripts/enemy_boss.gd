extends CharacterBody2D

var hp := 200 
var attack_damage := 15
@export var speed := 75.0

# --- MODIFIKASI: VARIABEL UNTUK MEKANIK HIT AND RUN ---
@export var attack_cooldown := 2.0 # Jeda waktu sebelum Boss bisa menyerang lagi (detik)
@export var attack_delay := 0.4    # Jeda aba-aba (wind-up) sebelum pukulan mendarat (detik)
var can_attack := true             # Status penanda apakah Boss siap menyerang

var is_active := false 
var is_dead := false
var is_attacking := false

@onready var boss_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hp_bar: ProgressBar = get_node_or_null("ProgressBar")
@onready var damage_area: Area2D = get_node_or_null("DamageArea") 
@onready var collision_shape: CollisionShape2D = get_node_or_null("CollisionShape2D")

var player: Node2D

func _ready() -> void:
	add_to_group("enemy_boss")
	
	if hp_bar:
		hp_bar.max_value = hp
		hp_bar.value = hp

	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if is_dead:
		velocity.x = 0
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return

	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Jika sedang menyerang, abaikan pergerakan jalan sementara
	if is_attacking:
		velocity.x = move_toward(velocity.x, 0, speed)
		move_and_slide()
		return

	# Jika Boss sudah aktif dan Player ditemukan
	if is_on_floor() and is_active and player != null:
		var direction = sign(player.global_position.x - global_position.x)
		velocity.x = direction * speed
		
		if boss_animation and direction != 0:
			boss_animation.flip_h = (direction < 0)
			boss_animation.play("walk_boss")
	
	elif is_on_floor() and not is_active:
		velocity.x = move_toward(velocity.x, 0, speed)
		if boss_animation: 
			boss_animation.play("idle_boss")
				
	move_and_slide()
	
	# MODIFIKASI: Menambahkan syarat `can_attack`
	if damage_area and is_active and not is_dead and not is_attacking and can_attack:
		var overlapping_bodies = damage_area.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body.is_in_group("player") and body.has_method("take_damage"):
				perform_boss_attack(body)
				break

func take_damage(amount: int) -> void:
	if not is_active or is_dead:
		return # Kebal jika belum bangun atau sudah mati
		
	hp -= amount
	if hp_bar: 
		hp_bar.value = hp 
	
	if boss_animation:
		boss_animation.modulate = Color(1, 0, 0)
		var flash_tween = create_tween()
		flash_tween.tween_property(boss_animation, "modulate", Color(1, 1, 1), 0.2) 
	
	show_floating_damage(amount)
	
	if hp <= 0:
		die()

# --- MODIFIKASI UTAMA PADA FUNGSI SERANGAN ---
func perform_boss_attack(player_body: Node2D) -> void:
	# 1. Kunci status agar tidak terjadi spamming
	is_attacking = true
	can_attack = false
	velocity.x = 0 # Berhenti berjalan saat menyerang
	
	if boss_animation:
		boss_animation.play("attack_boss")
		
	# --- EFEK INDIKATOR WARNA MERAH (WIND-UP WARNING) ---
	if boss_animation:
		# Membuat animasi kedip merah cepat selama masa ancang-ancang (attack_delay)
		# Berkedip setiap 0.1 detik sekali
		var loop_count = max(1, int(attack_delay / 0.1))
		var warning_tween = create_tween().set_loops(loop_count)
		warning_tween.tween_property(boss_animation, "modulate", Color(1, 0.2, 0.2), 0.05) # Merah terang
		warning_tween.tween_property(boss_animation, "modulate", Color(1, 1, 1), 0.05)     # Normal kembali
	
	# 2. WIND-UP: Beri jeda aba-aba agar pemain bisa merespons (mundur/melompat)
	await get_tree().create_timer(attack_delay).timeout
	
	# Pastikan warna kembali normal jika boss mati di tengah ancang-ancang
	if is_dead:
		if boss_animation:
			boss_animation.modulate = Color(1, 1, 1)
		return
		
	# Pastikan warna normal sebelum memukul
	if boss_animation:
		boss_animation.modulate = Color(1, 1, 1)
		
	# 3. CEK ULANG: Hanya berikan damage JIKA player MASIH berada di dalam DamageArea
	if damage_area and damage_area.overlaps_body(player_body):
		if player_body.has_method("take_damage"):
			player_body.take_damage(attack_damage)
	
	# 4. Tunggu animasi serangan selesai diputar penuh
	if boss_animation and boss_animation.sprite_frames.has_animation("attack_boss"):
		await boss_animation.animation_finished
	else:
		await get_tree().create_timer(0.3).timeout
		
	is_attacking = false
	
	# 5. COOLDOWN: Beri jeda sebelum Boss diperbolehkan menyerang kembali
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func show_floating_damage(amount: int) -> void:
	var text_node = Label.new()
	text_node.text = str(amount)
	text_node.modulate = Color(1, 0, 0) 
	text_node.position = Vector2(-20, -60)
	add_child(text_node)
	
	var float_tween = create_tween()
	float_tween.tween_property(text_node, "position", text_node.position + Vector2(0, -40), 0.5)
	float_tween.parallel().tween_property(text_node, "modulate:a", 0.0, 0.5)
	float_tween.tween_callback(text_node.queue_free)

func die() -> void:
	is_dead = true
	velocity.x = 0
	velocity.y = 0
		
	if boss_animation:
		boss_animation.play("death_boss")
		
	await get_tree().create_timer(1.5).timeout
	queue_free()
