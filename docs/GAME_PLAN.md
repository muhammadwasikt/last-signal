# Last Signal — Game Plan

## Product thesis

Build a battle-royale/extraction-inspired shooter where information has direct gameplay value and player death changes role instead of ending participation.

## Core loop

1. Deploy.
2. Search and fight.
3. Recover intelligence caches.
4. Learn the battlefield through partial information.
5. Extract before elimination.
6. If eliminated, transition to Signal Mode.
7. Ping/relay intelligence to surviving squad members.
8. Earn progression and cosmetics.

## Differentiators

### Death becomes Signal
An eliminated player becomes a limited intelligence agent. No shooting or direct damage.

### Information is loot
Intel caches and discovered tactical information are first-class resources.

### Living battlefield
Later versions let squads manipulate power, cameras, gates, bridges and communications.

### Non-traditional endgame
The final phase is extraction-driven rather than only a shrinking-zone gunfight.

## MVP online roadmap

### Phase 1 — Vertical slice
- One map
- 16 simulated combatants
- Core shooting
- Intel + extraction
- Signal Mode
- Android/Web controls

### Phase 2 — Real multiplayer
- Dedicated authoritative server
- 8–16 players
- Match/session service
- Snapshot interpolation
- Server-side hit validation
- reconnect flow

### Phase 3 — 24–40 player matches
- squad parties
- matchmaking
- anti-cheat telemetry
- dynamic battlefield systems
- replay/event capture

### Phase 4 — Retention
- account progression
- operator cosmetics
- seasons
- weekly battlefield state
- challenge missions
- ranked/stat surfaces

### Phase 5 — Monetization
- battle pass
- cosmetic store
- rewarded ads where appropriate
- no pay-to-win weapons or combat stats

## Architecture

One Godot client serves Android and Web. Future services remain outside the client: matchmaking, authoritative game server, identity, profile, telemetry and payments.

Never trust the client for damage, loot ownership, match results or progression.

## Economy

Sell expression, not power: operator cosmetics, weapon cosmetics, vehicle cosmetics, signal effects, banners, emotes and season pass.
