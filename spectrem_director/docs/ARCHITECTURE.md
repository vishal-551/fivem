# Spectrem Director architecture

## Phase 1 — bootstrap
`fxmanifest.lua` loads only local files; it deliberately does not declare hard manifest dependencies. `client/dependencies.lua` and `server/dependencies.lua` inspect the resource state and record one feature flag per integration. This keeps the director functional when an optional integration is unavailable.

## Phase 2 — core and storage
The RPC module creates a single request/response path and wraps handler faults. The oxmysql adapter accepts only identifier-shaped table/column names and always binds data as query parameters. `database/001_spectrem_director.sql` is the base migration; `sql/002_integrity.sql` adds relational constraints after deployment.

## Phase 3 — director workspace
All spawned peds, props, and vehicles are local, non-networked preview entities. The manager owns cleanup on resource stop, enforces per-type limits, bounds model loading to five seconds, and serializes only live records. A saved project is a versionable JSON snapshot of scene entities, weather, and camera presets.

## Phase 4 — integrations
Appearance uses the public Illenium `setPedAppearance` export only when detected. Weather uses the Renewed-Weathersync `setWeather` export when detected, otherwise uses local GTA weather native state. Neither adapter treats an unavailable external resource as fatal.

## Phase 5 — permissions and operations
ACE capabilities are hierarchical: `user`, `director`, `moderator`, `admin`, and `owner`. Only directors may mutate persistent projects and favorites; reads remain owner-scoped by the QB citizen ID or license fallback. Server logs are written asynchronously so request paths are not delayed by observability.
