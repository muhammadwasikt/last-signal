extends Node3D

const PLAYER = preload("res://scripts/player.gd")
const ENEMY = preload("res://scripts/enemy.gd")
const HUD = preload("res://scripts/hud.gd")

var player: CharacterBody3D
var hud: CanvasLayer
var extraction_zone: Area3D
var running := false
var world_time := 0.0
var briefing: Control

func _ready() -> void:
    _build_environment()
    _build_briefing()

func _process(delta: float) -> void:
    world_time += delta
    if running and is_instance_valid(player): _update_phase()

func start_match() -> void:
    if running: return
    running = true
    briefing.visible = false
    _spawn_player()
    _spawn_enemies()
    _spawn_intel()
    _build_extraction()
    _build_hud()

func _build_environment() -> void:
    var world_env := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_COLOR
    env.background_color = Color("0b1118")
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color("6a7b92")
    env.ambient_light_energy = 0.65
    env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
    world_env.environment = env
    add_child(world_env)
    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-52, -28, 0)
    sun.light_energy = 1.35
    sun.shadow_enabled = true
    add_child(sun)
    _make_box(Vector3(0, -0.25, 0), Vector3(70, 0.5, 70), Color("1a252d"), "Ground")
    _make_box(Vector3(0, 2, -34), Vector3(70, 4, 1), Color("26333c"), "NorthWall")
    _make_box(Vector3(0, 2, 34), Vector3(70, 4, 1), Color("26333c"), "SouthWall")
    _make_box(Vector3(-34, 2, 0), Vector3(1, 4, 70), Color("26333c"), "WestWall")
    _make_box(Vector3(34, 2, 0), Vector3(1, 4, 70), Color("26333c"), "EastWall")
    _make_box(Vector3(-10, 1.5, -8), Vector3(12, 3, 3), Color("31414b"), "Warehouse")
    _make_box(Vector3(12, 1.5, -3), Vector3(4, 3, 16), Color("2a3944"), "CommsBlock")
    _make_box(Vector3(0, 1.0, 12), Vector3(15, 2, 4), Color("293840"), "Checkpoint")
    _make_box(Vector3(-18, 1.0, 18), Vector3(6, 2, 6), Color("344650"), "Garage")

func _make_box(pos: Vector3, size: Vector3, color: Color, node_name: String) -> StaticBody3D:
    var body := StaticBody3D.new()
    body.name = node_name
    body.position = pos
    var mesh := MeshInstance3D.new()
    var box := BoxMesh.new()
    box.size = size
    mesh.mesh = box
    var mat := StandardMaterial3D.new()
    mat.albedo_color = color
    mat.roughness = 0.8
    mesh.material_override = mat
    body.add_child(mesh)
    var collision := CollisionShape3D.new()
    var shape := BoxShape3D.new()
    shape.size = size
    collision.shape = shape
    body.add_child(collision)
    add_child(body)
    return body

func _spawn_player() -> void:
    player = CharacterBody3D.new()
    player.name = "Player"
    player.set_script(PLAYER)
    player.position = Vector3(0, 1, 25)
    add_child(player)
    player.setup(self)

func _spawn_enemies() -> void:
    var positions := [Vector3(-18,1,-20), Vector3(20,1,-14), Vector3(-20,1,6), Vector3(17,1,17), Vector3(4,1,-24), Vector3(23,1,5)]
    for i in positions.size():
        var enemy := CharacterBody3D.new()
        enemy.name = "Raider_%02d" % (i + 1)
        enemy.set_script(ENEMY)
        enemy.position = positions[i]
        add_child(enemy)
        enemy.setup(player)

func _spawn_intel() -> void:
    var points := [Vector3(-24,.5,-22), Vector3(17,.5,-20), Vector3(-24,.5,10), Vector3(21,.5,22)]
    for i in points.size():
        var intel := Area3D.new()
        intel.name = "Intel_%02d" % (i + 1)
        intel.position = points[i]
        var mesh := MeshInstance3D.new()
        var cube := BoxMesh.new()
        cube.size = Vector3(.8,.4,.8)
        mesh.mesh = cube
        var mat := StandardMaterial3D.new()
        mat.albedo_color = Color("42d3b2")
        mat.emission_enabled = true
        mat.emission = Color("1cae92")
        mat.emission_energy_multiplier = 2.5
        mesh.material_override = mat
        intel.add_child(mesh)
        var collision := CollisionShape3D.new()
        var shape := SphereShape3D.new()
        shape.radius = 1.1
        collision.shape = shape
        intel.add_child(collision)
        intel.body_entered.connect(_on_intel_body_entered.bind(intel))
        add_child(intel)

