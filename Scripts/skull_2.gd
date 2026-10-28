extends Area2D

const UI_PROFILE_SCENE_FAREL = preload("res://Scenes/uiprofile_farel.tscn")

func _on_body_entered(body: Node2D) -> void:
	# Cek apakah objek yang masuk adalah player
	if body.name == "Player" or body.is_in_group("player"):
		print("Player menginjak tengkorak! Memunculkan UI...")
		
		if UI_PROFILE_SCENE_FAREL:
			var ui_instance = UI_PROFILE_SCENE_FAREL.instantiate()
			
			# Gunakan get_parent() agar UI ditambahkan ke dalam scene aktif dengan aman
			get_parent().add_child(ui_instance)
			
			# Hapus tengkorak agar tidak memicu 2 kali
			queue_free()
		else:
			print("ERROR: Gagal memuat scene UI!")
