extends CharacterBody2D

var hp := 500 
var attack_damage := 20
@export var speed := 75.0

# Status bangun/aktif (diubah oleh TriggerArena saat pintu tertutup)
var is_active := false 

@onready var hp_bar: ProgressBar = get_node_or_null("ProgressBar")
@onready var sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")
@onready var damage_area: Area2D = get_node_or_null("DamageArea") 

# Variabel untuk menarget player
var player: Node2D

func _ready() -> void:
	if hp_bar:
		hp_bar.max_value = hp
		hp_bar.value = hp
		
	# Cari player di dalam peta secara otomatis
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Jika Boss sudah aktif dan Player ditemukan
	if is_on_floor() and is_active and player != null:
		# 1. Cari arah player (Jika Player di kiri = -1, di kanan = 1)
		var direction = sign(player.global_position.x - global_position.x)
		
		# 2. Jalan menuju player
		velocity.x = direction * speed
		
		# 3. Hadapkan wajah boss ke arah player
		if sprite and direction != 0:
			sprite.flip_h = (direction < 0)
			sprite.play("walk_boss")
	
	# Jika boss belum bangun, diam di tempat
	elif is_on_floor() and not is_active:
		velocity.x = move_toward(velocity.x, 0, speed)
		if sprite: sprite.play("idle_boss")
				
	move_and_slide()
	
	# Logika melukai player (20 damage)
	if damage_area and is_active:
		var overlapping_bodies = damage_area.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body.is_in_group("player") and body.has_method("take_damage"):
				body.take_damage(attack_damage)

func take_damage(amount: int) -> void:
	if not is_active:
		return # Kebal jika belum bangun (opsional)
		
	hp -= amount
	if hp_bar: hp_bar.value = hp 
	
	if sprite:
		sprite.modulate = Color(1, 0, 0)
		var flash_tween = create_tween()
		flash_tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.2) 
	
	show_floating_damage(amount)
	
	if hp <= 0:
		die()

func show_floating_damage(amount: int) -> void:
	var text_node = Label.new()
	text_node.text = str(amount)
	text_node.modulate = Color(1, 0, 0) 
	text_node.position = Vector2(-20, -60) # Sesuaikan dengan tinggi boss
	add_child(text_node)
	
	var float_tween = create_tween()
	float_tween.tween_property(text_node, "position", text_node.position + Vector2(0, -40), 0.5)
	float_tween.parallel().tween_property(text_node, "modulate:a", 0.0, 0.5)
	float_tween.tween_callback(text_node.queue_free)

func die() -> void:
	# Nanti kita bisa isi dengan efek pintu terbuka kembali atau efek ledakan
	queue_free()
