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

static func get_case(case_id: int) -> Dictionary:
	if case_id == 1:
		return case_001()
	return {}

static func is_case_available(case_id: int, unlocked_case: int) -> bool:
	return case_id >= 1 and case_id <= MAX_CASES and case_id <= unlocked_case
