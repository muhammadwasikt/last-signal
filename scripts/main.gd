extends Node

const DB = preload("res://scripts/case_database.gd")

var profile: Dictionary = {"unlocked_case":1,"completed":{},"stars":0,"xp":0,"streak":0,"rank":"ROOKIE"}
var current_case: Dictionary = {}
var found_evidence: Dictionary = {}
var challenged: Dictionary = {}
var screen: Control
var content: VBoxContainer
var scene_view: Control
var title_label: Label
var status_label: Label
var toast_label: Label
var save_path := "user://casefile_profile.json"

func _ready() -> void:
	_load_profile()
	_show_main_menu()

func _load_profile() -> void:
	if not FileAccess.file_exists(save_path):
		return
	var f := FileAccess.open(save_path, FileAccess.READ)
	if f:
		var parsed = JSON.parse_string(f.get_as_text())
		if parsed is Dictionary:
			for key in profile:
				if parsed.has(key):
					profile[key] = parsed[key]
		f.close()

func _save_profile() -> void:
	var f := FileAccess.open(save_path, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(profile))
		f.close()

func _clear() -> void:
	if is_instance_valid(screen):
		screen.queue_free()
	screen = Control.new()
	screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(screen)
	var bg := ColorRect.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.color = Color("091018")
	screen.add_child(bg)
	content = VBoxContainer.new()
	content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content.offset_left = 42
	content.offset_right = -42
	content.offset_top = 30
	content.offset_bottom = -30
	content.add_theme_constant_override("separation", 12)
	screen.add_child(content)
	var header := HBoxContainer.new()
	header.custom_minimum_size.y = 48
	content.add_child(header)
	title_label = _label("CASEFILE",30)
	header.add_child(title_label)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(spacer)
	status_label = _label("",16)
	header.add_child(status_label)
	toast_label = _label("",18)
	toast_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast_label.modulate.a = 0.0
	screen.add_child(toast_label)
	toast_label.set_anchors_preset(Control.PRESET_CENTER)
	toast_label.position.y = 300

func _label(t:String,s:int) -> Label:
	var l:=Label.new()
	l.text=t
	l.add_theme_font_size_override("font_size",s)
	l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	return l

func _button(t:String, cb:Callable) -> Button:
	var b:=Button.new()
	b.text=t
	b.custom_minimum_size.y=50
	b.add_theme_font_size_override("font_size",16)
	b.pressed.connect(cb)
	return b

func _toast(t:String) -> void:
	if is_instance_valid(toast_label):
		toast_label.text=t
		toast_label.modulate.a=1.0

func _show_main_menu() -> void:
	_clear()
	title_label.text="CASEFILE"
	status_label.text="RANK %s • XP %d • ★ %d • STREAK %d" % [profile.rank,int(profile.xp),int(profile.stars),int(profile.streak)]
	content.add_child(_label("LAST SCENE\nDetective mysteries built around hidden objects, evidence and deduction.",24))
	content.add_child(_label("SEARCH → DISCOVER → ANALYZE → INTERROGATE → DEDUCE → ACCUSE",15))
	content.add_child(_button("CONTINUE CASE #%03d" % int(profile.unlocked_case),Callable(self,"_start_case")))
	content.add_child(_button("CASE FILES • 1000 CASES",Callable(self,"_show_case_files")))
	content.add_child(_button("EVIDENCE ROOM",Callable(self,"_show_evidence_room")))
	content.add_child(_button("DETECTIVE PROFILE",Callable(self,"_show_profile")))

func _start_case() -> void:
	current_case=DB.get_case(int(profile.unlocked_case))
	if current_case.is_empty():
		_show_locked(int(profile.unlocked_case))
		return
	found_evidence.clear()
	challenged.clear()
	_show_briefing()

