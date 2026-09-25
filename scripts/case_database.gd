extends RefCounted
class_name CaseDatabase

const MAX_CASES: int = 1000

static func case_001() -> Dictionary:
	return {
		"id": 1,
		"title": "The Locked Apartment",
		"chapter": "CHAPTER 01 • FIRST FILES",
		"difficulty": "INTRODUCTORY",
		"briefing": "Daniel Mercer was found dead inside apartment 4B. The chain was engaged from the inside and no forced entry was reported. Three people had reasons to lie.",
		"objective": "Find the evidence that explains how the locked-room murder happened.",
		"victim": "Daniel Mercer",
		"culprit": "Evelyn Cross",
		"motive": "Daniel discovered Evelyn had been diverting money from their shared property business.",
		"method": "Evelyn poisoned Daniel's evening coffee, then used his spare key to stage the locked room before leaving.",
		"required_evidence": ["coffee", "spare_key", "ledger", "pharmacy_receipt", "phone_message"],
		"evidence": [
			{"id":"coffee","name":"Coffee Cup","rect":Rect2(120,285,90,80),"detail":"A half-finished coffee sits beside the victim. A faint bitter residue lines the bottom.","category":"FORENSIC","points":20},
			{"id":"spare_key","name":"Spare Key","rect":Rect2(180,110,100,90),"detail":"A spare apartment key is hidden behind a loose picture frame. It explains access without forced entry.","category":"ACCESS","points":20},
			{"id":"ledger","name":"Property Ledger","rect":Rect2(90,315,120,70),"detail":"Several transfers are marked with initials E.C. and do not appear in the company account.","category":"MOTIVE","points":20},
			{"id":"pharmacy_receipt","name":"Pharmacy Receipt","rect":Rect2(310,300,110,75),"detail":"A receipt from 19:12 shows a purchase of a substance that can produce the residue found in the coffee.","category":"FORENSIC","points":20},
			{"id":"phone_message","name":"Deleted Phone Message","rect":Rect2(450,405,110,75),"detail":"Recovered draft: Daniel wrote, 'Evelyn, we need to talk about the missing funds tonight.'","category":"MOTIVE","points":20},
			{"id":"watch","name":"Broken Watch","rect":Rect2(520,430,90,70),"detail":"The victim's watch stopped at 21:06. It is useful for the timeline but does not identify the killer.","category":"TIMELINE","points":5},
			{"id":"red_scarf","name":"Red Scarf","rect":Rect2(650,335,100,80),"detail":"A scarf belonging to a visitor is found on a chair. It proves presence, not murder.","category":"DISTRACTION","points":5},
			{"id":"window","name":"Open Window","rect":Rect2(770,120,120,120),"detail":"The window is open, but dust on the sill is undisturbed. It is a staged escape route.","category":"DISTRACTION","points":5}
		],
		"suspects": [
			{"id":"evelyn","name":"Evelyn Cross","role":"Business partner","alibi":"She claims she was at home all evening.","responses":{"timeline":"I never came near Daniel's apartment.","access":"Daniel changed the locks months ago. I had no key.","motive":"The business accounts were clean. Daniel trusted me."},"contradictions":{"timeline":"The pharmacy receipt places Evelyn at a pharmacy near Daniel's building at 19:12.","access":"The spare key was hidden in a frame containing a photograph of Evelyn and Daniel.","motive":"The ledger contains transfers marked E.C., contradicting her claim that the accounts were clean."}},
			{"id":"marcus","name":"Marcus Hale","role":"Neighbor","alibi":"He says he was watching a match at home.","responses":{"timeline":"I heard a noise around nine, but I stayed in my apartment.","access":"I don't have Daniel's key.","motive":"Daniel and I argued about noise. That's all."},"contradictions":{"timeline":"The broken watch supports his statement about the timing but does not place him inside.","access":"No evidence connects Marcus to an entry method.","motive":"The argument was documented, but there is no financial motive."}},
			{"id":"sophia","name":"Sophia Reed","role":"Former employee","alibi":"She says she left the building before 20:00.","responses":{"timeline":"I left before the evening started.","access":"Daniel took my old key when I quit.","motive":"I was angry about being fired, but I did not kill him."},"contradictions":{"timeline":"Her statement is consistent with the available timeline.","access":"There is no recovered evidence showing she retained a key.","motive":"Anger alone does not establish a murder motive."}}
		],
		"questions":[
			{"id":"timeline","label":"Where were you at the time Daniel died?","evidence":"pharmacy_receipt"},
			{"id":"access","label":"How could someone enter the locked apartment?","evidence":"spare_key"},
			{"id":"motive","label":"What did you know about Daniel's business accounts?","evidence":"ledger"}
		]
	}

