extends CharacterBody3D

var target: CharacterBody3D
var health := 75.0
var speed := 3.0
var attack_cooldown := 0.0
var body_mesh: MeshInstance3D
var flash_time := 0.0

func setup(player: CharacterBody3D) -> void:
    target = player
    _build_enemy()

func _build_enemy() -> void:
    var capsule := CapsuleMesh.new()
    capsule.height = 1.7
    capsule.radius = 0.45
    body_mesh = MeshInstance3D.new()
    body_mesh.mesh = capsule
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color("c95a62")
    mat.roughness = 0.65
    body_mesh.material_override = mat
    add_child(body_mesh)
    var collision := CollisionShape3D.new()
    var shape := CapsuleShape3D.new()
    shape.height = 1.7
    shape.radius = 0.45
    collision.shape = shape
    add_child(collision)

func _physics_process(delta: float) -> void:
    if not is_instance_valid(target) or target.extracted:
        return
    attack_cooldown = max(0.0, attack_cooldown - delta)
    if target.signal_mode:
        return
    var distance := global_position.distance_to(target.global_position)
    if distance > 6.0:
        var dir := target.global_position - global_position
        dir.y = 0
        velocity = dir.normalized() * speed
        rotation.y = atan2(-dir.x, -dir.z)
        move_and_slide()
    else:
        velocity = Vector3.ZERO
        if attack_cooldown <= 0:
            attack_cooldown = 0.8
            target.take_damage(12.0)
    if flash_time > 0:
        flash_time -= delta
        body_mesh.visible = int(flash_time * 20.0) % 2 == 0
    else:
        body_mesh.visible = true

func take_damage(amount: float) -> void:
    health -= amount
    flash_time = 0.12
    if health <= 0:
        queue_free()
