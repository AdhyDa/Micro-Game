extends CharacterBody2D

var hp := 100 
var attack_damage := 10

@export var speed := 50.0
@export var direction := 1 # 1 = Kanan, -1 = Kiri

# Tambahkan variabel cooldown ini
var flip_cooldown := 0.0 

@onready var hp_bar: ProgressBar = get_node_or_null("ProgressBar")
@onready var sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")
@onready var damage_area: Area2D = get_node_or_null("DamageArea") 
@onready var ledge_check: RayCast2D = $LedgeCheck 

func _ready() -> void:
	if hp_bar:
		hp_bar.max_value = hp
		hp_bar.value = hp
		
	if direction == -1:
		if sprite: sprite.flip_h = true
		ledge_check.position.x *= -1

func _physics_process(delta: float) -> void:
	# Kurangi waktu cooldown setiap frame
	if flip_cooldown > 0:
		flip_cooldown -= delta

	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor():
		# Tambahkan syarat "flip_cooldown <= 0.0" agar ia tidak bisa berputar terus-terusan
		if (is_on_wall() or not ledge_check.is_colliding()) and flip_cooldown <= 0.0:
			direction *= -1 
			
			if sprite:
				sprite.flip_h = (direction < 0) 
				
			ledge_check.position.x = direction * abs(ledge_check.position.x)
			ledge_check.force_raycast_update()
			
			# Berikan jeda 0.3 detik sebelum musuh boleh berbalik arah lagi
			flip_cooldown = 0.3 
			
		velocity.x = direction * speed
				
	move_and_slide()
	
	# Logika melukai player
	if damage_area:
		var overlapping_bodies = damage_area.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body.is_in_group("player") and body.has_method("take_damage"):
				body.take_damage(attack_damage)

func take_damage(amount: int) -> void:
	hp -= amount
	if hp_bar:
		hp_bar.value = hp 
	
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
	text_node.position = Vector2(-10, -30) 
	add_child(text_node)
	
	var float_tween = create_tween()
	float_tween.tween_property(text_node, "position", text_node.position + Vector2(0, -40), 0.5)
	float_tween.parallel().tween_property(text_node, "modulate:a", 0.0, 0.5)
	float_tween.tween_callback(text_node.queue_free)

func die() -> void:
	queue_free()
