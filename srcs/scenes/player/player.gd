extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const AIR_FRICTION = 0.9
const MIN_UPWARD_BIAS = -0.35
const HITSTUN_TIME = 0.25
const HITSTUN_INPUT_SCALE = 0.15

# this should be handled by but we need to control the exported variable in every other scenes
@export var max_ammo_count := 5
@export var ammo_count := 5
@onready var anim_sprite :AnimatedSprite2D= $AnimatedSprite2D
@onready var gun_handler :GunHandler = $RotationOrigin
var knockback_x := 0.0
var hitstun_timer := 0.0

func _ready() -> void:
	$RotationOrigin.set_ammo_count(ammo_count, max_ammo_count)
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := Input.get_axis("walk_left", "walk_right")
	var input_velocity_x := 0.0
	var control_scale := 1.0

	if hitstun_timer > 0.0:
		hitstun_timer -= delta
		control_scale = HITSTUN_INPUT_SCALE

	if direction:
		anim_sprite.flip_h = (direction < 0)
		anim_sprite.play("walking")
		input_velocity_x = direction * SPEED * control_scale
	else:
		anim_sprite.play("idle")

	knockback_x *= pow(AIR_FRICTION, delta * 60.0)
	if abs(knockback_x) < 1.0:
		knockback_x = 0.0

	velocity.x = input_velocity_x + knockback_x
	
	if position.y >= 700:
		get_tree().reload_current_scene()
	move_and_slide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func hit_by_explosion(explosion_power: float, explosion_origin: Vector2) -> void:
	var diff := global_position - explosion_origin
	var launch_direction := Vector2.UP

	if diff.length_squared() > 0.0001:
		launch_direction = diff.normalized()
		launch_direction.y = min(launch_direction.y, MIN_UPWARD_BIAS)
		launch_direction = launch_direction.normalized()

	var launch_vector := launch_direction * explosion_power

	velocity.y = launch_vector.y
	knockback_x = launch_vector.x
	hitstun_timer = HITSTUN_TIME
