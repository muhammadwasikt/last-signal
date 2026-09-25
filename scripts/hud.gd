extends CanvasLayer

var player: CharacterBody3D
var game: Node
var health_label: Label
var ammo_label: Label
var intel_label: Label
var phase_label: Label
var objective_label: Label
var toast_label: Label
var banner: Control
var damage_flash: ColorRect

func setup(p: CharacterBody3D, g: Node) -> void:
    player=p; game=g; _build(); _build_touch_controls(get_child(0)); set_process(true)

func _process(_delta: float) -> void:
    if not is_instance_valid(player): return
    health_label.text="HEALTH %03d" % int(player.health)
    ammo_label.text="AMMO %02d" % player.ammo
    intel_label.text="INTEL %d / 3" % player.intel
    objective_label.text = "SIGNAL OBJECTIVE • Ping threats with LMB / Q" if player.signal_mode else "OBJECTIVE • Recover 3 Intel → Reach Blue Extraction Zone"

func _build() -> void:
    var root:=Control.new(); root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); root.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(root)
    var top:=HBoxContainer.new(); top.position=Vector2(24,20); top.add_theme_constant_override("separation",26); root.add_child(top)
    health_label=_label("HEALTH 100",22); ammo_label=_label("AMMO 30",22); intel_label=_label("INTEL 0 / 3",22); phase_label=_label("LIVE",22)
    top.add_child(health_label); top.add_child(ammo_label); top.add_child(intel_label); top.add_child(phase_label)
    objective_label=_label("",18); objective_label.position=Vector2(24,64); root.add_child(objective_label)
    toast_label=_label("",18); toast_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; toast_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER); toast_label.position.y+=220; root.add_child(toast_label)
    damage_flash=ColorRect.new(); damage_flash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); damage_flash.color=Color(.85,.05,.08,0); damage_flash.mouse_filter=Control.MOUSE_FILTER_IGNORE; root.add_child(damage_flash)
    banner=Control.new(); banner.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); banner.visible=false; root.add_child(banner)
    var dim:=ColorRect.new(); dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); dim.color=Color(.01,.02,.03,.78); banner.add_child(dim)
    var center:=VBoxContainer.new(); center.custom_minimum_size=Vector2(720,0); center.set_anchors_and_offsets_preset(Control.PRESET_CENTER); center.add_theme_constant_override("separation",10); banner.add_child(center)
    var title:=Label.new(); title.name="Title"; title.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; title.add_theme_font_size_override("font_size",38); center.add_child(title)
    var desc:=Label.new(); desc.name="Desc"; desc.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; desc.add_theme_font_size_override("font_size",18); center.add_child(desc)

func _label(value:String,size:int)->Label:
    var l:=Label.new(); l.text=value; l.add_theme_font_size_override("font_size",size); return l

func toast(message:String)->void:
    toast_label.text=message; var tw=create_tween(); tw.tween_property(toast_label,"modulate:a",1.0,.05); tw.tween_interval(1.0); tw.tween_property(toast_label,"modulate:a",0.0,.3)

func flash_damage()->void:
    damage_flash.color.a=.34; var tw=create_tween(); tw.tween_property(damage_flash,"color:a",0.0,.22)

func enter_signal_mode()->void:
    phase_label.text="SIGNAL"; toast("OPERATOR LOST • SIGNAL MODE ACTIVE")

func set_phase(value:String)->void: phase_label.text=value

func match_won()->void:
    banner.visible=true
    var box=banner.get_child(1) as VBoxContainer
    if box:
        (box.get_node("Title") as Label).text="EXTRACTION COMPLETE"
        (box.get_node("Desc") as Label).text="3 Intel recovered. Vertical slice complete.\nRestart the scene to redeploy."

func _build_touch_controls(root:Control)->void:
    if not DisplayServer.is_touchscreen_available(): return
    var left:=GridContainer.new(); left.columns=3; left.set_anchors_preset(Control.PRESET_BOTTOM_LEFT); left.position=Vector2(24,-170); left.size=Vector2(230,150); left.add_theme_constant_override("h_separation",8); left.add_theme_constant_override("v_separation",8); root.add_child(left)
    _touch_button(left,"","",""); _touch_button(left,"▲","forward","forward"); _touch_button(left,"","",""); _touch_button(left,"◀","left","left"); _touch_button(left,"▼","back","back"); _touch_button(left,"▶","right","right")
    var right:=VBoxContainer.new(); right.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT); right.position=Vector2(-245,-190); right.size=Vector2(220,165); right.add_theme_constant_override("separation",8); root.add_child(right)
    var row:=HBoxContainer.new(); row.add_theme_constant_override("separation",8); right.add_child(row)
    _touch_button(row,"TURN ◀","turn_left","turn_left"); _touch_button(row,"TURN ▶","turn_right","turn_right"); _touch_button(right,"FIRE","fire","fire"); _touch_button(right,"PING","","ping")

func _touch_button(parent:Control,caption:String,control:String,kind:String)->void:
    var button:=Button.new(); button.text=caption; button.custom_minimum_size=Vector2(64,58); button.add_theme_font_size_override("font_size",16); button.modulate=Color(1,1,1,.72); parent.add_child(button)
    if kind=="ping": button.pressed.connect(_on_ping_pressed)
    elif control!="": button.button_down.connect(_on_touch_down.bind(control)); button.button_up.connect(_on_touch_up.bind(control))

func _on_touch_down(control:String)->void:
    if is_instance_valid(player): player.set_mobile_control(control,true)
func _on_touch_up(control:String)->void:
    if is_instance_valid(player): player.set_mobile_control(control,false)
func _on_ping_pressed()->void:
    if is_instance_valid(player) and player.signal_mode: player.mobile_ping()