static func _base_case(id:int, title:String, chapter:String, difficulty:String, briefing:String, objective:String, victim:String, culprit:String, motive:String, method:String, required:Array, evidence:Array, suspects:Array, questions:Array, motive_options:Array, method_options:Array) -> Dictionary:
	return {"id":id,"title":title,"chapter":chapter,"difficulty":difficulty,"briefing":briefing,"objective":objective,"victim":victim,"culprit":culprit,"motive":motive,"method":method,"required_evidence":required,"evidence":evidence,"suspects":suspects,"questions":questions,"motive_options":motive_options,"method_options":method_options}

static func case_002() -> Dictionary:
	return _base_case(2,"The Missing Necklace","CHAPTER 01 • FIRST FILES","EASY","A charity gala ends with a priceless necklace missing from a locked display. The alarm never sounded, and four guests deny touching the case.","Determine who removed the necklace, how the display was opened, and where the jewel was hidden.","Isabel Grant","Lena Park","Gambling debt","Magnetic bypass",
	["display_log","magnet","wine_stain","cloakroom_ticket","camera_gap"],
	[
	{"id":"display_log","name":"Display Access Log","rect":Rect2(110,130,120,80),"detail":"The display records a maintenance unlock at 22:14 using a staff override code.","category":"ACCESS","points":20},
	{"id":"magnet","name":"Strong Magnet","rect":Rect2(360,220,100,80),"detail":"A rare magnet is hidden beneath a napkin. It can manipulate the display latch without opening the glass.","category":"METHOD","points":20},
	{"id":"wine_stain","name":"Wine-Stained Glove","rect":Rect2(570,310,110,80),"detail":"A black glove has the same red wine stain found beside Lena's seat.","category":"LINK","points":20},
	{"id":"cloakroom_ticket","name":"Cloakroom Ticket","rect":Rect2(760,180,100,80),"detail":"Ticket 47 was issued to Lena and returned after 22:20, matching the hiding location.","category":"TIMELINE","points":20},
	{"id":"camera_gap","name":"Camera Gap","rect":Rect2(860,390,100,80),"detail":"The corridor camera lost twelve seconds during a manual reset from the service panel.","category":"TIMELINE","points":20},
	{"id":"silver_pin","name":"Silver Pin","rect":Rect2(230,390,90,70),"detail":"A decorative pin dropped by another guest. It establishes presence but not theft.","category":"DISTRACTION","points":5}
	],
	[
	{"id":"lena","name":"Lena Park","role":"Event treasurer","alibi":"She says she stayed beside the auction desk.","responses":{"timeline":"I never left the auction area.","access":"I know the event codes, but I never used them.","motive":"I had no reason to steal the necklace."},"contradictions":{"timeline":"The cloakroom ticket places her away from the auction after 22:20.","access":"The display log shows the staff override she knew.","motive":"Financial records show an urgent gambling debt."}},
	{"id":"owen","name":"Owen Blake","role":"Security contractor","alibi":"He says he monitored the west entrance.","responses":{"timeline":"I was on camera most of the night.","access":"Only staff had the override.","motive":"I was paid normally."},"contradictions":{"timeline":"The camera gap is on his service panel.","access":"He had physical access, but no evidence links him to the display.","motive":"No financial link is established."}},
	{"id":"maya","name":"Maya Chen","role":"Donor","alibi":"She says she never approached the display.","responses":{"timeline":"I stayed with the host.","access":"I don't know the security system.","motive":"The necklace was insured."},"contradictions":{"timeline":"Her seat is visible continuously.","access":"No access evidence connects her.","motive":"No motive evidence connects her."}},
	{"id":"harold","name":"Harold Voss","role":"Collector","alibi":"He says he left at 22:00.","responses":{"timeline":"I left before the necklace vanished.","access":"I never touched the case.","motive":"I wanted to buy it legally."},"contradictions":{"timeline":"Exit records support his departure.","access":"No access evidence.","motive":"No theft evidence."}}
	],
	[{"id":"timeline","label":"Where were you after 22:00?","evidence":"cloakroom_ticket"},{"id":"access","label":"How was the display opened?","evidence":"display_log"},{"id":"motive","label":"Did you have financial pressure?","evidence":"cloakroom_ticket"}],
	["Gambling debt","Personal revenge","Professional fraud"],["Magnetic bypass","Lock pick","Key theft"])

