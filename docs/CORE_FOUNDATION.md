# Phase 2: Core Framework and Database Foundation

## Folder tree

```text
config/core.lua                 Core runtime defaults
shared/config.lua               Safe shared configuration accessor
modules/database.lua            Parameterized oxmysql wrapper
modules/logger.lua              Structured console/database logger
modules/cache.lua               TTL namespaced caches
modules/events.lua              Idempotent event registration
modules/permissions.lua         Role capability API
modules/callbacks_*.lua         Promise-aware callback transport
server/resource_checker.lua     Dependency startup report
server/cache_scheduler.lua      Low-frequency cache cleanup
database/002_core_foundation.sql Phase 2 database migration
```

## Install and migrate

1. Ensure `oxmysql`, `ox_lib`, and `qb-core` before `CineDirector`.
2. Import `sql/001_cinedirector.sql`, then `database/002_core_foundation.sql`, in that order.
3. Review `config/core.lua`. Connection credentials remain owned by oxmysql's normal server configuration.
4. Start the resource and check the server console for the CineDirector dependency report. A missing dependency is explicitly warned about; do not expose the resource to players until every required dependency reports `started`.

## Configuration

`Config.Core` controls debug output, developer mode, expected resource names, default role, ACE prefix, autosave, cache TTL, and cleanup cadence. Change resource-name values only when your server uses renamed dependencies. `Config.Core.permissions.acePrefix` is concatenated with the role, e.g. `cinedirector.director`.

## Database API

All methods use parameter values rather than interpolating values into SQL. Table and column identifiers are restricted to identifier characters.

```lua
local Database = CineDirector.Database
local id = Database.Create('cinedirector_weather_presets', { owner_identifier = citizenId, name = 'Noir', data = json.encode(preset) })
local preset = Database.Find('cinedirector_weather_presets', { id = id })
Database.Update('cinedirector_weather_presets', { name = 'Noir Rain' }, { id = id })
local exists = Database.Exists('cinedirector_weather_presets', { id = id })
Database.Delete('cinedirector_weather_presets', { id = id })
```

Pass a callback as the final argument to `Create`, `Update`, `Delete`, `Find`, `FindAll`, `Exists`, or `Transaction` for oxmysql asynchronous style. Omit it to use the await style from a Citizen thread. Database faults should be caught at service boundaries and logged with `CineDirector.Logger.error`.

## Services API

- `CineDirector.Cache.set(namespace, key, value[, ttl])` and `.get()` provide TTL cache storage. Named helpers read the player, scene, animation, weather, and camera namespaces.
- `CineDirector.EventManager.register(name, handler[, networked])` refuses duplicate registrations.
- `CineDirector.Permissions.has(source, role)` accepts `user`, `director`, `moderator`, `admin`, and `owner`.
- `CineDirector.Callbacks.registerServer(name, handler)` and `CineDirector.Callbacks.awaitServer(name, payload)` offer a promise/await request path.

The cache sweep uses a configurable 60-second wait by default. Database logs are emitted in a detached thread so logging does not add latency to application paths.