func _on_intel_body_entered(body: Node3D, intel: Area3D) -> void:
    if body != player or not running or not is_instance_valid(intel): return
    player.intel += 1
    intel.queue_free()
    if is_instance_valid(hud): hud.call("toast", "INTEL RECOVERED • %d / 3" % player.intel)

func _build_extraction() -> void:
    extraction_zone = Area3D.new()
    extraction_zone.name = "ExtractionZone"
    extraction_zone.position = Vector3(0,.4,-29)
    var mesh := MeshInstance3D.new()
    var cylinder := CylinderMesh.new()
    cylinder.top_radius = 3.5
    cylinder.bottom_radius = 3.5
    cylinder.height = .15
    mesh.mesh = cylinder
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color("3e86ff")
    mat.emission_enabled = true
    mat.emission = Color("1f5fda")
    mat.emission_energy_multiplier = 2.0
    mesh.material_override = mat
    extraction_zone.add_child(mesh)
    var collision := CollisionShape3D.new()
    var shape := CylinderShape3D.new()
    shape.radius = 3.5
    shape.height = 1.2
    collision.shape = shape
    extraction_zone.add_child(collision)
    extraction_zone.body_entered.connect(_on_extraction_entered)
    add_child(extraction_zone)

func _on_extraction_entered(body: Node3D) -> void:
    if body != player or not running: return
    if player.intel < 3:
        hud.call("toast", "EXTRACTION LOCKED • Recover 3 Intel")
        return
    player.extracted = true
    hud.call("match_won")
    running = false

func _build_hud() -> void:
    hud = CanvasLayer.new()
    hud.set_script(HUD)
    add_child(hud)
    hud.setup(player, self)

func _build_briefing() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)
    briefing = Control.new()
    briefing.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    briefing.mouse_filter = Control.MOUSE_FILTER_STOP
    layer.add_child(briefing)
    var bg := ColorRect.new()
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    bg.color = Color(.03,.045,.06,1)
    briefing.add_child(bg)
    var panel := PanelContainer.new()
    panel.set_anchor_and_offset(SIDE_LEFT,.5,-330)
    panel.set_anchor_and_offset(SIDE_RIGHT,.5,330)
    panel.set_anchor_and_offset(SIDE_TOP,.5,-210)
    panel.set_anchor_and_offset(SIDE_BOTTOM,.5,210)
    briefing.add_child(panel)
    var box := VBoxContainer.new()
    box.add_theme_constant_override("separation",16)
    panel.add_child(box)
    var title := Label.new()
    title.text="LAST SIGNAL"; title.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size",42); box.add_child(title)
    var subtitle := Label.new()
    subtitle.text="TACTICAL SURVIVAL • INFORMATION IS LOOT"; subtitle.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
    subtitle.add_theme_font_size_override("font_size",15); box.add_child(subtitle)
    var desc := Label.new()
    desc.text="Deploy into Sector 01. Recover 3 intelligence caches, survive hostile raiders, and extract.\n\nWhen your operator is eliminated, you become SIGNAL: a limited intelligence role that can ping threats instead of shooting.\n\nWeb: keyboard + mouse. Mobile: on-screen controls."
    desc.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; desc.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
    desc.add_theme_font_size_override("font_size",17); box.add_child(desc)
    var deploy := Button.new()
    deploy.text="DEPLOY"; deploy.custom_minimum_size=Vector2(0,58)
    deploy.add_theme_font_size_override("font_size",20); deploy.pressed.connect(start_match); box.add_child(deploy)

func _update_phase() -> void:
    if is_instance_valid(hud):
        if player.signal_mode: hud.call("set_phase","SIGNAL")
        elif player.extracted: hud.call("set_phase","EXTRACTED")
        else: hud.call("set_phase","LIVE • %02d:%02d" % [int(world_time)/60, int(world_time)%60])
