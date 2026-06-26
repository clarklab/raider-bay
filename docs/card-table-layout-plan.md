# Raider Bay Card-Table Direction

## Current Pass

- Default shape is landscape: `1460 x 820` native viewport with a matching web shell.
- The old portrait HUD raster is no longer part of the active gameplay layout.
- Gameplay is arranged as a table:
  - left rail: ship camera, fish market, trophies, ship card summary
  - center: bay board as the main play surface
  - right rail: command cards, catch hand, radio/log
  - top rail: day, money, moves, casts, finds, weather deck
- The Balatro-style font lives at `assets/fonts/Balatro.otf` and is the default UI label/button face.

## Card Seams Already In The Game

- Bay squares are hidden location cards: `content`, `species`, `casts_total`, `casts_remaining`, `value`, `zone`, `rating`, and reveal/deplete state.
- Weather is already a deck: `weather_deck`, `current_weather`, and `forecast`.
- Live well batches are a catch hand: `species`, `quantity`, and `age`.
- Ship upgrades are permanent equipment cards; ship conditions are damage counters.
- Market species rows are fish contract cards: price, sold total, and trophy state.

## Next Refactor Steps

1. Add card helper functions around the existing dictionaries before introducing new classes, preserving save compatibility.
2. Extract board geometry into one layout adapter so board, dock, depth rail, and future location cards share sizing.
3. Turn weather into the first explicit deck module because it already has draw/discard semantics and low rule risk.
4. Replace live-well rows with actual catch cards that can later be selected, sold, upgraded, or spent by effects.
5. Promote ship upgrades into equipment-card definitions with display metadata and effect hooks.
