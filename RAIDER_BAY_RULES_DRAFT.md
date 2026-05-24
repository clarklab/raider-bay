# Raider Bay Rules Draft

Status: reverse-engineered first pass from `raiderbay_board.pdf`, `vg-board-1.png`, `vg-board-2.png`, and `vg-fish-market.png`.

This document is written as plain-English rules with explicit state terms. Anything marked `UNKNOWN` or `INFERRED` should be treated as a design question, not a final fact.

## Source Confidence

- `CONFIRMED`: visible in the provided assets or directly described by Clark.
- `INFERRED`: strongly implied by the assets and remembered play pattern.
- `UNKNOWN`: needs memory, playtesting, or a design choice.

## Game Summary

Raider Bay is a push-your-luck fishing game. Each player controls a boat that leaves the docks, explores hidden bay squares, finds fish or treasure, and returns to the docks to sell catches before they spoil.

The player with the most money at the end of the game wins. In solitaire play, the goal is to finish with the highest possible money total while surviving.

The main tension is whether to return to safety or stay out longer for deeper, richer catches while fish age, weather approaches, and rival boats may attack.

## Components Visible In The Assets

### Digital Prototype

- A bay grid with 7 columns.
- The video screenshots show 7 rows.
- Three depth bands are visible:
  - Bottom band: `33%`
  - Middle band: `62%`
  - Top band: `71%`
- These percentages describe how likely/good catches are in deeper waters.
- A dock space centered below the bay grid.
- A current weather display.
- A visible weather forecast.
- A live well display with fish grouped by age.
- A fish market with randomized prices.
- An action menu with:
  - `Find Fish`
  - `Cast`
  - `End Day`
- Movement and fish-finder counters:
  - `Moves`
  - `Finds`

### Printable Board Game PDF

- One game board.
- 72 unique location discs.
- 6 boat trackers.
- 60 clip indicators.
- 6 live well tracks with pop-out trophy discs.
- 25 weather cards.
- 4 colored dice.
- 6 wooden fishing boats.

## Fish Species

Use the board-game fish names for this ruleset.

The digital prototype and the printable board use different fish names, but the recreated game should follow the printable board.

### Digital Prototype Fish

These are the five fish visible in the video-game market screenshot:

- Flounder
- Carp
- Mahi-Mahi
- Snapper
- Trevally

### Printable Board Fish

These are the six fish printed on the PDF location discs:

- Tuna
- Salmon
- Grouper
- Halibut
- Swordfish
- Cod

`CONFIRMED`: use the printable board fish names in the reconstructed rules.

## Main Player State

Each player has:

- Money.
- Boat position.
- Fish in the live well, grouped by age.
- Boat upgrade ratings.
- Boat condition ratings.
- Trophy progress.

## Boat Upgrades

The printable boat tracker has these upgrade tracks around the outside. Each track appears to run from `0` to `4`, then `MAX`.

- Motor
- Fish Finder
- Nets
- Live Well
- Cannons
- Defense

### Motor

`INFERRED`: Motor is the boat's normal movement allowance. The video game screenshot shows `Moves 2`, which is likely the starting motor value.

### Fish Finder

`CONFIRMED`: Fish Finder controls how many times a player can use `Find Fish` during a day or turn. The screenshot shows `Finds 0`, matching the memory that players start with no fish-finder uses.

### Nets

`CONFIRMED/INFERRED`: Nets increase the number of fish caught when a cast succeeds. Clark remembers each nets upgrade as `+1 fish` on a successful catch.

### Live Well

`CONFIRMED/INFERRED`: Live Well controls how long fish can remain aboard before they spoil. Higher live well ratings let the player stay out longer before returning to sell.

### Cannons

`CONFIRMED`: Cannons are used when attacking another boat.

### Defense

`CONFIRMED`: Defense is used when defending against another boat's attack.

## Boat Condition And Damage

The printable boat tracker has four condition tracks in the center. Each appears to run from `0` to `10`.

- Hull
- Propeller
- Rudder
- Nets

`INFERRED`: These are damageable boat systems. They are separate from upgrades. For example, the outer `Motor` upgrade controls how powerful the motor is, while the inner `Propeller` condition controls whether movement is impaired by damage.

### Hull

Hull is the boat's survival condition. If hull reaches zero or below, the boat sinks.

### Propeller

`INFERRED`: Propeller damage reduces or caps movement. Motor probably sets the maximum move rating, while propeller condition determines whether the boat can actually use that movement.

### Rudder

`CONFIRMED`: Rudder appears only as an inner condition/damage track, not as an outer upgrade track.

`CONFIRMED`: The compass in the video UI was decorative and had no game meaning. Heading/facing is not a game mechanic.

