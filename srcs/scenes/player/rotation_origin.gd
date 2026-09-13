extends Marker2D
class_name GunHandler
@onready var gun_sprite := $RayCast2D/GunSprite
@onready var raycast := $RayCast2D
@onready var bullet_spawn_point :Marker2D= $RayCast2D/GunSprite/BulletSpawnPoint
@export var bullet_scene :PackedScene
@export var sprite_offset: float = 5

var max_ammo_count := 5
var ammo_count := 5
var bullet_cooldown := 0

signal ammo_count_changed(new_ammo_count, new_max_ammo_count)
func set_ammo_count(new_ammo_count: int, new_max_ammo_count := 0):
	if new_max_ammo_count != 0:
		max_ammo_count = new_max_ammo_count
	
	ammo_count = clamp(new_ammo_count, 0, max_ammo_count)
	ammo_count_changed.emit(ammo_count, max_ammo_count)
func _physics_process(delta: float) -> void:
	bullet_cooldown = max(0, bullet_cooldown - delta)
	var local_mouse := get_local_mouse_position()
	rotate(local_mouse.angle())
	
	var max_length :float= raycast.target_position.length()
	
	if raycast.is_colliding():
		var local_hit :Vector2= raycast.to_local(raycast.get_collision_point())
		max_length = minf(max_length, local_hit.length() - sprite_offset)
	

	var target_x := clampf(local_mouse.x - sprite_offset, 0.0, max_length)

	gun_sprite.position = Vector2(target_x, 0.0)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		if ammo_count <= 0 or bullet_cooldown > 0:
			return
		var mouse_pos := get_global_mouse_position()
		var bullet_scene :Bullet= bullet_scene.instantiate()
		bullet_scene.vec = global_position.direction_to(mouse_pos)
		var parent := get_parent().get_parent()
		if parent != null:
			parent.add_child(bullet_scene)
			bullet_scene.global_position = bullet_spawn_point.global_position
			set_ammo_count(ammo_count - 1)
			bullet_cooldown = 1
