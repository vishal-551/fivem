# CineDirector architecture and operations

## Phase 1 — Architecture
CineDirector is a modular client/server resource. The client owns temporary local cinematic entities and NUI state; the server owns project persistence and authorization. `shared/` contains narrow, dependency-free contracts.

## Phase 2 — Database
Run `sql/001_cinedirector.sql`. Projects persist a self-contained JSON document; dedicated tables support scenes, actors, animation catalogues, camera presets, favorites, user settings, permissions, and immutable save backups. Indexes support owner/project lookups.

## Phase 3 — Framework
QB-Core provides citizen identifiers. ox_lib provides notification and callback primitives. oxmysql is accessed only by parameterized statements. ACE permissions provide `user`, `moderator`, and `admin` gates; use server configuration to delegate ACE roles.

## Phase 4 — UI
The NUI is dependency-free HTML/CSS/JS, dark by default, responsive below 800px, keyboard friendly, and uses CSS-resizable panels. Ctrl+S saves, Ctrl+Z undoes, Ctrl+Shift+Z redoes, and Escape closes.

## Phase 5 — Animation system
`client/animations.lua` safely requests dictionaries before playback and supports loop, preview, and stop. A production animation catalogue can insert user-visible records into `cinedirector_animations`; do not trust browser data as an authorization boundary.

## Phase 6 — Ped and entity system
`client/entities.lua` creates local mission entities, holds one normalized record shape, supports clone/delete/rename, and serializes live placements for saves. Model validity is checked. Appearance integrations should call only documented exports from resources named in `Config.AppearanceResources`.

## Phase 7 — Camera
Freecam is script-camera based and has a single lifetime-bound thread. It supports WASD/Shift movement, FOV state, preset capture, and can be extended with interpolation between `camera_presets` records. Closing freecam destroys the camera.

## Phase 8 — Scene builder
Projects include entities, weather, and timeline cues. Saves are owner-scoped, manual saves create a backup, and autosave is configurable. The timeline runner waits until each cue rather than using a perpetual polling thread.

## Phase 9 — Weather
Weather is per-client cinematic state. It controls GTA weather, clock, and blackout. It intentionally does not force global server weather, preventing interference with ordinary gameplay.

## Phase 10 — Optimization and safety
There are no busy idle loops: freecam and timeline threads exist only while used; autosave sleeps for its configured interval. Entity counts are configured limits intended for UI/server validation extensions. Cleanup temporary entities when ending a production session. Keep NUI payloads compact and never make spawned scene entities networked unless collaboration requires it.

## Phase 11 — Operations
Use a database migration runner or import the supplied SQL once. Back up the database before upgrades. The resource's local entities are director previews, not a synchronization protocol; add server validation and explicit replication before using scenes for shared/public events.

## Extension guide
- Add curated animation records via server endpoints and expose them through the NUI search index.
- Implement project listing with `cinedirector:server:listProjects` through `lib.callback.await`.
- Add transform gizmos by updating a selected local entity then call `CineDirector.Client.pushUndo()` before a transform.
- Add permission overrides using `cinedirector_permissions` and validate every mutating server event.