`UNKNOWN`: Rudder likely affects maneuverability when damaged, but the exact penalty is not confirmed.

### Nets Condition

`INFERRED`: Nets condition determines whether the nets upgrade works at full strength. Damaged nets may reduce catch quantity or remove the nets bonus until repaired.

## Board Layout

### Board Size

Use a `7 x 8` bay grid for this ruleset, plus a separate dock space below the bottom center.

The video-game screenshots show a `7 x 7` bay grid, but the printable board appears to show `7 x 8`. Clark confirmed that the reconstructed rules should use `7 x 8`.

Rows should be described from the docks upward:

- Bottom/departure zone: lowest rows, lowest catch quality or chance.
- Middle zone: middle rows, better catch quality or chance.
- Top/deep zone: highest rows, best catch quality or chance.

The screenshots label the depth bands as:

- `33%`
- `62%`
- `71%`

`CONFIRMED`: These percentages describe how likely/good the catch is in that depth band. Deeper water has better fishing.

`CONFIRMED`: The depth rating affects all catch-quality axes:

- Chance of finding fish or treasure instead of an empty square.
- Catch quantity.
- Species/value quality.

`UNKNOWN`: exact formula for applying the percentage to those three axes.

## Hidden Bay Contents

Each bay square has hidden contents until found or cast into.

Possible contents:

- Empty
- Fish
- Treasure

For fish contents, the square also has:

- Fish species.
- Total number of casts the hole holds (the "size" of the school).
- A current `casts_remaining` counter, decremented every time a player casts on the square.

`CONFIRMED`: Each fish hole has a fixed number of casts that can be drawn from it. Once `casts_remaining` reaches zero, the square is depleted.

Working pool of starting cast counts per hole: `{1, 2, 3, 5}`, weighted by depth. Deeper holes hold more casts.

### Printable Location Disc Distribution

The PDF contains 72 location discs. The fronts show:

- 36 fish discs:
  - 6 Tuna
  - 6 Salmon
  - 6 Grouper
  - 6 Halibut
  - 6 Swordfish
  - 6 Cod
- 34 Empty discs.
- 1 `$100 Treasure` disc.
- 1 `$200 Treasure` disc.

The backs show number patterns. The visible base quantities repeat as:

- `2`
- `3`
- `3`
- `4`
- `5`
- `6`

`INFERRED`: these backs are probably used to determine catch quantity. The extra numbers around each disc edge may be used with random disc orientation, a die roll, or depth-zone modifiers.

`UNKNOWN`: whether the physical game places one double-sided disc per square, uses the disc back as quantity, or uses dice separately after revealing a fish.

## Turn / Day Structure

The game is played over a fixed number of days.

`INFERRED`: the remembered computer game likely used 7 days.

Each day has this structure:

1. Advance or reveal weather.
2. Refresh the active player's daily counters:
   - Moves from Motor/Propeller.
   - Finds from Fish Finder.
   - Casts from the relevant cast allowance.
3. The player takes actions:
   - Move.
   - Find Fish.
   - Cast.
   - Attack, if multiplayer and adjacent to another boat.
   - Return to docks.
   - End Day.
4. At the end of the day/night:
   - Weather affects boats that are away from the docks.
   - Fish in live wells age.
   - Fish that exceed the player's live well capacity spoil.
   - Weather forecast shifts.

## Movement

Players move orthogonally on the grid: north, south, east, or west. Diagonal movement is not allowed.

Each move spends 1 move point.

Boats start at the docks. The docks are centered below the bay grid.

`INFERRED`: entering or leaving the docks costs movement like entering a normal adjacent space.

`CONFIRMED`: boat facing does not matter.

`UNKNOWN`: what movement penalty rudder damage creates. It should not be modeled as enabling or disabling diagonal movement.

## Finding Fish

`Find Fish` is a scouting action.

Rules:

- The player must have at least 1 fish-finder use remaining.
- The player chooses the current square or an adjacent/targeted square.
- The fish finder reveals whether the target contains something catchable.
- The fish finder does not collect fish or treasure.
- Using the fish finder spends 1 `Find`.
- Finding fish does not spend a move.

`UNKNOWN`: exact target range. The remembered play pattern sounds like the player finds the square they are currently in, then casts if it is good.

## Casting

`Cast` is the action that catches fish from a hole.

Rules:

- The player casts on the square the boat is currently in.
- Spends one of the player's daily casts.
- If the square is empty, nothing is gained and the square is marked depleted.
- If the square contains fish:
  - Reveal the fish species (if not already revealed).
  - Roll a die to determine fish caught on this cast (see `Catch Quantity`).
  - Add the player's nets bonus to that roll, if nets are functioning.
  - Add the rolled total to the player's live well as `Fresh`.
  - Decrement `casts_remaining` on the hole. If it hits zero, the hole is depleted.