func _show_briefing() -> void:
	_clear()
	title_label.text="CASE %03d • %s" % [int(current_case.id),current_case.title]
	status_label.text=current_case.difficulty
	content.add_child(_label(current_case.chapter,14))
	content.add_child(_label("CASE BRIEFING",24))
	content.add_child(_label(current_case.briefing,18))
	content.add_child(_label("OBJECTIVE\n"+current_case.objective,16))
	content.add_child(_label("VICTIM: %s\nSUSPECTS: %d\nKEY EVIDENCE: %d" % [current_case.victim,current_case.suspects.size(),current_case.required_evidence.size()],15))
	content.add_child(_button("ENTER CRIME SCENE",Callable(self,"_show_scene")))
	content.add_child(_button("CASE FILES",Callable(self,"_show_case_files")))

func _show_scene() -> void:
	_clear()
	title_label.text="CRIME SCENE"
	status_label.text="KEY CLUES %d / %d" % [found_evidence.size(),current_case.required_evidence.size()]
	content.add_child(_label("Search the room yourself. Highlighted objects can be inspected; some are distractions.",13))
	scene_view=preload("res://scripts/crime_scene.gd").instantiate()
	scene_view.custom_minimum_size=Vector2(0,420)
	scene_view.size_flags_vertical=Control.SIZE_EXPAND_FILL
	scene_view.setup(current_case.evidence)
	scene_view.hotspot_clicked.connect(_inspect)
	content.add_child(scene_view)
	var row:=HBoxContainer.new()
	content.add_child(row)
	row.add_child(_button("EVIDENCE BOARD",Callable(self,"_show_board")))
	row.add_child(_button("SUSPECTS",Callable(self,"_show_suspects")))
	row.add_child(_button("FINAL ACCUSATION",Callable(self,"_show_accusation")))

func _inspect(id:String) -> void:
	var item:Dictionary={}
	for x in current_case.evidence:
		if x.id==id:
			item=x
			break
	if item.is_empty(): return
	if id in current_case.required_evidence:
		found_evidence[id]=item
		_toast("EVIDENCE COLLECTED • "+item.name)
	else:
		_toast("INSPECTED • "+item.name+" is a distraction.")
	_show_scene()

func _show_board() -> void:
	_clear()
	title_label.text="EVIDENCE BOARD"
	status_label.text="%d / %d KEY CLUES" % [found_evidence.size(),current_case.required_evidence.size()]
	for id in found_evidence:
		var item:Dictionary=found_evidence[id]
		var p:=PanelContainer.new()
		var box:=VBoxContainer.new()
		p.add_child(box)
		box.add_child(_label(item.name+" • "+item.category,18))
		box.add_child(_label(item.detail,14))
		content.add_child(p)
	content.add_child(_button("INTERROGATE SUSPECTS",Callable(self,"_show_suspects")))
	content.add_child(_button("BACK TO SCENE",Callable(self,"_show_scene")))
	content.add_child(_button("BUILD FINAL CASE",Callable(self,"_show_accusation")))

func _show_suspects() -> void:
	_clear()
	title_label.text="SUSPECTS"
	status_label.text="CONTRADICTIONS %d" % challenged.size()
	content.add_child(_label("Question each suspect, then challenge statements using the matching evidence.",15))
	for suspect in current_case.suspects:
		var p:=PanelContainer.new()
		var box:=VBoxContainer.new()
		p.add_child(box)
		box.add_child(_label(suspect.name+" • "+suspect.role,19))
		box.add_child(_label("ALIBI: "+suspect.alibi,14))
		for q in current_case.questions:
			var key:String=suspect.id+":"+q.id
			var b:=_button(("[CHALLENGED] " if challenged.has(key) else "")+q.label,Callable(self,"_interrogate").bind(suspect,q))
			b.custom_minimum_size.y=42
			box.add_child(b)
		content.add_child(p)
	content.add_child(_button("EVIDENCE BOARD",Callable(self,"_show_board")))

