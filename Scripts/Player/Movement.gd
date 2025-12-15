extends CharacterBody2D

@export_group("Movement Settings")
@export var speed: float = 200.0
@export var acceleration: float = 800.0
@export var friction: float = 1000.0

var is_selected: bool = false
var target_position: Vector2
var has_target: bool = false
var line_trail: Line2D

func _ready():
	# Setup Line2D for trail
	line_trail = Line2D.new()
	line_trail.width = 2.0
	line_trail.default_color = Color.WHITE_SMOKE
	line_trail.visible = false
	add_child(line_trail)

func _input(event):
	# Handle Touch Input
	if event is InputEventScreenTouch and event.pressed:
		var touch_pos = get_global_mouse_position()
		var dist = global_position.distance_to(touch_pos)
		
		#Detection Radius
		if dist < 64.0:
			is_selected = true
			print("Player Selected")
		elif is_selected:
			#Set Target
			target_position = touch_pos
			has_target = true
			print("Moving to ", target_position)
	
	# Handle Cancel / Unselect
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			is_selected = false
			has_target = false
			line_trail.visible = false
			print("Player Unselected")

func _physics_process(delta):
	#Touch MOvement
	if has_target:
		#Line Trail Update
		line_trail.visible = true
		line_trail.points = [Vector2.ZERO, to_local(target_position)]
		
		var dist_to_target = global_position.distance_to(target_position)
		if dist_to_target > 5.0:
			var move_dir = global_position.direction_to(target_position)
			# Acceleration logic for touch
			velocity = velocity.move_toward(move_dir * speed, acceleration * delta)
		else:
			# Deceleration when arriving (smooth stop or instant?)
			# For RTS style, usually we want to stop exactly at point.
			# But if we use velocity, we might overshoot if speed is high.
			# Let's snap to zero when very close.
			velocity = Vector2.ZERO
			has_target = false
			line_trail.visible = false
			print("Arrived at target")
			
	# 3. Deceleration (Friction)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		line_trail.visible = false

	move_and_slide()