- If the square contains treasure:
  - Reveal the treasure.
  - Add the treasure money immediately.
  - Treasure resolves in a single cast and depletes the square.

`CONFIRMED`: A single fish hole supports multiple casts. Each cast draws a fresh dice roll worth of fish, until the hole is depleted.

`CONFIRMED`: casting does not spend a move. Casting spends a cast.

`UNKNOWN`: the starting cast allowance and how casts are upgraded or refreshed. Working value: 3 casts per day.

## Catch Quantity

Each cast on a fish hole produces a fresh die-rolled quantity. The hole's `casts_remaining` is a separate counter.

Working rule for the digital recreation:

1. When the player casts on a fish hole, roll a die (working value: 1d4 → 1–4 fish per cast).
2. Add the player's nets bonus (`+1` fish per nets level), if nets are functioning.
3. Store that quantity in the live well as `Fresh`.
4. Decrement `casts_remaining` by 1.
5. When `casts_remaining` reaches 0, the hole is depleted.

`CONFIRMED`: Nets upgrades add `+1` fish to every cast roll.

`CONFIRMED`: deeper zones are better. The visible depth ratings are `33%`, `62%`, and `71%`. They affect chance, hole capacity (`casts_remaining`), and fish quality/value.

`UNKNOWN`: exact die size for the per-cast roll. The recreation currently uses 1d4. Clark's recollection of 2-, 5-, and 6-fish catches likely reflects rolls plus nets bonus.

## Live Well And Spoilage

Fish are tracked by species, quantity, and age.

Age categories visible in the digital screenshot:

- Fresh
- 1 Day
- 2 Day
- 3 Day

Age categories printed on the PDF live well tracks:

- Fresh
- 1 Day Old
- 2 Day Old
- 3 Day Old
- 4 Day Old
- 5 Day Old
- 6 Day Old

Rules:

- Fish caught today enter the live well as `Fresh`.
- At the end of each day, all unsold fish age by 1 day.
- If fish become older than the player's live well capacity, they spoil and are removed.
- Fish can be sold only at the docks.

`INFERRED`: Live Well upgrades increase the maximum safe age.

## The Docks

The docks are the safe home space.

At the docks, players can:

- Sell fish at current market prices.
- Repair damaged boat systems.
- Buy upgrades.
- Shelter from weather.

`INFERRED`: weather does not damage boats that are in the docks.

`UNKNOWN`: whether docking automatically sells all fish or whether the player chooses what to sell.

## Fish Market

Each game randomizes fish prices.

The screenshot shows this market:

- Flounder: `$22`
- Carp: `$30`
- Mahi-Mahi: `$27`
- Snapper: `$23`
- Trevally: `$32`

Rules:

- When a player sells fish at the docks, each fish is worth its current species price.
- Sale value is `quantity x fish price`.
- Prices may stay fixed for the whole game or refresh periodically.

`UNKNOWN`: whether prices change during a game. Clark remembers fish values being random each game, but not necessarily changing during play.

## Trophies

Trophy icons appear in the fish market screenshot. The PDF live well tracks also contain pop-out discs labeled `Trophy`.

`INFERRED`: trophies are awards for selling enough of a fish species or making a notable catch.

`UNKNOWN`: exact trophy trigger. Possibilities:

- First player to sell each fish species earns that species trophy.
- A player earns a trophy by selling a threshold quantity of one species.
- A player earns a trophy by catching or selling a maximum-size catch.
- Trophy discs are physical placeholders used by the board-game live well rather than scoring awards.

## Weather

Weather is visible before it hits, creating the push-your-luck decision about staying out.

### Digital Weather

The screenshots show:

- Current weather: `Clear`
- Forecast items including:
  - `Storm`
  - `Squall`
  - `Clear`

### Printable Weather Deck

The PDF has 25 weather cards:

- 15 Clear cards.
- 6 Storms cards:
  - Storms 5
  - Storms 4
  - Storms 4
  - Storms 3
  - Storms 3
  - Storms 2
- 4 Hurricane cards:
  - Hurricane 5
  - Hurricane 4
  - Hurricane 3
  - Hurricane 2

Rules:

- Clear weather causes no damage.
- Storm/Squall/Hurricane weather can damage boats that are away from the docks.
- The number on a weather card is the storm strength.

`UNKNOWN`: exact damage formula.

## Weather Damage

Working model:

