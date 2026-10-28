extends Area2D

# Variabel ini akan muncul di Inspector. 
# Seret node ArenaCamera, PintuBoss, dan EnemyBoss dari Scene Tree ke dalam Inspector TriggerArena!
@export var arena_camera: Camera2D
@export var pintu_boss: StaticBody2D
@export var boss: CharacterBody2D

var has_triggered := false

func _ready() -> void:
	# Sembunyikan pintu tinggi di atas langit-langit pada awal permainan
	if pintu_boss:
		pintu_boss.position.y -= 250 
		pintu_boss.visible = false

func _on_body_entered(body: Node2D) -> void:
	# Jika player menyentuh trigger dan arena belum aktif
	if not has_triggered and body.is_in_group("player"):
		has_triggered = true
		
		# 1. AMBIL ALIH KAMERA & ZOOM OUT
		if arena_camera:
			# Matikan kamera player (opsional, mencegah bentrok)
			var player_cam = body.get_node_or_null("Camera2D")
			if player_cam: player_cam.enabled = false
			
			# Aktifkan kamera arena
			arena_camera.enabled = true
			arena_camera.make_current()
			
			# Animasi Kamera Membesar (Zoom Out) misal dari 1.0 ke 0.8
			var cam_tween = create_tween()
			cam_tween.tween_property(arena_camera, "zoom", Vector2(0.8, 0.8), 1.0)
		
		# 2. JATUHKAN PINTU (Animasi Terkunci)
		if pintu_boss:
			pintu_boss.visible = true
			var pintu_tween = create_tween()
			# Jatuhkan kembali ke posisi semula dengan efek memantul (BOUNCE)
			pintu_tween.tween_property(pintu_boss, "position:y", pintu_boss.position.y + 250, 0.5).set_trans(Tween.TRANS_BOUNCE)
			
		# 3. BANGUNKAN BOSS
		if boss:
			# Kita akan membuat variabel is_active di script boss
			boss.is_active = true