static func case_003() -> Dictionary:
	return _base_case(3,"Death on Platform 7","CHAPTER 02 • MOVING TARGETS","MEDIUM","A commuter is found dead moments before an express train departs. A witness saw a blue coat near the victim, but three passengers wore one.","Reconstruct the platform timeline and identify whose story fails under the evidence.","Adrian Cole","Victor Shaw","Insurance fraud","Drugged drink",
	["ticket_scan","platform_photo","medicine_vial","blue_coat_fiber","train_whistle"],
	[
	{"id":"ticket_scan","name":"Ticket Scan","rect":Rect2(100,160,110,80),"detail":"Victor's ticket scanned at Platform 7 eight minutes before his claimed arrival time.","category":"TIMELINE","points":20},
	{"id":"platform_photo","name":"Platform Photograph","rect":Rect2(300,120,120,90),"detail":"A passenger photo catches Victor's distinctive watch beside Adrian shortly before departure.","category":"LINK","points":20},
	{"id":"medicine_vial","name":"Medicine Vial","rect":Rect2(510,300,100,80),"detail":"A sedative vial is found under a bench with Victor's pharmacy label.","category":"FORENSIC","points":20},
	{"id":"blue_coat_fiber","name":"Blue Coat Fiber","rect":Rect2(700,240,110,80),"detail":"Fibers match Victor's coat, but two other blue coats were present.","category":"LINK","points":20},
	{"id":"train_whistle","name":"Departure Whistle","rect":Rect2(840,420,100,70),"detail":"The whistle time fixes the final reliable point in the timeline.","category":"TIMELINE","points":20}
	],
	[
	{"id":"victor","name":"Victor Shaw","role":"Insurance broker","alibi":"He says he arrived after the train whistle.","responses":{"timeline":"I was not on Platform 7 before departure.","access":"I never spoke to Adrian.","motive":"The policy was legitimate."},"contradictions":{"timeline":"His ticket scan predates his claimed arrival.","access":"The photograph places him beside Adrian.","motive":"Adrian had discovered irregular insurance changes."}},
	{"id":"nora","name":"Nora Ellis","role":"Commuter","alibi":"She waited near the coffee kiosk.","responses":{"timeline":"I stayed near the kiosk.","access":"I didn't know the victim.","motive":"I had no connection."},"contradictions":{"timeline":"Kiosk receipt supports her location.","access":"No link.","motive":"No link."}},
	{"id":"samir","name":"Samir Khan","role":"Rail employee","alibi":"He was checking carriage doors.","responses":{"timeline":"I was working the train.","access":"I never handled the victim's drink.","motive":"No motive."},"contradictions":{"timeline":"Work log supports him.","access":"No link.","motive":"No link."}}
	],
	[{"id":"timeline","label":"When did you reach Platform 7?","evidence":"ticket_scan"},{"id":"access","label":"Did you speak with Adrian?","evidence":"platform_photo"},{"id":"motive","label":"What did Adrian know about the policy?","evidence":"medicine_vial"}],
	["Insurance fraud","Jealousy","Random theft"],["Drugged drink","Push from platform","Blunt force"])

static func case_004() -> Dictionary:
	return _base_case(4,"The Silent Witness","CHAPTER 02 • MOVING TARGETS","MEDIUM","A burglary leaves no broken lock and a terrified witness who suddenly refuses to speak. The house alarm was disabled from inside.","Find the access trail and determine why the witness changed their story.","Mara Velez","Jonah Reed","Blackmail","Stolen access code",
	["alarm_panel","voice_note","garage_remote","shoe_print","safe_invoice"],
	[
	{"id":"alarm_panel","name":"Alarm Panel","rect":Rect2(120,130,110,80),"detail":"The alarm was disabled using an employee code rather than the owner code.","category":"ACCESS","points":20},
	{"id":"voice_note","name":"Voice Note","rect":Rect2(350,180,110,80),"detail":"A recording captures Jonah threatening the witness earlier that evening.","category":"MOTIVE","points":20},
	{"id":"garage_remote","name":"Garage Remote","rect":Rect2(570,350,110,80),"detail":"A spare remote was registered to Jonah's vehicle.","category":"ACCESS","points":20},
	{"id":"shoe_print","name":"Shoe Print","rect":Rect2(760,300,100,80),"detail":"The print matches the tread on Jonah's work boots.","category":"FORENSIC","points":20},
	{"id":"safe_invoice","name":"Safe Repair Invoice","rect":Rect2(850,140,110,80),"detail":"The stolen safe had recently been serviced, giving Jonah knowledge of its mechanism.","category":"MOTIVE","points":20}
	],
	[
	{"id":"jonah","name":"Jonah Reed","role":"Maintenance worker","alibi":"He claims he was repairing a van.","responses":{"timeline":"I never entered the house.","access":"I don't know the alarm code.","motive":"The witness has no reason to fear me."},"contradictions":{"timeline":"The garage remote logs his vehicle.","access":"The employee code belongs to his department.","motive":"The voice note captures the threat."}},
	{"id":"elena","name":"Elena Velez","role":"Sister","alibi":"She was upstairs on a call.","responses":{"timeline":"I stayed upstairs.","access":"I don't know the alarm system.","motive":"I wanted nothing stolen."},"contradictions":{"timeline":"Call records support her.","access":"No code access.","motive":"No threat."}},
	{"id":"paul","name":"Paul Trent","role":"Neighbor","alibi":"He was walking his dog.","responses":{"timeline":"I passed the house once.","access":"I never entered.","motive":"I saw nothing."},"contradictions":{"timeline":"Dog-walk camera supports him.","access":"No access.","motive":"No link."}}
	],
	[{"id":"timeline","label":"Where was your vehicle?","evidence":"garage_remote"},{"id":"access","label":"Who knows the alarm code?","evidence":"alarm_panel"},{"id":"motive","label":"Why did the witness fear you?","evidence":"voice_note"}],
	["Blackmail","Debt","Revenge"],["Stolen access code","Forced entry","Window entry"])