1. At night, reveal or resolve the current weather.
2. If the weather is Clear, nothing happens.
3. If the weather is hazardous, each boat away from docks suffers weather damage.
4. Weather strength determines how hard the damage roll is or how much damage a failed roll causes.
5. Damage can affect:
   - Hull
   - Propeller
   - Rudder
   - Nets

`INFERRED`: weather damage should involve dice, so a boat can get lucky and survive even severe weather such as a hurricane.

`UNKNOWN`: how storm strength maps to dice and damage:

- It may be a difficulty number.
- It may be compared against dice.
- It may determine how many colored dice are rolled.

## Combat

Boats can attack each other when close enough.

`CONFIRMED`: the printable board says:

- Red/Green dice are used for attacker/defender.
- Red/Yellow/Green/Blue dice are used to determine damage.

Working attack rule:

1. Attacker must be adjacent to the defender.
2. Attacker rolls the red die and adds Cannons.
3. Defender rolls the green die and adds Defense.
4. If attacker total is greater than defender total, the attack hits.
5. On a hit, determine damage with the colored dice.

`UNKNOWN`: whether ties hit, whether range can be upgraded, and how damage is assigned.

## Damage Assignment

The four damageable systems are:

- Hull
- Propeller
- Rudder
- Nets

The four damage dice are:

- Red
- Yellow
- Green
- Blue

`INFERRED`: the four dice probably map to the four damageable systems, but the asset does not label the mapping.

Possible mapping for a temporary implementation:

- Red: Hull
- Yellow: Propeller
- Green: Rudder
- Blue: Nets

`UNKNOWN`: this mapping needs confirmation.

## Repairs

Repairs happen at the docks.

Rules:

- A player at the docks can restore damaged systems.
- Repair probably costs money.
- Hull, Propeller, Rudder, and Nets can be repaired independently.

`UNKNOWN`: repair cost and whether docking gives any free repair.

## Upgrades

Upgrades happen at the docks.

Upgradeable systems:

- Motor
- Fish Finder
- Nets
- Live Well
- Cannons
- Defense

`UNKNOWN`: upgrade costs.

`INFERRED`: upgrades are a core progression loop because deeper fishing requires better movement, longer fish storage, and stronger survival/combat tools.

## End Of Game

`INFERRED`: the game lasts 7 days.

At the end of the final day:

- Sell any fish that are legally sellable at the docks.
- Unsold fish away from the docks may not count.
- Add treasure and trophy bonuses if applicable.
- Highest money wins.

`UNKNOWN`: whether the game ends immediately after Day 7, after the final night, or after players get one last docking/selling opportunity.

## Agent-Readable Rule Invariants

Use these as implementation constraints unless later corrected.

- Every bay square has exactly one hidden content record.
- Hidden contents are one of `empty`, `fish`, or `treasure`.
- A `fish` content record has `species`, `casts_total`, and `casts_remaining`. Depth-zone affects which species spawn and how many casts the hole starts with.
- Fish Finder reveals information about a square but never catches fish or removes contents. After a Find, the square's species and `casts_remaining` are visible to the player.
- Each Cast on a fish hole catches a die-rolled quantity (`1d4 + nets`) and decrements `casts_remaining` by 1. The hole depletes when `casts_remaining` reaches 0.
- Each Cast on a treasure square recovers the full treasure value and depletes the square in one cast.
- Fish Finder and Cast do not spend movement points.
- Fish Finder spends one `Find`; Cast spends one `Cast`.
- Fish carried by a boat has `species`, `quantity`, and `age`.
- Fish age once per day.
- Fish older than live-well capacity spoil.
- Money is gained by selling fish at the docks and by treasure.
- The docks are safe from weather.
- Weather forecast is visible before it resolves.
- Hazardous weather can damage boats away from docks.
- Hull at zero or below means the boat sinks.
- Boat upgrades and boat condition are separate state variables.

## Top Open Questions

1. Did the game last exactly 7 days?
2. At the start of a new game, what were the starting upgrade values? Known likely values: `Moves 2`, `Finds 0`.
3. What determines the number of casts available each day?
4. Did Fish Finder check the current square only, or could it target adjacent/future squares?
5. Did Fish Finder reveal only "something is here", the exact fish/treasure type, or the catch amount too?
6. What exact formula applied the `33%`, `62%`, and `71%` depth ratings to chance, quantity, and species/value quality?
7. How did the token/disc backs determine catch quantity?
8. How exactly did Motor, Propeller, and Rudder damage interact with movement?
9. What movement penalty did Rudder damage create?
10. How did the weather dice roll work?
11. What is the mapping from colored dice to damaged systems?
12. How were upgrade and repair costs determined?
13. How were trophies earned, and did trophies affect score or just mark achievements?
