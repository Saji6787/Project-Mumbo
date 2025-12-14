extends CharacterBody2D

# Kecepatan gerak player (bisa diatur di Inspector)
@export var speed: float = 200.0

func _physics_process(delta):
	# 1. Mendapatkan arah input dari keyboard/gamepad
	# Input.get_vector menangani input 4 arah dan diagonal secara otomatis
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 2. Menggerakkan player
	if direction:
		# Jika ada tombol ditekan, set velocity sesuai arah * speed
		velocity = direction * speed
	else:
		# Jika tidak ada tombol, berhenti perlahan (instant stop di sini karena move_toward speed-nya sama)
		velocity = velocity.move_toward(Vector2.ZERO, speed)

	# 3. Menerapkan gerakan
	move_and_slide()