static func case_005() -> Dictionary:
	return _base_case(5,"Room 309","CHAPTER 03 • CLOSED DOORS","HARD","A hotel guest is found unconscious in Room 309. The keycard record shows nobody entered after midnight, yet the poison was administered later.","Solve how the attack happened without a recorded room entry.","Noah Bennett","Clara West","Corporate embezzlement","Contaminated room-service tray",
	["keycard_log","room_service","ice_bucket","invoice_copy","hallway_mirror"],
	[
	{"id":"keycard_log","name":"Keycard Log","rect":Rect2(100,130,110,80),"detail":"No door keycard was used after midnight, ruling out a conventional late entry.","category":"ACCESS","points":20},
	{"id":"room_service","name":"Room-Service Tray","rect":Rect2(330,300,120,80),"detail":"The tray was delivered before midnight and contains the glass used by Noah.","category":"METHOD","points":20},
	{"id":"ice_bucket","name":"Ice Bucket","rect":Rect2(520,180,100,80),"detail":"Meltwater contains traces matching the contaminant in the glass.","category":"FORENSIC","points":20},
	{"id":"invoice_copy","name":"Invoice Copy","rect":Rect2(710,330,110,80),"detail":"Clara approved a concealed company payment to the hotel supplier.","category":"MOTIVE","points":20},
	{"id":"hallway_mirror","name":"Hallway Mirror","rect":Rect2(850,150,100,90),"detail":"The mirror reflection shows Clara leaving the service corridor before midnight.","category":"TIMELINE","points":20}
	],
	[
	{"id":"clara","name":"Clara West","role":"Finance director","alibi":"She says she left the hotel at 23:40.","responses":{"timeline":"I left before midnight.","access":"I never returned to Room 309.","motive":"No company money was missing."},"contradictions":{"timeline":"The mirror places her in the service corridor later than claimed.","access":"No late room entry is needed because the tray was delivered earlier.","motive":"The invoice shows a concealed payment."}},
	{"id":"ethan","name":"Ethan Price","role":"Chef","alibi":"He stayed in the kitchen.","responses":{"timeline":"I worked continuously.","access":"I delivered the tray at 23:10.","motive":"I had no reason to harm Noah."},"contradictions":{"timeline":"Kitchen logs support him.","access":"Delivery occurred before the poisoning window.","motive":"No motive."}},
	{"id":"rhea","name":"Rhea Cole","role":"Guest","alibi":"She was at the bar.","responses":{"timeline":"The bartender saw me.","access":"I never had Noah's key.","motive":"We barely knew each other."},"contradictions":{"timeline":"Bar receipt supports her.","access":"No key.","motive":"No link."}}
	],
	[{"id":"timeline","label":"When did you leave the hotel?","evidence":"hallway_mirror"},{"id":"access","label":"How could poison enter without a room entry?","evidence":"room_service"},{"id":"motive","label":"What payment did you approve?","evidence":"invoice_copy"}],
	["Corporate embezzlement","Jealousy","Random theft"],["Contaminated room-service tray","Direct injection","Forced entry"])

static func get_case(case_id: int) -> Dictionary:
	match case_id:
		1: return case_001()
		2: return case_002()
		3: return case_003()
		4: return case_004()
		5: return case_005()
		_: return {}

static func is_case_available(case_id: int, unlocked_case: int) -> bool:
	return case_id >= 1 and case_id <= MAX_CASES and case_id <= unlocked_case
