extends CharacterBody3D

@onready var camera_mount: Node3D = $camera_mount
@onready var animation_player: AnimationPlayer = $visuals/AuxScene/AnimationPlayer
@onready var visuals: Node3D = $visuals

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var sens_horizontal = 0.2
var sens_vertical = 0.2

var is_jumping = false  # Track if the character is jumping

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		visuals.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta  # Apply gravity downward
	else:
		if is_jumping:
			is_jumping = false  # Reset jump state when landing
			animation_player.play("BreathingIdle0")  # Return to idle animation when landing

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation_player.play("Jump0")  # Play jump animation
		is_jumping = true  # Set jumping state

	# Handle movement
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		if not is_jumping and animation_player.current_animation != "MediumRun0":
			animation_player.play("MediumRun0")  # Play run animation if moving
		visuals.look_at(position + direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if not is_jumping and animation_player.current_animation != "BreathingIdle0":
			animation_player.play("BreathingIdle0")  # Play idle animation when stopping
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
