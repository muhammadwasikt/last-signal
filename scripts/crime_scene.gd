extends Control
class_name CrimeSceneView
signal hotspot_clicked(id: String)
var hotspots: Array = []
var pulse_time: float = 0.0
var selected_id: String = ""
func setup(items: Array) -> void:
	hotspots = items
	queue_redraw()
func _process(delta: float) -> void:
	pulse_time += delta
	queue_redraw()
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_check_hit(event.position)
	elif event is InputEventScreenTouch and event.pressed:
		_check_hit(event.position)
func _check_hit(pos: Vector2) -> void:
	for item in hotspots:
		if item.rect.has_point(pos):
			selected_id = item.id
			hotspot_clicked.emit(item.id)
			queue_redraw()
			return
func _draw() -> void:
	var s := size
	draw_rect(Rect2(Vector2.ZERO, s), Color("171c24"))
	draw_rect(Rect2(0, 0, s.x, s.y * 0.58), Color("27303b"))
	draw_rect(Rect2(0, s.y * 0.58, s.x, s.y * 0.42), Color("5a4639"))
	draw_rect(Rect2(s.x * 0.70, s.y * 0.10, s.x * 0.20, s.y * 0.30), Color("111a2b"))
	draw_line(Vector2(s.x * 0.80, s.y * 0.10), Vector2(s.x * 0.80, s.y * 0.40), Color("506783"), 3)
	draw_line(Vector2(s.x * 0.70, s.y * 0.25), Vector2(s.x * 0.90, s.y * 0.25), Color("506783"), 3)
	draw_rect(Rect2(s.x * 0.07, s.y * 0.55, s.x * 0.34, s.y * 0.13), Color("51392c"))
	draw_rect(Rect2(s.x * 0.10, s.y * 0.68, s.x * 0.04, s.y * 0.25), Color("38271f"))
	draw_rect(Rect2(s.x * 0.34, s.y * 0.68, s.x * 0.04, s.y * 0.25), Color("38271f"))
	draw_rect(Rect2(s.x * 0.55, s.y * 0.58, s.x * 0.25, s.y * 0.18), Color("34434b"))
	draw_rect(Rect2(s.x * 0.57, s.y * 0.52, s.x * 0.21, s.y * 0.12), Color("40515a"))
	draw_rect(Rect2(s.x * 0.37, s.y * 0.72, s.x * 0.28, s.y * 0.20), Color("735d52"))
	draw_circle(Vector2(s.x * 0.47, s.y * 0.56), 28.0, Color("11151a"))
	draw_colored_polygon(PackedVector2Array([Vector2(s.x * 0.42, s.y * 0.60), Vector2(s.x * 0.52, s.y * 0.60), Vector2(s.x * 0.56, s.y * 0.76), Vector2(s.x * 0.39, s.y * 0.76)]), Color("151a20"))
	draw_rect(Rect2(s.x * 0.02, s.y * 0.13, s.x * 0.12, s.y * 0.55), Color("3c2925"))
	draw_rect(Rect2(s.x * 0.11, s.y * 0.42, 8, 8), Color("c49b55"))
	for item in hotspots:
		var center: Vector2 = item.rect.get_center()
		var active: bool = item.id == selected_id
		var radius := 18.0 + sin(pulse_time * 3.0 + center.x * 0.01) * 2.0
		draw_arc(center, radius, 0, TAU, 32, Color("e8c46a", 0.9 if active else 0.55), 3.0)
		draw_circle(center, 4.0, Color("f5e2a3"))
