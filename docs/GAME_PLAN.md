# Casefile: Last Scene — Game Plan

## Product thesis

Build a detective mystery game around a real reasoning loop:

SEARCH → DISCOVER → ANALYZE → CONNECT → INTERROGATE → DEDUCE → ACCUSE

Every player-facing control must execute real game state. No fake completion screens or placeholder wins.

## Long-term scale

The case system has a 1000-case progression boundary and is data-driven so new cases can be authored without rewriting the engine.

A case is not considered playable until its scene, evidence, suspects, dialogue, deductions and outcome logic exist.

## Case model

A case can contain:

- briefing
- victim
- crime scene
- searchable objects
- decisive evidence
- distractions/red herrings
- evidence details
- suspects and alibis
- interrogation questions
- evidence-backed contradictions
- culprit
- motive
- method
- required proof
- result states
- rewards
- unlock rules

## Progression

- 1–3 stars
- XP
- detective rank
- investigation streak
- case unlocking
- persistent local save
- evidence archive

## Current vertical slice

### Case 001 — The Locked Apartment

Implemented as an actual playable investigation with:

- 8 searchable objects
- 5 decisive clues
- 3 distractions
- 3 suspects
- 3 interrogation topics
- evidence challenges
- final accusation
- perfect/partial/failure outcomes
- XP, stars, streak and next-case progression

## Next phases

### Phase 2 — Investigation UX
- visual crime-scene composition
- real object hotspots
- zoom/pan
- clue inspection animation
- multi-evidence deductions
- richer dialogue
- mobile-first investigation controls

### Phase 3 — Content pipeline
- Case 002
- Cases 003–010
- case-data validator
- reusable scene system
- chapter progression
- unique case assets

### Phase 4 — Retention
- daily mystery
- weekly special investigation
- achievements
- detective profile expansion
- case collections
- streak rewards

### Phase 5 — 1000+ production
- 1000+ fully authored investigations
- escalating difficulty
- multi-location cases
- long-form story arcs
- automated content validation

## Quality rule

No dummy buttons, fake counters, automatic wins, or placeholder case completion.
