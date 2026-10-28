extends CharacterBody2D

var hp := 100 
var attack_damage := 10

@export var speed := 50.0
@export var direction := 1 # 1 = Kanan, -1 = Kiri

var flip_cooldown := 0.0 
var is_dead := false 
var is_attacking := false # Mencegah animasi serangan berulang (looping)

@onready var kroco_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hp_bar: ProgressBar = get_node_or_null("ProgressBar")
@onready var damage_area: Area2D = get_node_or_null("DamageArea") 
@onready var ledge_check: RayCast2D = $LedgeCheck 
@onready var collision_shape: CollisionShape2D = get_node_or_null("CollisionShape2D")

func _ready() -> void:
	add_to_group("enemy_kroco")
	
	if hp_bar:
		hp_bar.max_value = hp
		hp_bar.value = hp
		
	if direction == -1:
		if kroco_animation: kroco_animation.flip_h = true
		if ledge_check: ledge_check.position.x *= -1

func _physics_process(delta: float) -> void:
	# 1. JIKA MATI: KELUAR SEPENUHNYA! (Tidak ada gravitasi, tidak bisa jatuh)
	if is_dead:
		return

	# 2. JIKA MENYERANG: Hentikan langkah, tapi tetap ada gravitasi
	if is_attacking:
		velocity.x = move_toward(velocity.x, 0, speed)
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return

	# 3. KONDISI NORMAL (Patroli)
	if flip_cooldown > 0:
		flip_cooldown -= delta

	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor():
		if (is_on_wall() or not ledge_check.is_colliding()) and flip_cooldown <= 0.0:
			direction *= -1 
			
			if kroco_animation:
				kroco_animation.flip_h = (direction < 0) 
				
			ledge_check.position.x = direction * abs(ledge_check.position.x)
			ledge_check.force_raycast_update()
			
			flip_cooldown = 0.3 
			
		velocity.x = direction * speed
				
	move_and_slide()
	
	# 4. LOGIKA SERANGAN KROCO
	if damage_area and not is_dead and not is_attacking:
		var overlapping_bodies = damage_area.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body.is_in_group("player") and body.has_method("take_damage"):
				perform_kroco_attack(body)
				break

func perform_kroco_attack(player_body: Node2D) -> void:
	is_attacking = true
	velocity.x = 0 
	
	if kroco_animation:
		kroco_animation.play("attack_enemy")
		
	player_body.take_damage(attack_damage)
	
	# Tunggu sampai animasi serangan tuntas
	if kroco_animation and kroco_animation.sprite_frames.has_animation("attack_enemy"):
		await kroco_animation.animation_finished
	else:
		await get_tree().create_timer(0.5).timeout
		
	is_attacking = false

func take_damage(amount: int) -> void:
	if is_dead:
		return 
		
	hp -= amount
	if hp_bar:
		hp_bar.value = hp 
	
	if kroco_animation:
		kroco_animation.modulate = Color(1, 0, 0)
		var flash_tween = create_tween()
		flash_tween.tween_property(kroco_animation, "modulate", Color(1, 1, 1), 0.2) 
	
	show_floating_damage(amount)
	
	if hp <= 0:
		die()

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

func die() -> void:
	is_dead = true 
	
	# Hentikan semua momentum paksa
	velocity = Vector2.ZERO 
	
	if hp_bar:
		hp_bar.visible = false # Sembunyikan darah saat mati agar lebih rapi
		
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
		
	if kroco_animation:
		# PENGATURAN UKURAN: Jika gambar masih membesar, ubah angka 0.6 di bawah ini menjadi lebih kecil (misal 0.4 atau 0.5)
		kroco_animation.scale = Vector2(0.1, 0.1) 
		kroco_animation.play("death_enemy")
		
	await get_tree().create_timer(1.5).timeout
	queue_free()
