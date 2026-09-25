extends CharacterBody3D

var game: Node
var speed := 8.0
var health := 100.0
var intel := 0
var ammo := 30
var fire_cooldown := 0.0
var signal_mode := false
var extracted := false
var mobile_forward := false
var mobile_back := false
var mobile_left := false
var mobile_right := false
var mobile_turn_left := false
var mobile_turn_right := false
var mobile_fire := false
var camera: Camera3D
var body_mesh: MeshInstance3D

func setup(owner_game: Node) -> void:
    game = owner_game
    _build_character()

func _build_character() -> void:
    var capsule := CapsuleMesh.new()
    capsule.height = 1.6
    capsule.radius = 0.42
    body_mesh = MeshInstance3D.new()
    body_mesh.mesh = capsule
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color("d6e1ec")
    mat.metallic = 0.15
    mat.roughness = 0.5
    body_mesh.material_override = mat
    add_child(body_mesh)
    var collision := CollisionShape3D.new()
    var shape := CapsuleShape3D.new()
    shape.height = 1.6
    shape.radius = 0.42
    collision.shape = shape
    add_child(collision)
    camera = Camera3D.new()
    camera.current = true
    camera.position = Vector3(0, 2.4, 6.2)
    camera.rotation_degrees = Vector3(-10, 180, 0)
    add_child(camera)
    var gun := MeshInstance3D.new()
    var box := BoxMesh.new()
    box.size = Vector3(0.22, 0.22, 1.4)
    gun.mesh = box
    var gun_mat := StandardMaterial3D.new()
    gun_mat.albedo_color = Color("303d49")
    gun.material_override = gun_mat
    gun.position = Vector3(0.55, 0.05, -0.55)
    add_child(gun)

func _unhandled_input(event: InputEvent) -> void:
    if signal_mode:
        if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            _signal_ping(get_viewport().get_mouse_position())
        elif event is InputEventKey and event.keycode == KEY_Q and event.pressed:
            _signal_ping(get_viewport().get_mouse_position())
        return
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        rotate_y(-event.relative.x * 0.003)
        var next_pitch := clamp(camera.rotation.x - event.relative.y * 0.0025, deg_to_rad(-55), deg_to_rad(18))
        camera.rotation.x = next_pitch
    elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
    if not game or extracted:
        return
    if signal_mode:
        _signal_motion(delta)
        return
    fire_cooldown = max(0.0, fire_cooldown - delta)
    var keyboard_x := (1.0 if (Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)) else 0.0) - (1.0 if (Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT)) else 0.0)
    var keyboard_y := (1.0 if (Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP)) else 0.0) - (1.0 if (Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN)) else 0.0)
    var input_vec := Vector2(keyboard_x + float(mobile_right) - float(mobile_left), keyboard_y + float(mobile_forward) - float(mobile_back)).limit_length(1.0)
    if mobile_turn_left: rotate_y(2.1 * delta)
    if mobile_turn_right: rotate_y(-2.1 * delta)
    var forward := -global_transform.basis.z
    var right := global_transform.basis.x
    var direction := right * input_vec.x + forward * input_vec.y
    direction.y = 0
    direction = direction.normalized()
    velocity.x = move_toward(velocity.x, direction.x * speed, 32.0 * delta)
    velocity.z = move_toward(velocity.z, direction.z * speed, 32.0 * delta)
    if direction.length() > 0.1:
        rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), 10.0 * delta)
    move_and_slide()
    if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_key_pressed(KEY_SPACE) or mobile_fire:
        _shoot()

func _shoot() -> void:
    if fire_cooldown > 0 or ammo <= 0: return
    fire_cooldown = 0.18
    ammo -= 1
    var origin := camera.global_position
    var direction := -camera.global_transform.basis.z
    var query := PhysicsRayQueryParameters3D.create(origin, origin + direction * 120.0)
    query.exclude = [self]
    var hit := get_world_3d().direct_space_state.intersect_ray(query)
    if hit and hit.collider and hit.collider.has_method("take_damage"):
        hit.collider.take_damage(25.0)
        if game.hud: game.hud.call("toast", "HIT • %d ROUNDS" % ammo)
    elif game.hud:
        game.hud.call("toast", "%d ROUNDS" % ammo)

func take_damage(amount: float) -> void:
    if signal_mode or extracted: return
    health = max(0.0, health - amount)
    if game.hud: game.hud.call("flash_damage")
    if health <= 0: _enter_signal_mode()

func _enter_signal_mode() -> void:
    signal_mode = true
    velocity = Vector3.ZERO
    collision_layer = 0
    collision_mask = 0
    body_mesh.visible = false
    camera.position = Vector3(0, 20, 0)
    camera.rotation_degrees = Vector3(-90, 0, 0)
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    if game.hud: game.hud.call("enter_signal_mode")

func _signal_motion(delta: float) -> void:
    var x := (1.0 if Input.is_key_pressed(KEY_D) else 0.0) - (1.0 if Input.is_key_pressed(KEY_A) else 0.0)
    var y := (1.0 if Input.is_key_pressed(KEY_W) else 0.0) - (1.0 if Input.is_key_pressed(KEY_S) else 0.0)
    var direction := Vector3(x, 0, -y).normalized()
    global_position += direction * 12.0 * delta
    global_position.x = clamp(global_position.x, -30.0, 30.0)
    global_position.z = clamp(global_position.z, -30.0, 30.0)
    camera.global_position = global_position + Vector3(0, 18, 0)

func _signal_ping(screen_pos: Vector2) -> void:
    var ray_origin := camera.project_ray_origin(screen_pos)
    var ray_dir := camera.project_ray_normal(screen_pos)
    var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + ray_dir * 80.0)
    var hit := get_world_3d().direct_space_state.intersect_ray(query)
    var marker_pos := hit.position if hit else global_position + ray_dir * 30.0
    _spawn_ping(marker_pos)
    if game.hud: game.hud.call("toast", "SIGNAL PING • INTEL TRANSMITTED")

func _spawn_ping(pos: Vector3) -> void:
    var marker := MeshInstance3D.new()
    var torus := TorusMesh.new()
    torus.inner_radius = 1.1
    torus.outer_radius = 1.25
    marker.mesh = torus
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color("ffb84d")
    mat.emission_enabled = true
    mat.emission = Color("ff8d00")
    mat.emission_energy_multiplier = 3.0
    marker.material_override = mat
    marker.position = pos + Vector3.UP * 0.15
    game.add_child(marker)
    var tw := create_tween()
    tw.tween_property(marker, "scale", Vector3(2.8, 2.8, 2.8), 0.65)
    tw.tween_callback(marker.queue_free)

func set_mobile_control(control: String, pressed: bool) -> void:
    match control:
        "forward": mobile_forward = pressed
        "back": mobile_back = pressed
        "left": mobile_left = pressed
        "right": mobile_right = pressed
        "turn_left": mobile_turn_left = pressed
        "turn_right": mobile_turn_right = pressed
        "fire": mobile_fire = pressed

func mobile_ping() -> void:
    _signal_ping(get_viewport().get_visible_rect().size * Vector2(0.5, 0.5))