func _interrogate(suspect:Dictionary,q:Dictionary) -> void:
	var dialog:=AcceptDialog.new()
	dialog.title=suspect.name+" • Statement"
	dialog.dialog_text=suspect.responses.get(q.id,"I have nothing else to say.")+"\n\nRequired evidence: "+_evidence_name(q.evidence)
	screen.add_child(dialog)
	var challenge:=Button.new()
	challenge.text="CHALLENGE WITH EVIDENCE"
	challenge.position=Vector2(500,570)
	challenge.custom_minimum_size=Vector2(280,48)
	challenge.pressed.connect(func():
		if found_evidence.has(q.evidence):
			challenged[suspect.id+":"+q.id]=true
			dialog.dialog_text="CONTRADICTION FOUND\n\n"+suspect.contradictions.get(q.id,"The evidence contradicts this statement.")
			challenge.disabled=true
		else:
			_toast("Find "+_evidence_name(q.evidence)+" first.")
	)
	screen.add_child(challenge)
	dialog.popup_centered()

func _evidence_name(id:String)->String:
	for x in current_case.evidence:
		if x.id==id: return x.name
	return "Unknown"

func _show_accusation() -> void:
	_clear()
	title_label.text="BUILD YOUR CASE"
	status_label.text="FINAL DEDUCTION"
	content.add_child(_label("Your accusation is checked against the actual case solution. No automatic win.",15))
	var culprit:=OptionButton.new()
	for s in current_case.suspects: culprit.add_item(s.name)
	content.add_child(_label("CULPRIT",14))
	content.add_child(culprit)
	var motive:=OptionButton.new()
	motive.add_item("Financial dispute")
	motive.add_item("Personal revenge")
	motive.add_item("Fear of exposure")
	content.add_child(_label("MOTIVE",14))
	content.add_child(motive)
	var method:=OptionButton.new()
	method.add_item("Poison")
	method.add_item("Blunt force")
	method.add_item("Strangulation")
	content.add_child(_label("METHOD",14))
	content.add_child(method)
	var evidence:=OptionButton.new()
	for x in current_case.evidence:
		if found_evidence.has(x.id): evidence.add_item(x.name)
	content.add_child(_label("KEY EVIDENCE",14))
	content.add_child(evidence)
	content.add_child(_button("SUBMIT ACCUSATION",Callable(self,"_submit").bind(culprit,motive,method,evidence)))
	content.add_child(_button("BACK",Callable(self,"_show_board")))

func _submit(culprit:OptionButton,motive:OptionButton,method:OptionButton,evidence:OptionButton)->void:
	if evidence.item_count==0:
		_show_result(false,0,"Insufficient evidence. A detective cannot make a supported accusation yet.")
		return
	var c:=culprit.get_item_text(culprit.selected)=="Evelyn Cross"
	var m:=motive.get_item_text(motive.selected)=="Financial dispute"
	var me:=method.get_item_text(method.selected)=="Poison"
	var ev:=false
	for x in current_case.required_evidence:
		if _evidence_name(x)==evidence.get_item_text(evidence.selected):
			ev=true
			break
	var score:=int(c)+int(m)+int(me)+int(ev)
	if score==4 and found_evidence.size()==current_case.required_evidence.size():
		_show_result(true,3,"PERFECT SOLUTION. The locked-room setup, financial motive and poisoning method are supported by the recovered evidence.")
	elif c and ev:
		_show_result(true,2,"CASE SOLVED. You identified the culprit and supported the accusation, but the deduction was incomplete.")
	else:
		_show_result(false,0,"WRONG ACCUSATION. The selected conclusion does not match the evidence.")

func _show_result(won:bool,stars:int,message:String)->void:
	_clear()
	title_label.text="CASE %03d • %s" % [int(current_case.id),"SOLVED" if won else "UNSOLVED"]
	status_label.text=("★".repeat(stars)+"☆".repeat(3-stars)) if won else "RETRY"
	content.add_child(_label(message,20))
	if won:
		var key:=str(current_case.id)
		if not profile.completed.has(key):
			profile.completed[key]=stars
			profile.stars=int(profile.stars)+stars
			profile.xp=int(profile.xp)+stars*100
			profile.streak=int(profile.streak)+1
			profile.unlocked_case=min(DB.MAX_CASES,int(profile.unlocked_case)+1)
			_update_rank()
			_save_profile()
		content.add_child(_label("+%d XP\n+%d STARS\nSTREAK %d\nNEXT CASE #%03d" % [stars*100,stars,int(profile.streak),int(profile.unlocked_case)],18))
		content.add_child(_button("NEXT CASE",Callable(self,"_start_case")))
	else:
		profile.streak=0
		_save_profile()
		content.add_child(_button("RETRY CASE",Callable(self,"_start_case")))
	content.add_child(_button("CASE FILES",Callable(self,"_show_case_files")))
	content.add_child(_button("MAIN MENU",Callable(self,"_show_main_menu")))

func _update_rank()->void:
	var xp:=int(profile.xp)
	if xp>=10000: profile.rank="MASTER DETECTIVE"
	elif xp>=5000: profile.rank="ELITE DETECTIVE"
	elif xp>=2500: profile.rank="SENIOR DETECTIVE"
	elif xp>=1000: profile.rank="DETECTIVE"
	else: profile.rank="ROOKIE"

func _show_case_files()->void:
	_clear()
	title_label.text="CASE FILES"
	status_label.text="%d / %d UNLOCKED" % [int(profile.unlocked_case),DB.MAX_CASES]
	var scroll:=ScrollContainer.new()
	scroll.size_flags_vertical=Control.SIZE_EXPAND_FILL
	content.add_child(scroll)
	var grid:=GridContainer.new()
	grid.columns=5
	grid.add_theme_constant_override("h_separation",8)
	grid.add_theme_constant_override("v_separation",8)
	scroll.add_child(grid)
	for i in range(1,DB.MAX_CASES+1):
		var available:bool=DB.is_case_available(i,int(profile.unlocked_case))
		var label:="CASE #%03d" % i
		if profile.completed.has(str(i)): label+=" • "+"★".repeat(int(profile.completed[str(i)]))
		elif available: label+=" • OPEN"
		else: label+=" • LOCKED"
		var b:=_button(label,Callable(self,"_open_case").bind(i))
		b.disabled=not available
		grid.add_child(b)
	content.add_child(_button("BACK",Callable(self,"_show_main_menu")))

func _open_case(id:int)->void:
	if id==1:
		profile.unlocked_case=max(int(profile.unlocked_case),id)
		_start_case()
	else:
		_show_locked(id)

func _show_locked(id:int)->void:
	_clear()
	title_label.text="CASE #%03d • LOCKED" % id
	status_label.text="CONTENT NOT YET AUTHORED"
	content.add_child(_label("This case slot belongs to the 1000-case progression architecture, but its investigation content has not been authored yet. It is not presented as playable.",17))
	content.add_child(_button("CASE FILES",Callable(self,"_show_case_files")))

func _show_profile()->void:
	_clear()
	title_label.text="DETECTIVE PROFILE"
	status_label.text=profile.rank
	content.add_child(_label("RANK\n"+profile.rank,23))
	content.add_child(_label("XP\n%d" % int(profile.xp),18))
	content.add_child(_label("STARS\n%d" % int(profile.stars),18))
	content.add_child(_label("CASES COMPLETED\n%d" % profile.completed.size(),18))
	content.add_child(_label("CURRENT STREAK\n%d" % int(profile.streak),18))
	content.add_child(_button("BACK",Callable(self,"_show_main_menu")))

func _show_evidence_room()->void:
	_clear()
	title_label.text="EVIDENCE ROOM"
	status_label.text="ARCHIVE"
	if profile.completed.is_empty():
		content.add_child(_label("No completed investigations yet.",18))
	else:
		for key in profile.completed:
			var d:=DB.get_case(int(key))
			if not d.is_empty():
				content.add_child(_label("CASE #%03d • %s • %d ★" % [int(key),d.title,int(profile.completed[key])],16))
	content.add_child(_button("BACK",Callable(self,"_show_main_menu")))
